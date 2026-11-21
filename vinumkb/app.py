from collections import deque
from datetime import datetime
from flask import Flask, render_template, request, abort, jsonify
import os
import sqlite3
import time

app = Flask(__name__)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

QUERY_LOG = deque(maxlen=40)

DISHES = ['Стейк и красное мясо', 'Барбекю и шашлык', 'Рыба', 'Морепродукты', 'Птица',
          'Паста и пицца', 'Сыры', 'Салаты и закуски', 'Острая кухня', 'Десерты']
_wine_cache = {'mtime': None, 'names': []}


def _find_photo(prefix):
    for ext in ('jpg', 'jpeg', 'png', 'webp'):
        fn = f'{prefix}.{ext}'
        if os.path.exists(os.path.join(BASE_DIR, 'static', 'photos', fn)):
            return f'/static/photos/{fn}'
    return None


def wine_photo(name):
    if not _wine_cache['names'] or _wine_cache['mtime'] != os.path.getmtime(DB_PATH):
        con = connect()
        _wine_cache['names'] = [r['name'] for r in con.execute('SELECT name FROM wines ORDER BY id')]
        con.close()
        _wine_cache['mtime'] = os.path.getmtime(DB_PATH)
    if name not in _wine_cache['names']:
        return None
    return _find_photo('wine_%02d' % (_wine_cache['names'].index(name) + 1))


def dish_photo(name):
    if name not in DISHES:
        return None
    return _find_photo('dish_%02d' % (DISHES.index(name) + 1))


app.jinja_env.globals.update(wine_photo=wine_photo, dish_photo=dish_photo)



DB_PATH = os.path.join(BASE_DIR, 'vinumkb.db')
SQL_PATH = os.path.join(BASE_DIR, 'vinumkb.sql')


def connect():
    """Подключение к SQLite. Если файла БД нет, он создаётся из vinumkb.sql."""
    if not os.path.exists(DB_PATH):
        init = sqlite3.connect(DB_PATH)
        with open(SQL_PATH, 'r', encoding='utf-8') as f:
            init.executescript(f.read())
        init.commit()
        init.close()
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


def get_kb():
    """Читает базу знаний из SQL и собирает структуру, которую ждут шаблоны."""
    con = connect()
    try:
        aromas, foods, rule_wines = {}, {}, {}
        for r in con.execute('SELECT wine_id, aroma FROM wine_aromas ORDER BY wine_id, position'):
            aromas.setdefault(r['wine_id'], []).append(r['aroma'])
        for r in con.execute('SELECT wine_id, food FROM wine_foods ORDER BY wine_id, position'):
            foods.setdefault(r['wine_id'], []).append(r['food'])
        for r in con.execute('SELECT rule_id, wine_name FROM rule_wines ORDER BY rule_id, position'):
            rule_wines.setdefault(r['rule_id'], []).append(r['wine_name'])

        wines = []
        for r in con.execute('SELECT * FROM wines ORDER BY id'):
            w = dict(r)
            wid = w.pop('id')
            w['aromas'] = aromas.get(wid, [])
            w['foods'] = foods.get(wid, [])
            wines.append(w)

        rules = [{
            'id': r['id'],
            'if': {'dish': r['dish'], 'wine_type': r['wine_type']},
            'then': {'wines': rule_wines.get(r['id'], []), 'explanation': r['explanation']},
        } for r in con.execute('SELECT * FROM rules ORDER BY id')]

        return {
            'wines': wines,
            'articles': [dict(r) for r in con.execute('SELECT * FROM articles ORDER BY id')],
            'ontology': {
                'concepts': [{'name': r['name'], 'category': r['category'], 'description': r['description']}
                             for r in con.execute('SELECT * FROM concepts ORDER BY id')],
                'relations': [{'from': r['from_concept'], 'type': r['type'], 'to': r['to_concept'],
                               'description': r['description']}
                              for r in con.execute('SELECT * FROM relations ORDER BY id')],
            },
            'rules': rules,
            'videos': [{**dict(r), 'desc': r['description']} for r in con.execute('SELECT * FROM videos ORDER BY id')],
        }
    finally:
        con.close()


def log_query(mode, summary, found, elapsed_ms):
    QUERY_LOG.appendleft({
        'time': datetime.now().strftime('%H:%M:%S'),
        'mode': mode,
        'summary': summary,
        'found': found,
        'elapsed_ms': elapsed_ms,
    })


def build_stats(kb):
    wines = kb['wines']
    triples_count = sum(4 + len(w.get('foods', [])) + len(w.get('aromas', [])) for w in wines)
    return {
        'wines': len(wines),
        'articles': len(kb['articles']),
        'concepts': len(kb['ontology']['concepts']),
        'relations': len(kb['ontology']['relations']),
        'rules': len(kb['rules']),
        'triples': triples_count,
    }


def search_all(query, wine_type='', section='', record=True):
    t0 = time.perf_counter()
    kb = get_kb()
    q = query.lower().strip()
    words = [w for w in q.split() if len(w) > 1]

    result = {'wines': [], 'articles': [], 'concepts': []}
    if not words and not wine_type:
        return result, 0.0

    if section in ('', 'wines'):
        for wine in kb['wines']:
            if wine_type and wine['type'] != wine_type:
                continue
            if not words:
                result['wines'].append(wine)
                continue
            text = ' '.join([
                wine['name'], wine['type'], wine.get('sweetness', ''),
                wine['grape'], wine['region'], wine['country'],
                wine['price_segment'], wine['description'],
                ' '.join(wine.get('foods', [])),
                ' '.join(wine.get('aromas', [])),
            ]).lower()
            if all(word in text for word in words):
                result['wines'].append(wine)

    if section in ('', 'articles') and words:
        for article in kb['articles']:
            text = (
                article['title'] + ' ' + article['content'] + ' ' +
                article.get('category', '')
            ).lower()
            if all(word in text for word in words):
                result['articles'].append(article)

    if section in ('', 'concepts') and words:
        for concept in kb['ontology']['concepts']:
            text = (
                concept.get('name', '') + ' ' +
                concept.get('category', '') + ' ' +
                concept.get('description', '')
            ).lower()
            if all(word in text for word in words):
                result['concepts'].append(concept)

    elapsed_ms = round((time.perf_counter() - t0) * 1000, 3)
    if record and (words or wine_type):
        total = len(result['wines']) + len(result['articles']) + len(result['concepts'])
        log_query('Поиск', query or wine_type, total, elapsed_ms)

    return result, elapsed_ms


def recommend(dish, wine_type, budget='', record=True):
    t0 = time.perf_counter()
    kb = get_kb()
    dish_l = dish.lower().strip()
    type_l = wine_type.lower().strip()

    def within_budget(w):
        if not budget or budget == 'Любой':
            return True
        return w.get('price_segment', '') == budget

    for rule in kb['rules']:
        cond = rule['if']
        if cond.get('dish', '').lower() == dish_l and cond.get('wine_type', '').lower() == type_l:
            names = rule['then'].get('wines', [])
            matched = [w for w in kb['wines'] if w['name'] in names and within_budget(w)]
            if matched:
                elapsed_ms = round((time.perf_counter() - t0) * 1000, 3)
                if record:
                    log_query('Подбор', f'{dish} · {wine_type} · {budget or "Любой"}', len(matched), elapsed_ms)
                return {'rule': rule, 'wines': matched, 'elapsed_ms': elapsed_ms}

    dish_rules = [r for r in kb['rules'] if r['if'].get('dish', '').lower() == dish_l]
    rule_wine_names = [n for r in dish_rules for n in r['then'].get('wines', [])]

    matched = []
    for wine in kb['wines']:
        type_ok = (not type_l or type_l == 'любое' or wine['type'].lower() == type_l)
        food_ok = any(dish_l in f.lower() or f.lower() in dish_l for f in wine.get('foods', []))
        if type_ok and within_budget(wine) and (food_ok or wine['name'] in rule_wine_names):
            matched.append(wine)

    elapsed_ms = round((time.perf_counter() - t0) * 1000, 3)
    if record:
        log_query('Подбор', f'{dish} · {wine_type or "Любое"}', len(matched), elapsed_ms)

    if not matched:
        return None

    return {
        'rule': {
            'id': 'SEM-AUTO',
            'if': {'dish': dish, 'wine_type': wine_type or 'Любое'},
            'then': {
                'explanation': (
                    f'Применён семантический вывод по связям «pairs_with» для категории «{dish}»'
                    + (f' с фильтром типа «{wine_type}»' if wine_type and wine_type != 'Любое' else '')
                    + (f' и бюджета «{budget}».' if budget and budget != 'Любой' else '.')
                ),
            },
        },
        'wines': matched,
        'elapsed_ms': elapsed_ms,
    }


@app.route('/')
def index():
    kb = get_kb()
    stats = build_stats(kb)

    topic_map = {}
    for a in kb['articles']:
        cat = a.get('category', 'Общее')
        topic_map[cat] = topic_map.get(cat, 0) + 1

    topic_descriptions = {
        'Гастрономия': 'Правила сочетания блюд, соусов, сыров и вин.',
        'Основы дегустации': 'Танины, кислотность, тело и структура напитка.',
        'Сервировка': 'Температура подачи, форма бокала и декантация.',
        'Сорта винограда': 'Ключевые красные и белые сорта виноделия.',
        'Регионы и стили': 'Чтение этикеток, Старый и Новый Свет, игристые.',
    }
    topics = [
        {'name': k, 'count': v, 'desc': topic_descriptions.get(k, 'Практические материалы сомелье.')}
        for k, v in topic_map.items()
    ]

    grouped_concepts = {}
    for c in kb['ontology']['concepts']:
        cat = c.get('category', 'Другое')
        grouped_concepts.setdefault(cat, []).append(c)

    return render_template(
        'index.html',
        stats=stats,
        topics=topics,
        articles=kb['articles'][:6],
        grouped_concepts=grouped_concepts,
        videos=kb['videos'][:3],
    )


@app.route('/articles')
def articles_list():
    kb = get_kb()
    cat = request.args.get('category', '').strip()
    categories = sorted({a.get('category', 'Общее') for a in kb['articles']})
    items = [a for a in kb['articles'] if not cat or a.get('category') == cat]
    return render_template('articles.html', articles=items, categories=categories, active_cat=cat)


@app.route('/article/<int:aid>')
def article_detail(aid):
    kb = get_kb()
    article = next((a for a in kb['articles'] if a['id'] == aid), None)
    if not article:
        abort(404)
    same = [a for a in kb['articles'] if a['id'] != aid and a.get('category') == article.get('category')]
    other = [a for a in kb['articles'] if a['id'] != aid and a.get('category') != article.get('category')]
    return render_template('article.html', article=article, recommended=(same + other)[:3])


@app.route('/videos')
def videos_list():
    kb = get_kb()
    cat = request.args.get('category', '').strip()
    topics = sorted({v['topic'] for v in kb['videos']})
    items = [v for v in kb['videos'] if not cat or v['topic'] == cat]
    return render_template('videos.html', videos=items, topics=topics, active_cat=cat)


@app.route('/library')
def library_view():
    kb = get_kb()
    return render_template('library.html', all_articles=kb['articles'])


@app.route('/search')
def search_view():
    query = request.args.get('q', '')
    wine_type = request.args.get('type', '')
    section = request.args.get('section', '')
    if query.strip() or wine_type:
        results, elapsed_ms = search_all(query, wine_type=wine_type, section=section)
    else:
        results, elapsed_ms = {'wines': [], 'articles': [], 'concepts': []}, 0.0
    return render_template(
        'search.html',
        query=query,
        wine_type=wine_type,
        section=section,
        results=results,
        elapsed_ms=elapsed_ms,
    )


@app.route('/concepts')
def concepts_view():
    kb = get_kb()
    q = request.args.get('q', '').strip().lower()
    grouped = {}
    for c in kb['ontology']['concepts']:
        if q and q not in c['name'].lower() and q not in c['description'].lower():
            continue
        grouped.setdefault(c.get('category', 'Другое'), []).append(c)
    return render_template('concepts.html', grouped=grouped, query=request.args.get('q', ''))


@app.route('/graph')
def graph_view():
    kb = get_kb()
    rel_types = sorted({r['type'] for r in kb['ontology']['relations']})
    return render_template('graph.html', rel_types=rel_types)


@app.route('/api/graph')
def api_graph():
    kb = get_kb()
    concepts = kb['ontology']['concepts']
    relations = kb['ontology']['relations']
    return jsonify({'concepts': concepts, 'relations': relations})


@app.route('/recommend', methods=['GET', 'POST'])
def recommend_view():
    if request.method == 'POST':
        dish = request.form.get('dish', '')
        wine_type = request.form.get('wine_type', 'Любое')
        budget = request.form.get('budget', 'Любой')
    else:
        dish = request.args.get('dish', '')
        wine_type = request.args.get('wine_type', 'Любое')
        budget = request.args.get('budget', 'Любой')

    kb = get_kb()
    dishes = sorted({r['if']['dish'] for r in kb['rules']})
    wine_types = ['Любое', 'Красное', 'Белое', 'Розовое', 'Игристое']
    budgets = ['Любой', 'Бюджетный', 'Средний', 'Премиум']
    result = recommend(dish, wine_type, budget) if dish else None

    return render_template(
        'recommend.html',
        dish=dish,
        wine_type=wine_type,
        budget=budget,
        dishes=dishes,
        wine_types=wine_types,
        budgets=budgets,
        rules=kb['rules'],
        result=result,
    )


@app.route('/wines')
def wines_catalog():
    kb = get_kb()
    return render_template('wines.html', wines=kb['wines'])


@app.route('/wine/<path:name>')
def wine_detail(name):
    kb = get_kb()
    wine = next((w for w in kb['wines'] if w['name'] == name), None)
    if not wine:
        abort(404)
    related = [
        w for w in kb['wines']
        if w['name'] != name and (w['grape'] == wine['grape'] or w['country'] == wine['country'])
    ][:3]
    triples = [
        ('тип', wine['type']),
        ('сладость', wine.get('sweetness', 'Сухое')),
        ('сорт', wine['grape']),
        ('страна', wine['country']),
        ('регион', wine['region']),
        ('сегмент', wine['price_segment']),
    ] + [('сочетается_с', f) for f in wine.get('foods', [])]
    return render_template('wine.html', wine=wine, related=related, triples=triples)


@app.route('/stats')
@app.route('/stats/')
def stats_view():
    kb = get_kb()
    return render_template('stats.html', stats=build_stats(kb), query_log=list(QUERY_LOG))


@app.route('/api/benchmark', methods=['POST'])
def api_benchmark():
    queries = ['стейк', 'рыба', 'франция', 'вишня', 'шампанское', 'сыр', 'италия', 'кислотность']
    dishes = ['Стейк и красное мясо', 'Рыба', 'Морепродукты', 'Паста и пицца', 'Десерты', 'Сыры']
    latencies = []
    t0 = time.perf_counter()
    for i in range(100):
        if i % 2 == 0:
            _, ms = search_all(queries[i % len(queries)], record=False)
        else:
            res = recommend(dishes[i % len(dishes)], 'Любое', record=False)
            ms = res['elapsed_ms'] if res else 0.1
        latencies.append(ms)
    total_ms = round((time.perf_counter() - t0) * 1000, 2)
    avg_ms = round(sum(latencies) / len(latencies), 3)
    qps = round(100 / (total_ms / 1000), 1) if total_ms > 0 else 0
    log_query('Исследование', 'Контрольный тест (100 запросов)', 100, total_ms)
    return jsonify({
        'iterations': 100,
        'total_ms': total_ms,
        'avg_ms': avg_ms,
        'min_ms': round(min(latencies), 3),
        'max_ms': round(max(latencies), 3),
        'qps': qps,
    })


if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)