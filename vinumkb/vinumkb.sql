-- vinumkb: реляционная база знаний по подбору вина (SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE wines (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL UNIQUE,
    type          TEXT NOT NULL,          -- Красное / Белое / Розовое / Игристое
    sweetness     TEXT NOT NULL,          -- Сухое / Полусухое / Полусладкое / Сладкое
    grape         TEXT NOT NULL,
    region        TEXT NOT NULL,
    country       TEXT NOT NULL,
    price_segment TEXT NOT NULL,          -- Бюджетный / Средний / Премиум
    price_byn     INTEGER NOT NULL,
    serving_temp  TEXT NOT NULL,
    glass         TEXT NOT NULL,
    description   TEXT NOT NULL
);
CREATE TABLE wine_aromas (
    wine_id  INTEGER NOT NULL REFERENCES wines(id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    aroma    TEXT NOT NULL,
    PRIMARY KEY (wine_id, position)
);
CREATE TABLE wine_foods (
    wine_id  INTEGER NOT NULL REFERENCES wines(id) ON DELETE CASCADE,
    position INTEGER NOT NULL,
    food     TEXT NOT NULL,
    PRIMARY KEY (wine_id, position)
);
CREATE TABLE articles (
    id        INTEGER PRIMARY KEY,
    title     TEXT NOT NULL,
    category  TEXT NOT NULL,
    read_time TEXT NOT NULL,
    tip       TEXT,
    content   TEXT NOT NULL
);
CREATE TABLE concepts (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL UNIQUE,
    category    TEXT NOT NULL,
    description TEXT NOT NULL
);
CREATE TABLE relations (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    from_concept TEXT NOT NULL,
    type         TEXT NOT NULL,           -- is_a, pairs_with, balances ...
    to_concept   TEXT NOT NULL,
    description  TEXT
);
CREATE TABLE rules (
    id          TEXT PRIMARY KEY,         -- R01, R02 ...
    dish        TEXT NOT NULL,
    wine_type   TEXT NOT NULL,
    explanation TEXT NOT NULL
);
CREATE TABLE rule_wines (
    rule_id   TEXT NOT NULL REFERENCES rules(id) ON DELETE CASCADE,
    position  INTEGER NOT NULL,
    wine_name TEXT NOT NULL,
    PRIMARY KEY (rule_id, position)
);
CREATE TABLE videos (
    id          INTEGER PRIMARY KEY,
    title       TEXT NOT NULL,
    topic       TEXT NOT NULL,
    description TEXT NOT NULL,
    url         TEXT NOT NULL,            -- ссылка на YouTube
    icon_kind   TEXT NOT NULL,            -- dish / cat
    icon        TEXT NOT NULL
);
CREATE INDEX idx_wines_type ON wines(type);
CREATE INDEX idx_articles_category ON articles(category);
CREATE INDEX idx_rules_dish ON rules(dish, wine_type);
CREATE INDEX idx_relations_from ON relations(from_concept);
CREATE INDEX idx_relations_to ON relations(to_concept);

BEGIN TRANSACTION;
INSERT INTO "wines" VALUES(1,'Château Margaux Reserve','Красное','Сухое','Каберне Совиньон','Бордо','Франция','Премиум',165,'16–18 °C','Бордо','Классическое полнотелое бордоское вино с благородными танинами, глубоким ароматом тёмных ягод и длительным пряным послевкусием.');
INSERT INTO "wines" VALUES(2,'Catena Zapata Malbec','Красное','Сухое','Мальбек','Мендоса','Аргентина','Средний',78,'16–18 °C','Бордо','Насыщенное высокогорное вино с сочной фруктовой основой, бархатными танинами и шоколадно-ванильными оттенками.');
INSERT INTO "wines" VALUES(3,'Teliani Valley Saperavi','Красное','Сухое','Саперави','Кахетия','Грузия','Бюджетный',34,'16–18 °C','Бордо','Густое рубиновое вино с выраженной терпкостью и яркими кавказскими специями — лучший спутник мяса на углях.');
INSERT INTO "wines" VALUES(4,'Penfolds Koonunga Hill Shiraz','Красное','Сухое','Шираз','Южная Австралия','Австралия','Средний',58,'16–18 °C','Сира','Яркий австралийский Шираз с сочным ягодным вкусом, перечными нотами и мягкой дубовой структурой.');
INSERT INTO "wines" VALUES(5,'Marqués de Riscal Reserva','Красное','Сухое','Темпранильо','Риоха','Испания','Средний',84,'16–18 °C','Бордо','Элегантная испанская Риоха с длительной выдержкой в дубе, тонами спелой вишни, кожи и пряностей.');
INSERT INTO "wines" VALUES(6,'Villa Antinori Chianti Classico','Красное','Сухое','Санджовезе','Тоскана','Италия','Средний',69,'16–17 °C','Кьянти','Классика Тосканы с живой кислотностью, идеально уравновешивающей томатные соусы, лазанью и итальянскую пиццу.');
INSERT INTO "wines" VALUES(7,'Louis Jadot Bourgogne Pinot Noir','Красное','Сухое','Пино Нуар','Бургундия','Франция','Премиум',96,'14–15 °C','Бургундия','Тонкое и шелковистое красное вино с низкими танинами. Прекрасно сочетается с уткой, курицей и даже лососем.');
INSERT INTO "wines" VALUES(8,'Casillero del Diablo Carmenere','Красное','Сухое','Карменер','Центральная Долина','Чили','Бюджетный',38,'16–18 °C','Бордо','Мягкое чилийское вино с округлыми танинами, нотами спелой сливы и лёгкой пряностью болгарского перца.');
INSERT INTO "wines" VALUES(9,'Barolo Serralunga d''Alba','Красное','Сухое','Неббиоло','Пьемонт','Италия','Премиум',155,'17–18 °C','Бургундия','«Король вин» из Пьемонта: мощная структура, высокая кислотность и аристократичный букет с нотами розы и трюфеля.');
INSERT INTO "wines" VALUES(10,'Cloudy Bay Sauvignon Blanc','Белое','Сухое','Совиньон Блан','Мальборо','Новая Зеландия','Средний',92,'8–10 °C','Для белого вина','Эталонный новозеландский Совиньон Блан со взрывным тропическим ароматом и хрустящей освежающей кислотностью.');
INSERT INTO "wines" VALUES(11,'Chablis Premier Cru William Fèvre','Белое','Сухое','Шардоне','Шабли','Франция','Премиум',140,'10–12 °C','Для белого вина','Кристально чистое минеральное белое вино из Бургундии без выдержки в новом дубе — идеальная классика к устрицам.');
INSERT INTO "wines" VALUES(12,'Kendall-Jackson Chardonnay','Белое','Сухое','Шардоне','Калифорния','США','Средний',74,'10–12 °C','Монраше','Богатое маслянистое Шардоне, выдержанное в дубе. Гармонично дополняет сливочные соусы, запечённую курицу и лосося.');
INSERT INTO "wines" VALUES(13,'Dr. Loosen Riesling Kabinett','Белое','Полусладкое','Рислинг','Мозель','Германия','Средний',54,'7–9 °C','Тюльпан для белого','Лёгкий мозельский Рислинг с филигранным балансом природной сладости и звонкой кислотности. Спасение к острым блюдам.');
INSERT INTO "wines" VALUES(14,'Santa Margherita Pinot Grigio','Белое','Сухое','Пино Гриджо','Трентино-Альто-Адидже','Италия','Средний',62,'8–10 °C','Для белого вина','Свежее, лёгкое и универсальное итальянское белое вино с чистым цитрусово-яблочным профилем.');
INSERT INTO "wines" VALUES(15,'Trimbach Gewürztraminer','Белое','Полусухое','Гевюрцтраминер','Эльзас','Франция','Средний',85,'9–11 °C','Для белого вина','Парфюмное, насыщенное вино из Эльзаса с экзотическими нотами личи и имбиря — прекрасно к пряным блюдам и пикантным сырам.');
INSERT INTO "wines" VALUES(16,'Vinho Verde Quinta da Aveleda','Белое','Полусухое','Лоурейру','Винью Верде','Португалия','Бюджетный',29,'6–8 °C','Для белого вина','Молодое португальское вино с лёгкой природной игристостью, низким алкоголем и яркой цитрусовой свежестью.');
INSERT INTO "wines" VALUES(17,'Grüner Veltliner Lois','Белое','Сухое','Грюнер Вельтлинер','Кампталь','Австрия','Бюджетный',44,'8–10 °C','Для белого вина','Знаменитое австрийское белое с пикантной нотой белого перца и зелёного яблока — великолепно к овощным салатам и шницелю.');
INSERT INTO "wines" VALUES(18,'Whispering Angel Rosé','Розовое','Сухое','Гренаш','Прованс','Франция','Средний',88,'8–10 °C','Для белого вина','Икона прованского розе нежно-лососевого оттенка с тонким ароматом лесной земляники и сухим освежающим вкусом.');
INSERT INTO "wines" VALUES(19,'Torres De Casta Rosado','Розовое','Сухое','Гарнача','Каталония','Испания','Бюджетный',35,'8–10 °C','Для белого вина','Яркое гастрономичное испанское розе с сочным ягодным вкусом, которое отлично работает и с паэльей, и с лёгким мясом.');
INSERT INTO "wines" VALUES(20,'Moët & Chandon Impérial Brut','Игристое','Сухое','Шардоне','Шампань','Франция','Премиум',195,'7–9 °C','Тюльпан для шампанского','Культовое французское шампанское категории брют с деликатным перляжем, кремовой текстурой и нотами сдобной выпечки.');
INSERT INTO "wines" VALUES(21,'Prosecco Valdobbiadene Superiore','Игристое','Сухое','Глера','Венето','Италия','Бюджетный',45,'6–8 °C','Флюте','Лёгкое итальянское игристое с мелкими пузырьками и освежающим грушево-цветочным ароматом.');
INSERT INTO "wines" VALUES(22,'Cava Freixenet Cordón Negro','Игристое','Сухое','Макабео','Пенедес','Испания','Бюджетный',36,'6–8 °C','Флюте','Испанское игристое, созданное по классическому методу шампанизации, с чистым сухим вкусом и отличной гастрономичностью.');
INSERT INTO "wines" VALUES(23,'Martini Asti DOCG','Игристое','Сладкое','Белый Мускат','Пьемонт','Италия','Бюджетный',39,'6–8 °C','Флюте','Сладкое ароматное игристое из белого муската с невысоким содержанием алкоголя и ярким фруктово-медовым вкусом.');
INSERT INTO "wines" VALUES(24,'Sauternes Château Guiraud','Белое','Сладкое','Семильон','Бордо','Франция','Премиум',175,'8–10 °C','Для десертных вин','Легендарное десертное вино из ягод благородной плесени с роскошным букетом кураги, акациевого мёда и цукатов.');
INSERT INTO "wines" VALUES(25,'Ruffino Riserva Ducale Chianti Classico','Красное','Сухое','Санджовезе','Тоскана','Италия','Средний',72,'16–18 °C','Кьянти','Классический кьянти с яркой кислотностью и вишнёвым вкусом, хорошо дружит с томатными соусами.');
INSERT INTO "wines" VALUES(26,'Masi Campofiorin Ripasso','Красное','Сухое','Корвина, Рондинелла','Венето','Италия','Средний',68,'16–18 °C','Бордо','Мягкое и насыщенное вино двойного брожения с нотами сухофруктов и бархатистыми танинами.');
INSERT INTO "wines" VALUES(27,'Amarone della Valpolicella Zenato','Красное','Сухое','Корвина, Рондинелла','Венето','Италия','Премиум',260,'17–18 °C','Бордо','Мощное вино из подвяленного винограда с богатым вкусом, высоким градусом и долгим послевкусием.');
INSERT INTO "wines" VALUES(28,'Brunello di Montalcino Argiano','Красное','Сухое','Санджовезе','Тоскана','Италия','Премиум',240,'17–18 °C','Бордо','Элегантное тосканское вино с плотными танинами и потенциалом к выдержке на десятилетия.');
INSERT INTO "wines" VALUES(29,'Rioja Crianza Muga','Красное','Сухое','Темпранильо','Риоха','Испания','Средний',58,'16–18 °C','Бордо','Мягкая риоха с ягодными и ванильными нотами после выдержки в американском дубе.');
INSERT INTO "wines" VALUES(30,'Ribera del Duero Protos Crianza','Красное','Сухое','Темпранильо','Рибера дель Дуэро','Испания','Средний',74,'16–18 °C','Бордо','Плотное и тёмное испанское вино с выраженной структурой и пряным дубовым оттенком.');
INSERT INTO "wines" VALUES(31,'Châteauneuf-du-Pape Les Cèdres','Красное','Сухое','Гренаш, Сира, Мурведр','Долина Роны','Франция','Премиум',210,'16–18 °C','Бордо','Тёплое и пряное купажное вино юга Роны с богатой текстурой и ароматом средиземноморских трав.');
INSERT INTO "wines" VALUES(32,'Côtes du Rhône Guigal','Красное','Сухое','Гренаш, Сира','Долина Роны','Франция','Средний',55,'15–17 °C','Сира','Дружелюбное фруктовое вино с мягкой перечной ноткой, универсальный выбор на каждый день.');
INSERT INTO "wines" VALUES(33,'Saint-Émilion Grand Cru Classé','Красное','Сухое','Мерло, Каберне Фран','Бордо','Франция','Премиум',230,'16–18 °C','Бордо','Бархатистое вино Правого берега с сочной сливой, мягкими танинами и тонкими дубовыми нотами.');
INSERT INTO "wines" VALUES(34,'Robert Mondavi Napa Cabernet Sauvignon','Красное','Сухое','Каберне Совиньон','Напа','США','Премиум',150,'16–18 °C','Бордо','Концентрированный калифорнийский каберне с зрелыми ягодами, мокко и бархатными танинами.');
INSERT INTO "wines" VALUES(35,'Marqués de Casa Concha Syrah','Красное','Сухое','Сира','Долина Рапель','Чили','Средний',66,'16–18 °C','Сира','Яркая чилийская сира с пряным характером, сочными ягодами и лёгким копчёным оттенком.');
INSERT INTO "wines" VALUES(36,'Seghesio Zinfandel','Красное','Сухое','Зинфандель','Сонома','США','Премиум',140,'16–18 °C','Бордо','Щедрое и ягодное калифорнийское вино с пряностями и высоким градусом, создано для мангала.');
INSERT INTO "wines" VALUES(37,'Kanonkop Pinotage','Красное','Сухое','Пинотаж','Стелленбош','ЮАР','Премиум',165,'16–18 °C','Бордо','Фирменный сорт ЮАР: насыщенное вино с дымными нотами, тёмными ягодами и мягкой структурой.');
INSERT INTO "wines" VALUES(38,'Gevrey-Chambertin Louis Jadot','Красное','Сухое','Пино Нуар','Бургундия','Франция','Премиум',280,'15–17 °C','Бургундия','Глубокий и благородный бургундский Пино Нуар с шелковистой текстурой и ароматом лесной подстилки.');
INSERT INTO "wines" VALUES(39,'Sancerre Domaine Vacheron','Белое','Сухое','Совиньон Блан','Луара','Франция','Премиум',125,'8–10 °C','Для белого вина','Хрустящий и минеральный Совиньон Блан с тонкой кислотностью, эталон вин Луары.');
INSERT INTO "wines" VALUES(40,'Martín Códax Albariño','Белое','Сухое','Альбариньо','Риас-Бикас','Испания','Средний',58,'8–10 °C','Для белого вина','Освежающее белое с побережья Галисии, с солоноватым оттенком и яркими цитрусовыми нотами.');
INSERT INTO "wines" VALUES(41,'Gavi di Gavi La Scolca','Белое','Сухое','Кортезе','Пьемонт','Италия','Средний',72,'9–11 °C','Тюльпан для белого','Тонкое сухое вино с чистым вкусом, свежей кислотностью и лёгкой миндальной горчинкой.');
INSERT INTO "wines" VALUES(42,'Soave Classico Pieropan','Белое','Сухое','Гарганега','Венето','Италия','Средний',52,'9–11 °C','Для белого вина','Мягкое и ароматное итальянское белое с цветочной нотой и приятным миндальным послевкусием.');
INSERT INTO "wines" VALUES(43,'Riesling Spätlese Joh. Jos. Prüm','Белое','Полусладкое','Рислинг','Мозель','Германия','Премиум',175,'8–10 °C','Тюльпан для белого','Лёгкое по алкоголю вино с гармонией сладости и острой кислотности, отлично сочетается со специями.');
INSERT INTO "wines" VALUES(44,'Meursault Louis Latour','Белое','Сухое','Шардоне','Бургундия','Франция','Премиум',190,'10–12 °C','Монраше','Богатое и маслянистое Шардоне с ореховыми нотами и долгим сливочным послевкусием.');
INSERT INTO "wines" VALUES(45,'Tokaji Aszú 5 Puttonyos','Белое','Сладкое','Фурминт','Токай','Венгрия','Премиум',150,'10–12 °C','Для десертных вин','Золотистое десертное вино из благородной плесени с яркой кислотностью, не приторное.');
INSERT INTO "wines" VALUES(46,'Teliani Valley Tsinandali','Белое','Сухое','Ркацители, Мцване','Кахетия','Грузия','Бюджетный',32,'8–10 °C','Для белого вина','Свежее грузинское белое с мягкой кислотностью, цветочным ароматом и лёгкой пряностью.');
INSERT INTO "wines" VALUES(47,'Minuty Prestige Rosé','Розовое','Сухое','Гренаш, Сенсо, Сира','Прованс','Франция','Премиум',98,'8–10 °C','Для белого вина','Бледное и воздушное прованское розе с чистой ягодной свежестью и минеральным окончанием.');
INSERT INTO "wines" VALUES(48,'Tavel Rosé Domaine Maby','Розовое','Сухое','Гренаш, Сенсо','Тавель','Франция','Средний',64,'9–11 °C','Для белого вина','Насыщенное розе с плотным телом, больше похожее на лёгкое красное вино, гастрономичное и пряное.');
INSERT INTO "wines" VALUES(49,'Mateus Rosé','Розовое','Полусухое','Баррака, Турига','Дору','Португалия','Бюджетный',28,'7–9 °C','Для белого вина','Лёгкое ягодное розе с мягкой сладостью и игристой свежестью, простое и дружелюбное.');
INSERT INTO "wines" VALUES(50,'Cleto Chiarli Lambrusco di Sorbara','Игристое','Полусухое','Ламбруско','Эмилия-Романья','Италия','Бюджетный',36,'8–10 °C','Флюте','Яркое красное игристое с мелкими пузырьками, ягодным вкусом и освежающей кислотностью.');
INSERT INTO "wines" VALUES(51,'Pierre Sparr Crémant d''Alsace Brut','Игристое','Сухое','Пино Блан, Рислинг','Эльзас','Франция','Средний',62,'6–8 °C','Флюте','Сухое игристое классического метода с тонкими пузырьками и мягким хлебным оттенком.');
INSERT INTO "wines" VALUES(52,'Veuve Clicquot Yellow Label Brut','Игристое','Сухое','Пино Нуар, Шардоне, Менье','Шампань','Франция','Премиум',230,'7–9 °C','Тюльпан для шампанского','Узнаваемое шампанское с богатым вкусом, насыщенными пузырьками и тостовыми нотами.');
INSERT INTO "wine_aromas" VALUES(1,0,'чёрная смородина');
INSERT INTO "wine_aromas" VALUES(1,1,'кедр');
INSERT INTO "wine_aromas" VALUES(1,2,'фиалка');
INSERT INTO "wine_aromas" VALUES(1,3,'дуб');
INSERT INTO "wine_aromas" VALUES(2,0,'слива');
INSERT INTO "wine_aromas" VALUES(2,1,'ежевика');
INSERT INTO "wine_aromas" VALUES(2,2,'ваниль');
INSERT INTO "wine_aromas" VALUES(2,3,'какао');
INSERT INTO "wine_aromas" VALUES(3,0,'ежевика');
INSERT INTO "wine_aromas" VALUES(3,1,'гранат');
INSERT INTO "wine_aromas" VALUES(3,2,'чёрный перец');
INSERT INTO "wine_aromas" VALUES(3,3,'кизил');
INSERT INTO "wine_aromas" VALUES(4,0,'чёрная смородина');
INSERT INTO "wine_aromas" VALUES(4,1,'перец');
INSERT INTO "wine_aromas" VALUES(4,2,'шоколад');
INSERT INTO "wine_aromas" VALUES(4,3,'лакрица');
INSERT INTO "wine_aromas" VALUES(5,0,'вишня');
INSERT INTO "wine_aromas" VALUES(5,1,'ваниль');
INSERT INTO "wine_aromas" VALUES(5,2,'дуб');
INSERT INTO "wine_aromas" VALUES(5,3,'табак');
INSERT INTO "wine_aromas" VALUES(6,0,'вишня');
INSERT INTO "wine_aromas" VALUES(6,1,'сушёные травы');
INSERT INTO "wine_aromas" VALUES(6,2,'фиалка');
INSERT INTO "wine_aromas" VALUES(6,3,'томатный лист');
INSERT INTO "wine_aromas" VALUES(7,0,'малина');
INSERT INTO "wine_aromas" VALUES(7,1,'вишня');
INSERT INTO "wine_aromas" VALUES(7,2,'пряности');
INSERT INTO "wine_aromas" VALUES(7,3,'подлесок');
INSERT INTO "wine_aromas" VALUES(8,0,'слива');
INSERT INTO "wine_aromas" VALUES(8,1,'чёрная смородина');
INSERT INTO "wine_aromas" VALUES(8,2,'какао');
INSERT INTO "wine_aromas" VALUES(8,3,'перец');
INSERT INTO "wine_aromas" VALUES(9,0,'роза');
INSERT INTO "wine_aromas" VALUES(9,1,'вишня');
INSERT INTO "wine_aromas" VALUES(9,2,'трюфель');
INSERT INTO "wine_aromas" VALUES(9,3,'смола');
INSERT INTO "wine_aromas" VALUES(10,0,'маракуйя');
INSERT INTO "wine_aromas" VALUES(10,1,'лайм');
INSERT INTO "wine_aromas" VALUES(10,2,'крыжовник');
INSERT INTO "wine_aromas" VALUES(10,3,'свежая трава');
INSERT INTO "wine_aromas" VALUES(11,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(11,1,'лимон');
INSERT INTO "wine_aromas" VALUES(11,2,'минералы');
INSERT INTO "wine_aromas" VALUES(11,3,'белые цветы');
INSERT INTO "wine_aromas" VALUES(12,0,'печёное яблоко');
INSERT INTO "wine_aromas" VALUES(12,1,'сливочное масло');
INSERT INTO "wine_aromas" VALUES(12,2,'ваниль');
INSERT INTO "wine_aromas" VALUES(12,3,'манго');
INSERT INTO "wine_aromas" VALUES(13,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(13,1,'белый персик');
INSERT INTO "wine_aromas" VALUES(13,2,'мёд');
INSERT INTO "wine_aromas" VALUES(13,3,'минералы');
INSERT INTO "wine_aromas" VALUES(14,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(14,1,'лимон');
INSERT INTO "wine_aromas" VALUES(14,2,'белый персик');
INSERT INTO "wine_aromas" VALUES(15,0,'личи');
INSERT INTO "wine_aromas" VALUES(15,1,'роза');
INSERT INTO "wine_aromas" VALUES(15,2,'имбирь');
INSERT INTO "wine_aromas" VALUES(15,3,'грейпфрут');
INSERT INTO "wine_aromas" VALUES(16,0,'лайм');
INSERT INTO "wine_aromas" VALUES(16,1,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(16,2,'белые цветы');
INSERT INTO "wine_aromas" VALUES(17,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(17,1,'белый перец');
INSERT INTO "wine_aromas" VALUES(17,2,'цитрус');
INSERT INTO "wine_aromas" VALUES(17,3,'свежая трава');
INSERT INTO "wine_aromas" VALUES(18,0,'земляника');
INSERT INTO "wine_aromas" VALUES(18,1,'розовый грейпфрут');
INSERT INTO "wine_aromas" VALUES(18,2,'роза');
INSERT INTO "wine_aromas" VALUES(19,0,'малина');
INSERT INTO "wine_aromas" VALUES(19,1,'гранат');
INSERT INTO "wine_aromas" VALUES(19,2,'клубника');
INSERT INTO "wine_aromas" VALUES(20,0,'бриошь');
INSERT INTO "wine_aromas" VALUES(20,1,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(20,2,'лимон');
INSERT INTO "wine_aromas" VALUES(20,3,'миндаль');
INSERT INTO "wine_aromas" VALUES(21,0,'груша');
INSERT INTO "wine_aromas" VALUES(21,1,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(21,2,'белые цветы');
INSERT INTO "wine_aromas" VALUES(21,3,'цитрус');
INSERT INTO "wine_aromas" VALUES(22,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(22,1,'лимон');
INSERT INTO "wine_aromas" VALUES(22,2,'миндаль');
INSERT INTO "wine_aromas" VALUES(23,0,'мускат');
INSERT INTO "wine_aromas" VALUES(23,1,'мёд');
INSERT INTO "wine_aromas" VALUES(23,2,'белый персик');
INSERT INTO "wine_aromas" VALUES(23,3,'цветы');
INSERT INTO "wine_aromas" VALUES(24,0,'мёд');
INSERT INTO "wine_aromas" VALUES(24,1,'курага');
INSERT INTO "wine_aromas" VALUES(24,2,'апельсин');
INSERT INTO "wine_aromas" VALUES(24,3,'шафран');
INSERT INTO "wine_aromas" VALUES(25,0,'вишня');
INSERT INTO "wine_aromas" VALUES(25,1,'фиалка');
INSERT INTO "wine_aromas" VALUES(25,2,'табак');
INSERT INTO "wine_aromas" VALUES(25,3,'специи');
INSERT INTO "wine_aromas" VALUES(26,0,'чёрная вишня');
INSERT INTO "wine_aromas" VALUES(26,1,'изюм');
INSERT INTO "wine_aromas" VALUES(26,2,'перец');
INSERT INTO "wine_aromas" VALUES(26,3,'ваниль');
INSERT INTO "wine_aromas" VALUES(27,0,'сухофрукты');
INSERT INTO "wine_aromas" VALUES(27,1,'шоколад');
INSERT INTO "wine_aromas" VALUES(27,2,'чернослив');
INSERT INTO "wine_aromas" VALUES(27,3,'пряности');
INSERT INTO "wine_aromas" VALUES(28,0,'вишня');
INSERT INTO "wine_aromas" VALUES(28,1,'кожа');
INSERT INTO "wine_aromas" VALUES(28,2,'лакрица');
INSERT INTO "wine_aromas" VALUES(28,3,'дуб');
INSERT INTO "wine_aromas" VALUES(29,0,'клубника');
INSERT INTO "wine_aromas" VALUES(29,1,'ваниль');
INSERT INTO "wine_aromas" VALUES(29,2,'кокос');
INSERT INTO "wine_aromas" VALUES(29,3,'специи');
INSERT INTO "wine_aromas" VALUES(30,0,'ежевика');
INSERT INTO "wine_aromas" VALUES(30,1,'чернослив');
INSERT INTO "wine_aromas" VALUES(30,2,'дуб');
INSERT INTO "wine_aromas" VALUES(30,3,'лакрица');
INSERT INTO "wine_aromas" VALUES(31,0,'чернослив');
INSERT INTO "wine_aromas" VALUES(31,1,'лаванда');
INSERT INTO "wine_aromas" VALUES(31,2,'перец');
INSERT INTO "wine_aromas" VALUES(31,3,'гарига');
INSERT INTO "wine_aromas" VALUES(32,0,'чёрная вишня');
INSERT INTO "wine_aromas" VALUES(32,1,'перец');
INSERT INTO "wine_aromas" VALUES(32,2,'травы');
INSERT INTO "wine_aromas" VALUES(32,3,'лакрица');
INSERT INTO "wine_aromas" VALUES(33,0,'слива');
INSERT INTO "wine_aromas" VALUES(33,1,'шоколад');
INSERT INTO "wine_aromas" VALUES(33,2,'трюфель');
INSERT INTO "wine_aromas" VALUES(33,3,'кедр');
INSERT INTO "wine_aromas" VALUES(34,0,'чёрная смородина');
INSERT INTO "wine_aromas" VALUES(34,1,'мокко');
INSERT INTO "wine_aromas" VALUES(34,2,'ваниль');
INSERT INTO "wine_aromas" VALUES(34,3,'кедр');
INSERT INTO "wine_aromas" VALUES(35,0,'слива');
INSERT INTO "wine_aromas" VALUES(35,1,'чёрный перец');
INSERT INTO "wine_aromas" VALUES(35,2,'фиалка');
INSERT INTO "wine_aromas" VALUES(35,3,'дым');
INSERT INTO "wine_aromas" VALUES(36,0,'малина');
INSERT INTO "wine_aromas" VALUES(36,1,'ежевика');
INSERT INTO "wine_aromas" VALUES(36,2,'перец');
INSERT INTO "wine_aromas" VALUES(36,3,'патока');
INSERT INTO "wine_aromas" VALUES(37,0,'чёрная слива');
INSERT INTO "wine_aromas" VALUES(37,1,'дым');
INSERT INTO "wine_aromas" VALUES(37,2,'ежевика');
INSERT INTO "wine_aromas" VALUES(37,3,'кожа');
INSERT INTO "wine_aromas" VALUES(38,0,'вишня');
INSERT INTO "wine_aromas" VALUES(38,1,'земля');
INSERT INTO "wine_aromas" VALUES(38,2,'роза');
INSERT INTO "wine_aromas" VALUES(38,3,'грибы');
INSERT INTO "wine_aromas" VALUES(39,0,'цитрус');
INSERT INTO "wine_aromas" VALUES(39,1,'крыжовник');
INSERT INTO "wine_aromas" VALUES(39,2,'кремень');
INSERT INTO "wine_aromas" VALUES(39,3,'трава');
INSERT INTO "wine_aromas" VALUES(40,0,'персик');
INSERT INTO "wine_aromas" VALUES(40,1,'лимон');
INSERT INTO "wine_aromas" VALUES(40,2,'жасмин');
INSERT INTO "wine_aromas" VALUES(40,3,'морской бриз');
INSERT INTO "wine_aromas" VALUES(41,0,'зелёное яблоко');
INSERT INTO "wine_aromas" VALUES(41,1,'цитрус');
INSERT INTO "wine_aromas" VALUES(41,2,'миндаль');
INSERT INTO "wine_aromas" VALUES(41,3,'минералы');
INSERT INTO "wine_aromas" VALUES(42,0,'груша');
INSERT INTO "wine_aromas" VALUES(42,1,'цитрус');
INSERT INTO "wine_aromas" VALUES(42,2,'миндаль');
INSERT INTO "wine_aromas" VALUES(42,3,'цветы');
INSERT INTO "wine_aromas" VALUES(43,0,'персик');
INSERT INTO "wine_aromas" VALUES(43,1,'лайм');
INSERT INTO "wine_aromas" VALUES(43,2,'мёд');
INSERT INTO "wine_aromas" VALUES(43,3,'минералы');
INSERT INTO "wine_aromas" VALUES(44,0,'орех');
INSERT INTO "wine_aromas" VALUES(44,1,'масло');
INSERT INTO "wine_aromas" VALUES(44,2,'груша');
INSERT INTO "wine_aromas" VALUES(44,3,'ваниль');
INSERT INTO "wine_aromas" VALUES(45,0,'абрикос');
INSERT INTO "wine_aromas" VALUES(45,1,'мёд');
INSERT INTO "wine_aromas" VALUES(45,2,'апельсиновая цедра');
INSERT INTO "wine_aromas" VALUES(45,3,'шафран');
INSERT INTO "wine_aromas" VALUES(46,0,'яблоко');
INSERT INTO "wine_aromas" VALUES(46,1,'айва');
INSERT INTO "wine_aromas" VALUES(46,2,'цветы');
INSERT INTO "wine_aromas" VALUES(46,3,'мёд');
INSERT INTO "wine_aromas" VALUES(47,0,'клубника');
INSERT INTO "wine_aromas" VALUES(47,1,'цитрус');
INSERT INTO "wine_aromas" VALUES(47,2,'персик');
INSERT INTO "wine_aromas" VALUES(47,3,'травы');
INSERT INTO "wine_aromas" VALUES(48,0,'малина');
INSERT INTO "wine_aromas" VALUES(48,1,'вишня');
INSERT INTO "wine_aromas" VALUES(48,2,'специи');
INSERT INTO "wine_aromas" VALUES(48,3,'цедра');
INSERT INTO "wine_aromas" VALUES(49,0,'земляника');
INSERT INTO "wine_aromas" VALUES(49,1,'красная смородина');
INSERT INTO "wine_aromas" VALUES(49,2,'цветы');
INSERT INTO "wine_aromas" VALUES(50,0,'земляника');
INSERT INTO "wine_aromas" VALUES(50,1,'фиалка');
INSERT INTO "wine_aromas" VALUES(50,2,'красная вишня');
INSERT INTO "wine_aromas" VALUES(50,3,'цветы');
INSERT INTO "wine_aromas" VALUES(51,0,'яблоко');
INSERT INTO "wine_aromas" VALUES(51,1,'бриошь');
INSERT INTO "wine_aromas" VALUES(51,2,'цитрус');
INSERT INTO "wine_aromas" VALUES(51,3,'мёд');
INSERT INTO "wine_aromas" VALUES(52,0,'яблоко');
INSERT INTO "wine_aromas" VALUES(52,1,'бриошь');
INSERT INTO "wine_aromas" VALUES(52,2,'груша');
INSERT INTO "wine_aromas" VALUES(52,3,'миндаль');
INSERT INTO "wine_foods" VALUES(1,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(1,1,'Дичь');
INSERT INTO "wine_foods" VALUES(1,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(1,3,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(2,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(2,1,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(2,2,'Сыры');
INSERT INTO "wine_foods" VALUES(3,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(3,1,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(3,2,'Острая кухня');
INSERT INTO "wine_foods" VALUES(3,3,'Сыры');
INSERT INTO "wine_foods" VALUES(4,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(4,1,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(4,2,'Острая кухня');
INSERT INTO "wine_foods" VALUES(5,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(5,1,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(5,2,'Сыры');
INSERT INTO "wine_foods" VALUES(5,3,'Птица');
INSERT INTO "wine_foods" VALUES(6,0,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(6,1,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(6,2,'Сыры');
INSERT INTO "wine_foods" VALUES(7,0,'Птица');
INSERT INTO "wine_foods" VALUES(7,1,'Рыба');
INSERT INTO "wine_foods" VALUES(7,2,'Сыры');
INSERT INTO "wine_foods" VALUES(7,3,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(8,0,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(8,1,'Птица');
INSERT INTO "wine_foods" VALUES(8,2,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(8,3,'Сыры');
INSERT INTO "wine_foods" VALUES(9,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(9,1,'Дичь');
INSERT INTO "wine_foods" VALUES(9,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(10,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(10,1,'Рыба');
INSERT INTO "wine_foods" VALUES(10,2,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(10,3,'Сыры');
INSERT INTO "wine_foods" VALUES(11,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(11,1,'Рыба');
INSERT INTO "wine_foods" VALUES(11,2,'Птица');
INSERT INTO "wine_foods" VALUES(12,0,'Птица');
INSERT INTO "wine_foods" VALUES(12,1,'Рыба');
INSERT INTO "wine_foods" VALUES(12,2,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(12,3,'Сыры');
INSERT INTO "wine_foods" VALUES(13,0,'Острая кухня');
INSERT INTO "wine_foods" VALUES(13,1,'Морепродукты');
INSERT INTO "wine_foods" VALUES(13,2,'Рыба');
INSERT INTO "wine_foods" VALUES(13,3,'Десерты');
INSERT INTO "wine_foods" VALUES(14,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(14,1,'Рыба');
INSERT INTO "wine_foods" VALUES(14,2,'Морепродукты');
INSERT INTO "wine_foods" VALUES(14,3,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(15,0,'Острая кухня');
INSERT INTO "wine_foods" VALUES(15,1,'Сыры');
INSERT INTO "wine_foods" VALUES(15,2,'Птица');
INSERT INTO "wine_foods" VALUES(15,3,'Десерты');
INSERT INTO "wine_foods" VALUES(16,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(16,1,'Рыба');
INSERT INTO "wine_foods" VALUES(16,2,'Морепродукты');
INSERT INTO "wine_foods" VALUES(17,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(17,1,'Птица');
INSERT INTO "wine_foods" VALUES(17,2,'Рыба');
INSERT INTO "wine_foods" VALUES(18,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(18,1,'Морепродукты');
INSERT INTO "wine_foods" VALUES(18,2,'Рыба');
INSERT INTO "wine_foods" VALUES(18,3,'Птица');
INSERT INTO "wine_foods" VALUES(19,0,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(19,1,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(19,2,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(19,3,'Рыба');
INSERT INTO "wine_foods" VALUES(20,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(20,1,'Рыба');
INSERT INTO "wine_foods" VALUES(20,2,'Сыры');
INSERT INTO "wine_foods" VALUES(20,3,'Птица');
INSERT INTO "wine_foods" VALUES(21,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(21,1,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(21,2,'Сыры');
INSERT INTO "wine_foods" VALUES(21,3,'Рыба');
INSERT INTO "wine_foods" VALUES(22,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(22,1,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(22,2,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(22,3,'Рыба');
INSERT INTO "wine_foods" VALUES(23,0,'Десерты');
INSERT INTO "wine_foods" VALUES(23,1,'Сыры');
INSERT INTO "wine_foods" VALUES(24,0,'Десерты');
INSERT INTO "wine_foods" VALUES(24,1,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(24,2,'Сыры');
INSERT INTO "wine_foods" VALUES(25,0,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(25,1,'Сыры');
INSERT INTO "wine_foods" VALUES(25,2,'Птица');
INSERT INTO "wine_foods" VALUES(26,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(26,1,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(26,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(27,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(27,1,'Дичь');
INSERT INTO "wine_foods" VALUES(27,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(28,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(28,1,'Дичь');
INSERT INTO "wine_foods" VALUES(28,2,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(29,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(29,1,'Птица');
INSERT INTO "wine_foods" VALUES(29,2,'Сыры');
INSERT INTO "wine_foods" VALUES(29,3,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(30,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(30,1,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(30,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(31,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(31,1,'Дичь');
INSERT INTO "wine_foods" VALUES(31,2,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(32,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(32,1,'Птица');
INSERT INTO "wine_foods" VALUES(32,2,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(33,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(33,1,'Птица');
INSERT INTO "wine_foods" VALUES(33,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(34,0,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(34,1,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(34,2,'Ягнёнок');
INSERT INTO "wine_foods" VALUES(35,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(35,1,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(35,2,'Острая кухня');
INSERT INTO "wine_foods" VALUES(36,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(36,1,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(36,2,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(37,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(37,1,'Дичь');
INSERT INTO "wine_foods" VALUES(37,2,'Стейк и красное мясо');
INSERT INTO "wine_foods" VALUES(38,0,'Птица');
INSERT INTO "wine_foods" VALUES(38,1,'Дичь');
INSERT INTO "wine_foods" VALUES(38,2,'Рыба');
INSERT INTO "wine_foods" VALUES(38,3,'Сыры');
INSERT INTO "wine_foods" VALUES(39,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(39,1,'Рыба');
INSERT INTO "wine_foods" VALUES(39,2,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(39,3,'Сыры');
INSERT INTO "wine_foods" VALUES(40,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(40,1,'Рыба');
INSERT INTO "wine_foods" VALUES(40,2,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(41,0,'Рыба');
INSERT INTO "wine_foods" VALUES(41,1,'Морепродукты');
INSERT INTO "wine_foods" VALUES(41,2,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(42,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(42,1,'Рыба');
INSERT INTO "wine_foods" VALUES(42,2,'Птица');
INSERT INTO "wine_foods" VALUES(43,0,'Острая кухня');
INSERT INTO "wine_foods" VALUES(43,1,'Десерты');
INSERT INTO "wine_foods" VALUES(43,2,'Птица');
INSERT INTO "wine_foods" VALUES(44,0,'Птица');
INSERT INTO "wine_foods" VALUES(44,1,'Рыба');
INSERT INTO "wine_foods" VALUES(44,2,'Морепродукты');
INSERT INTO "wine_foods" VALUES(44,3,'Сыры');
INSERT INTO "wine_foods" VALUES(45,0,'Десерты');
INSERT INTO "wine_foods" VALUES(45,1,'Сыры');
INSERT INTO "wine_foods" VALUES(45,2,'Выдержанные сыры');
INSERT INTO "wine_foods" VALUES(46,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(46,1,'Рыба');
INSERT INTO "wine_foods" VALUES(46,2,'Птица');
INSERT INTO "wine_foods" VALUES(47,0,'Морепродукты');
INSERT INTO "wine_foods" VALUES(47,1,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(47,2,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(48,0,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(48,1,'Птица');
INSERT INTO "wine_foods" VALUES(48,2,'Острая кухня');
INSERT INTO "wine_foods" VALUES(49,0,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(49,1,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(49,2,'Острая кухня');
INSERT INTO "wine_foods" VALUES(50,0,'Паста и пицца');
INSERT INTO "wine_foods" VALUES(50,1,'Сыры');
INSERT INTO "wine_foods" VALUES(50,2,'Барбекю и шашлык');
INSERT INTO "wine_foods" VALUES(51,0,'Рыба');
INSERT INTO "wine_foods" VALUES(51,1,'Морепродукты');
INSERT INTO "wine_foods" VALUES(51,2,'Салаты и закуски');
INSERT INTO "wine_foods" VALUES(52,0,'Рыба');
INSERT INTO "wine_foods" VALUES(52,1,'Морепродукты');
INSERT INTO "wine_foods" VALUES(52,2,'Птица');
INSERT INTO "wine_foods" VALUES(52,3,'Сыры');
INSERT INTO "articles" VALUES(1,'Золотые правила сочетания вина и еды','Гастрономия','5 мин','Если сомневаетесь в выборе, подбирайте вино по соусу, а не по основному ингредиенту: именно соус задаёт жирность и кислотность блюда.','Главный принцип классического сомелье — баланс веса и интенсивности. Лёгкие блюда из белой рыбы, овощей или морепродуктов требуют свежих, деликатных вин, тогда как насыщенное жареное мясо, дичь или рагу нуждаются в полнотелых красных винах со структурой.

Второй важный закон — работа контрастов и подобий. Жирность стейка, сливочного соуса или выдержанного сыра смягчается высокой кислотностью или танинами вина. Освежающая кислотность Совиньон Блан или шампанского работает к морепродуктам так же, как долька свежего лимона.

Третье правило касается сладости и остроты: вино к десерту обязательно должно быть слаще самого блюда, иначе оно покажется резким и кислым. А к острой азиатской кухне лучше брать полусухие или полусладкие ароматные белые вина (например, Рислинг), потому что высокие танины и высокий алкоголь лишь усиливают жжение специй.');
INSERT INTO "articles" VALUES(2,'Что такое танины и зачем они нужны','Основы дегустации','4 мин','Чтобы почувствовать танины на практике, сравните в одном вечере Пино Нуар (низкие танины) и Каберне Совиньон или Саперави (высокие танины).','Танины — это природные полифенольные соединения, которые содержатся в кожице, косточках и гребнях винограда, а также переходят в вино при выдержке в дубовых бочках. Именно танины создают ощущение терпкости, вязкости и лёгкой сухости на дёснах — точно так же, как крепко заваренный чёрный чай.

Поскольку белые вина почти всегда сбраживаются без контакта со жмыхом и кожицей, танинов в них практически нет. Красные же вина получают свою структуру и способность к долгому хранению именно за счёт полифенолов.

В гастрономии танины играют ключевую роль: они химически связывают белки и расщепляют животный жир. Поэтому терпкое Каберне Совиньон, Бароло или Саперави в паре со стейком ощущаются заметно мягче, а само мясо становится нежнее и сочнее.');
INSERT INTO "articles" VALUES(3,'Температура подачи: почему это критично','Сервировка','3 мин','Если красное вино простояло в тёплой комнате (+24 °C), уберите бутылку в холодильник на 20 минут перед подачей — вкус станет чище и свежее.','Температура способна полностью преобразить одно и то же вино. Слишком тёплое белое вино теряет свежесть, кажется плоским и тяжеловатым, а перегретое красное начинает резко отдавать спиртом, заглушая ягодный букет.

Обратная ошибка — подавать красные вина ледяными: холод сжимает ароматы и подчёркивает горечь танинов, делая вкус жёстким. Поэтому правило «комнатной температуры» пошло из эпохи прохладных каменных замков, где в комнатах было около 16–18 °C.

Оптимальные ориентиры: сладкие и игристые вина подают при 6–8 °C, лёгкие белые и розе — при 8–10 °C, насыщенные выдержанные белые — при 10–12 °C, лёгкие красные (Пино Нуар) — при 14–15 °C, а полнотелые красные (Бордо, Мальбек, Шираз) — при 16–18 °C.');
INSERT INTO "articles" VALUES(4,'Как выбрать форму бокала под сорт винограда','Сервировка','4 мин','Если хотите иметь один универсальный бокал дома, выбирайте классический бокал среднего размера с зауженным кверху тюльпаном из тонкого стекла.','Форма бокала — не просто эстетика, а физический инструмент управления ароматом. Широкая чаша увеличивает площадь контакта вина с воздухом и помогает быстрее испаряться сложным ароматическим молекулам, а сужающийся верх удерживает букет внутри.

Высокий бокал формы «Бордо» создан для мощных танинных вин (Каберне, Мальбек, Саперави): он направляет поток к центру и задней части языка, смягчая терпкость. Широкий пузатый бокал «Бургундия» нужен для тонких Пино Нуар и Бароло — в нём раскрываются деликатные ноты малины, розы и специй.

Для игристых вин всё чаще вместо узкой трубки флюте используют тюльпановидные бокалы с широкой серединой: в них не только дольше держится игра пузырьков, но и гораздо ярче чувствуется аромат выпечки и фруктов.');
INSERT INTO "articles" VALUES(5,'Путеводитель по главным красным сортам мира','Сорта винограда','6 мин','Для первого знакомства с сухими красными винами лучше всего подходят фруктовые и мягкие сорта: Мерло, Карменер или аргентинский Мальбек.','Мир красных вин держится на нескольких международных сортах, каждый из которых обладает собственным характером. Королём структуры считается Каберне Совиньон: он даёт тёмный цвет, высокие танины и узнаваемый аромат чёрной смородины, кедра и зелёного перца.

Его постоянный партнёр по бордоскому купажу — Мерло, который делает вкус мягче и округлее. Аргентинский Мальбек знаменит нотами спелой сливы, ежевики и какао, а австралийский Шираз (Сира) добавляет к тёмным ягодам выраженный чёрный перец и дымок.

Тем, кто ищет лёгкость и кислотность, стоит обратить внимание на бургундский Пино Нуар с ароматами вишни и малины или итальянский Санджовезе — основу тосканских вин Кьянти, идеально подходящую к пасте и пицце.');
INSERT INTO "articles" VALUES(6,'Белые сорта: от хрустящего Совиньона до маслянистого Шардоне','Сорта винограда','5 мин','Один и тот же сорт Шардоне в холодном Шабли и жаркой Калифорнии даёт два совершенно разных вина: строгое минеральное и богатое сливочно-ванильное.','Белые вина по стилю делятся на две большие группы: освежающие минеральные и плотные выдержанные. Первую группу возглавляет Совиньон Блан — особенно яркий в Новой Зеландии, где он пахнет маракуйей, лаймом, крыжовником и свежескошенной травой.

Итальянский Пино Гриджо и португальское Винью Верде отличаются лёгкостью, невысоким алкоголем и чистыми нотами зелёного яблока и цитрусов. Они идеальны как аперитив и сопровождение лёгких салатов.

Шардоне — самый пластичный сорт: без выдержки в дубе (как в Шабли) оно хрустящее и меловое, а после дубовой бочки приобретает маслянистую текстуру и ноты печёного яблока и ванили. Отдельно стоят ароматичные Рислинг и Гевюрцтраминер, которые славятся медовыми, цветочными и пряными оттенками.');
INSERT INTO "articles" VALUES(7,'Игристые вина: Шампань, Просекко, Кава и Асти — в чём разница?','Регионы и стили','5 мин','Для лёгкого летнего аперитива берите Просекко, для гастрономичного ужина с морепродуктами — Каву или Шампанское брют, а к торту — сладкое Асти.','Хотя все игристые объединяют пузырьки, технологии их производства и вкус сильно различаются. Настоящее Шампанское (Франция) и испанская Кава создаются традиционным методом: вторичное брожение проходит прямо в бутылке, где вино месяцами выдерживается на дрожжевом осадке.

Благодаря этому Шампанское и Кава обладают мельчайшим кремовым перляжем и характерным ароматом свежей сдобы, бриоши, миндаля и зелёного яблока. Кава при этом часто стоит в несколько раз доступнее при схожей строгости вкуса.

Итальянское Просекко делают методом Шарма — в больших стальных резервуарах. Это сохраняет свежий, беззаботный аромат груши, персика и белых цветов. А сладкое пьемонтское Асти производят из ароматного Белого Муската с остановкой брожения холодом, чтобы оставить природную виноградную сладость.');
INSERT INTO "articles" VALUES(8,'Декантация: каким винам нужно подышать','Сервировка','4 мин','Молодое полнотелое вино достаточно перелить в декантер за 30–45 минут до ужина — оно раскроет ароматы и станет значительно мягче.','Декантация — это переливание вина из бутылки в специальный стеклянный графин (декантер). Процедура решает две совершенно разные задачи в зависимости от возраста и стиля напитка.

Для молодых мощных красных вин (Бордо, Мальбек, Шираз, Бароло, Саперави) главный смысл — аэрация, то есть насыщение кислородом. Контакт с воздухом смягчает агрессивные танины и раскрывает закрытые фруктовые и пряные ароматы.

Для коллекционных вин старше 10–15 лет декантацию делают аккуратно и непосредственно перед подачей — единственная цель здесь заключается в том, чтобы отделить естественный осадок, скопившийся на дне бутылки.');
INSERT INTO "articles" VALUES(9,'Идеальные сырные и винные пары','Гастрономия','4 мин','К сырной тарелке из разных видов сыра безопаснее всего подать белое вино с хорошей кислотностью или сухое игристое — они универсальнее красного.','Сочетание вина и сыра — одна из самых тонких тем гастрономии. Распространённый миф гласит, что к любому сыру подходит красное вино, однако на практике танины нередко конфликтуют со сливочной текстурой молодых сыров.

Козий сыр и фета идеально работают с высококислотным Совиньон Блан. Мягкие сыры с белой плесенью (бри и камамбер) лучше всего сочетаются с выдержанным Шардоне или сухим Шампанским.

Выдержанные твёрдые сыры — пармезан, грана падано, старый чеддер — действительно любят красные вина со структурой вроде Кьянти, Риохи или Бароло. А солоноватые голубые сыры (рокфор, горгонзола, дорблю) создают легендарную контрастную пару со сладким Сотерном.');
INSERT INTO "articles" VALUES(10,'Как читать винную этикетку Старого и Нового Света','Регионы и стили','5 мин','Видите на французской или итальянской бутылке название региона без указания сорта? Это классика Старого Света — сорт «зашит» в законе о терруаре.','В мире виноделия сложились два подхода к оформлению этикеток. Страны Старого Света (Франция, Италия, Испания, Германия) делают ставку на место происхождения: на этикетке крупно пишут «Бордо», «Шабли», «Кьянти Классико» или «Риоха».

В таких случаях сорт винограда регламентирован законом региона: например, за названием «Шабли» всегда скрывается 100% Шардоне, а за «Кьянти» — преимущественно Санджовезе. Категории вроде AOC, DOCG или Reserva указывают на контроль происхождения и срок выдержки.

Страны Нового Света (Чили, Аргентина, США, Австралия, Новая Зеландия) придерживаются понятного покупателю принципа: главным на этикетке всегда выступает название сорта винограда (Malbec, Sauvignon Blanc, Shiraz) и год урожая.');
INSERT INTO "articles" VALUES(11,'Вино к курице, индейке и утке','Гастрономия','4 мин','Чем темнее мясо и насыщеннее соус, тем темнее и плотнее может быть вино.','Мясо птицы нейтрально, поэтому выбор вина диктуют способ приготовления и соус. К запечённой курице с хрустящей корочкой подходит выдержанное Шардоне или лёгкий Пино Нуар, а к птице в сливочном соусе белое вино с округлой кислотностью.

Утка жирнее и темнее, ей нужны красные с хорошей кислотностью и мягкими танинами: Пино Нуар, Бургундия или Кьянти. Индейка с клюквенным соусом дружит с Божоле и розовым вином.');
INSERT INTO "articles" VALUES(12,'Вино к пасте: соус важнее макарон','Гастрономия','4 мин','Вино должно быть не менее кислым, чем соус, иначе оно покажется плоским.','В пасте вино подбирают к соусу. Томатный соус кислый, и ему нужны красные с живой кислотностью: Кьянти, Монтепульчано, Барбера. Сливочные соусы, например карбонара или альфредо, лучше сочетаются с сухим белым вином средней плотности.

К пасте с морепродуктами подойдут Верментино, Пино Гриджо или Гави. К песто Совиньон Блан и Вердиккьо. Мясное рагу болоньезе хорошо принимает Санджовезе и Монтепульчано д''Абруццо.');
INSERT INTO "articles" VALUES(13,'Вино к острой и азиатской кухне','Гастрономия','4 мин','Охлаждайте вино к острому на градус-два сильнее обычного: холод смягчает жжение.','Жгучий перец и остаточный сахар хорошо сочетаются, а вот танины и высокий алкоголь усиливают жжение. Поэтому к острым блюдам выбирают вина с низким алкоголем, заметной кислотностью и лёгкой сладостью.

Классика пары: Рислинг Кабинет или Шпетлезе, Гевюрцтраминер, Шенен Блан. К тайским карри подойдёт Совиньон Блан, к суши и сашими сухое игристое или Грюнер Вельтлинер.');
INSERT INTO "articles" VALUES(14,'Вино к десертам: правило «слаще блюда»','Гастрономия','4 мин','Подавайте десертное вино холоднее обычного, 8–10 °C: так сахар не кажется тяжёлым.','Главное правило: вино должно быть слаще десерта, иначе оно покажется кислым и пустым. Фруктовые тарты хорошо сочетаются с Сотерном, поздним сбором Рислинга или Асти.

К шоколаду выбирают сладкие красные: Баньюльс, Рецьото, портвейн. Очень сладкие десерты лучше подавать с десертными или креплёными винами, а к лёгким бисквитам подойдёт полусладкое игристое.');
INSERT INTO "articles" VALUES(15,'Вино к овощам и салатам','Гастрономия','3 мин','Если в салате много уксуса или лимона, возьмите очень кислое вино или уменьшите заправку.','Свежая зелень, огурцы и спаржа любят травянистые белые вина с высокой кислотностью, прежде всего Совиньон Блан, Вердехо и Грюнер Вельтлинер. Уксусная заправка делает вино более кислым на вкус, поэтому берите вино поострее.

Печёные овощи, грибы и баклажаны мягче и сладковаты, к ним подойдёт Пино Нуар или лёгкое розовое. Спаржа считается сложной парой, но Грюнер Вельтлинер справляется с ней лучше других.');
INSERT INTO "articles" VALUES(16,'Шашлык и барбекю: что налить к мангалу','Гастрономия','4 мин','Для пикника хватит холодного сухого розе: оно подойдёт и курице, и свинине, и овощам.','Дым, маринад и жир мяса требуют вин с плотными фруктами и умеренными танинами. Свинина и курица на мангале хорошо сочетаются с розовым и лёгкими красными, а баранина и говядина с Саперави, Мальбеком и Ширазом.

Маринад с уксусом и луком лучше сочетается с вином повышенной кислотности, например с Темпранильо или Каберне Фран. Не берите дорогие выдержанные вина: дым перебьёт тонкие оттенки.');
INSERT INTO "articles" VALUES(17,'Как дегустировать вино: четыре шага','Основы дегустации','5 мин','Записывайте свои впечатления: через несколько месяцев вы заметите, какие стили вам ближе.','Профессиональная дегустация состоит из четырёх шагов: осмотр, аромат, вкус и послевкусие. Сначала наклоните бокал на белом фоне и оцените цвет и прозрачность: молодое красное имеет фиолетовый оттенок, выдержанное кирпичный.

Затем покрутите бокал и вдохните аромат, потом сделайте небольшой глоток и подержите вино во рту. В конце оцените послевкусие: чем дольше оно звучит, тем выше класс вина.');
INSERT INTO "articles" VALUES(18,'Кислотность вина: откуда берётся свежесть','Основы дегустации','4 мин','Если вино кажется острым без еды, попробуйте его с жирным блюдом: баланс часто появляется сразу.','Кислотность делает вино свежим, заставляет рот слюноточить и поддерживает аромат. В жарких регионах виноград быстро набирает сахар, а кислотность падает, поэтому вина юга обычно мягче и полнее. В прохладных регионах вина острее и тоньше.

Высокую кислотность дают Рислинг, Совиньон Блан, Неббиоло и Санджовезе. Она работает как лимонный сок на рыбе и помогает вину сочетаться с жирными блюдами и томатными соусами.');
INSERT INTO "articles" VALUES(19,'Тело вина: лёгкое, среднее, полное','Основы дегустации','4 мин','Лёгкая рыба и полнотелое вино плохо сочетаются: вино просто заглушит вкус блюда.','Тело вина это ощущение веса и плотности во рту, которое зависит от алкоголя, экстракта и сахара. Лёгкое вино похоже на обезжиренное молоко, среднее на цельное, полнотелое на сливки.

Лёгкими считаются Пино Гриджо, Вердехо и Божоле. Среднее тело у Мерло и Санджовезе, полное у Каберне Совиньон, Шираза и дубового Шардоне. Подбирая пару, сопоставляйте вес вина и блюда.');
INSERT INTO "articles" VALUES(20,'Остаточный сахар: от сухого до сладкого','Основы дегустации','4 мин','Если на этикетке игристого написано brut, это сухое вино; sec и demi-sec заметно слаще.','Остаточный сахар это сахар, оставшийся в вине после брожения. По его количеству вина делят на сухие, полусухие, полусладкие и сладкие. Сухие вина обычно содержат не больше 4 граммов сахара на литр.

Для игристых используется своя шкала: брют натюр, экстра брют, брют, секко, демисек, дольче. Сладкие вина не обязательно простые: Сотерн и Токай одни из самых сложных вин в мире.');
INSERT INTO "articles" VALUES(21,'Дефекты вина: пробка, окисление, сера','Основы дегустации','4 мин','Не путайте осадок на дне бутылки с дефектом: он нормален для выдержанных красных вин.','Самый частый дефект это пробковое вино. Его вызывает вещество ТСА, которое придаёт запах сырого подвала и мокрого картона и убивает фруктовый аромат. Такое вино безопасно, но пить его неприятно.

Другие признаки: запах яблочного пюре и хереса говорит об окислении, запах горелой спички о избытке серы. Вино с дефектом можно вернуть в ресторане.');
INSERT INTO "articles" VALUES(22,'Как правильно открыть вино и шампанское','Сервировка','3 мин','Охлаждайте шампанское в ведре со льдом и водой около 20 минут, а не в морозилке.','Для тихого вина срежьте фольгу ниже горлышка, введите штопор по центру и вытаскивайте пробку плавно, без хлопка. Горлышко после этого вытрите салфеткой.

Шампанское открывают иначе: придерживайте пробку рукой и поворачивайте бутылку, а не пробку, чтобы вышел лишь лёгкий вздох газа. Бутылку наклоните примерно на 45 градусов.');
INSERT INTO "articles" VALUES(23,'Как хранить вино дома','Сервировка','4 мин','Холодильник хорош для вина на несколько дней, но не для долгого хранения: пробка пересыхает.','Вино любит темноту, прохладу и покой. Оптимальная температура хранения 10–14 °C без резких перепадов. Прямой свет и вибрация ускоряют старение.

Бутылки с пробкой хранят лёжа, чтобы пробка не пересыхала. Влажность должна быть около 70 процентов. Для ежедневных вин хватит тёмного шкафа вдали от плиты и батареи.');
INSERT INTO "articles" VALUES(24,'Порядок подачи вин за столом','Сервировка','4 мин','Между винами подавайте воду и хлеб: они освежают рецепторы.','Общий принцип такой: от лёгкого к насыщенному, от молодого к выдержанному, от сухого к сладкому. Начинают обычно с игристого, затем идут белые, красные и в конце десертные.

Бывают исключения: тонкое выдержанное красное лучше подать раньше мощного молодого. Главное, чтобы каждое следующее вино было не слабее предыдущего.');
INSERT INTO "articles" VALUES(25,'Сколько вина нужно на гостей','Сервировка','3 мин','Лучше оставить нераскрытой лишнюю бутылку, чем остаться без вина в разгар вечера.','В бутылке 0,75 литра примерно пять бокалов по 150 мл. На ужин из нескольких блюд рассчитывайте полбутылки на человека, на долгий праздник бутылку.

Если подаёте несколько вин, уменьшайте порции до 100 мл. Белого и игристого берите немного больше, чем красного, особенно летом. Держите в запасе одну-две бутылки.');
INSERT INTO "articles" VALUES(26,'Мерло: мягкость и сливовые ноты','Сорта винограда','4 мин','Мерло хороший выбор, если вы не любите резкие танины.','Мерло любят за мягкие танины и сочные сливовые ноты. Сорт созревает раньше Каберне и хорошо чувствует себя на глинистых почвах Правого берега Бордо, где даёт вина Помероля и Сент-Эмильона.

В Новом Свете мерло получается более фруктовым и плотным. Вино подходит к запечённой птице, пасте с мясным соусом, твёрдым сырам и пицце.');
INSERT INTO "articles" VALUES(27,'Сира и Шираз: один сорт, два характера','Сорта винограда','4 мин','Хотите перечный характер, берите Сиру Роны; хотите сочность, австралийский Шираз.','Сира родом из долины Роны, и там это вино строгое, с перцем, оливками и копчёностями. В Австралии тот же сорт называют Шираз, и вино получается мощнее, с обилием фруктов, шоколадными и пряными нотами.

Сира хорошо сочетается с жареным мясом, шашлыком, колбасами и сыром с корочкой. Выдержка в дубе добавляет ванили и кофе.');
INSERT INTO "articles" VALUES(28,'Темпранильо: сердце Испании','Сорта винограда','4 мин','На испанской этикетке слова Crianza, Reserva и Gran Reserva говорят о сроке выдержки.','Темпранильо главный красный сорт Испании. Вина из него дают вишню, табак, кожу и ваниль после выдержки в американском дубе. Главные регионы: Риоха, Рибера дель Дуэро, Торо.

Выдержка влияет на название: Крианса выдерживается минимум два года, Резерва три, Гран Резерва пять. Идеальная пара жареный ягнёнок, колбаса и хамон.');
INSERT INTO "articles" VALUES(29,'Санджовезе: душа Тосканы','Сорта винограда','4 мин','Ищите на бутылке чёрного петуха: это знак ассоциации Кьянти Классико.','Санджовезе главный сорт Тосканы. Он даёт яркую кислотность, терпкие танины и вкус вишни, помидоров и сухих трав. Из него делают Кьянти, Брунелло ди Монтальчино и Нобиле ди Монтепульчано.

Из-за кислотности сорт отлично подходит к итальянской кухне: томатным соусам, пицце, сыру пекорино. Кьянти Классико обычно выдерживают от трёх до пяти лет.');
INSERT INTO "articles" VALUES(30,'Мальбек: из Кагора в Аргентину','Сорта винограда','4 мин','Высокогорные вина Мендосы свежее и ароматнее: ищите на этикетке Valle de Uco.','Мальбек родом из Юго-Запада Франции, где из него делают тёмный терпкий Каор. Мировую славу сорт получил в Аргентине, в Мендосе, на высоте около тысячи метров над уровнем моря.

Аргентинский мальбек это мягкое, сочное вино со сливой, ежевикой и фиалкой. Классическая пара стейк на гриле, аргентинский асадо и бургер.');
INSERT INTO "articles" VALUES(31,'Гевюрцтраминер и Вионье: ароматные белые','Сорта винограда','4 мин','Пейте ароматные белые охлаждёнными, но не ледяными, иначе аромат пропадёт.','Гевюрцтраминер узнают сразу: лепестки роз, личи, имбирь, мёд. Вина из него часто имеют низкую кислотность и высокий градус, зато прекрасно подходят к острому и пряному. Родина сорта Эльзас.

Вионье яркий белый из Роны с ароматом персика, абрикоса и жасмина. Он плотный, но не сладкий. Оба сорта подходят к азиатской кухне, мягким сырам и жареной птице.');
INSERT INTO "articles" VALUES(32,'Бордо: левый и правый берег','Регионы и стили','5 мин','Классификация 1855 года относится только к Медоку и Сотерну.','Бордо делится рекой Жиронда на два берега. На Левом берегу, в Медоке, главный сорт Каберне Совиньон, вина мощные и строгие. На Правом, в Сент-Эмильоне и Помероле, господствует Мерло: вина мягче и сочнее.

Бордо делает и белые: сухие из Совиньона и Семильона и сладкие Сотерны. Для начала выберите вино уровня Бордо Супериор, а крупные шато оставьте для особого случая.');
INSERT INTO "articles" VALUES(33,'Бургундия: Пино Нуар и Шардоне','Регионы и стили','5 мин','На бургундской этикетке ищите название деревни и участка: именно они определяют цену.','Бургундия царство Пино Нуара и Шардоне. Здесь главное значение имеет участок: чем уже место происхождения, тем выше ранг. Уровни такие: региональное вино, деревенское, Премьер Крю и Гран Крю.

Красные бургундские вина прозрачные, с вишней, землёй и грибами. Белые, например Шабли и Мерсо, сильно различаются: от минерального и строгого до маслянистого.');
INSERT INTO "articles" VALUES(34,'Тоскана и Пьемонт: два лица Италии','Регионы и стили','5 мин','Бароло лучше открыть за час до подачи или декантировать.','Тоскана родина Санджовезе. Здесь делают Кьянти, Брунелло ди Монтальчино и богатые «супертосканы». Вина яркие, кислотные, идеально подходят к кухне региона.

Пьемонт на севере родина Неббиоло: Бароло и Барбареско. Это вина с розами, дёгтем, высокими танинами и долгой выдержкой. Ещё сюда относятся Барбера, игристое Асти и белое Гави.');
INSERT INTO "articles" VALUES(35,'Испания: Риоха и Рибера дель Дуэро','Регионы и стили','4 мин','Для первого знакомства возьмите Крианцу: у неё лучшее соотношение цены и качества.','Риоха самый известный регион Испании, где царит Темпранильо с американским дубом. Вина мягкие, ванильные, с вишней и кожей. Рибера дель Дуэро даёт более мощные и тёмные вина.

Белые вина Испании это Альбариньо из Риас-Бикас и Вердехо из Руэды. Игристое Кава делают в Каталонии по тому же методу, что и шампанское.');
INSERT INTO "articles" VALUES(36,'Грузинское вино: квеври и янтарные вина','Регионы и стили','4 мин','Янтарные вина лучше подавать чуть теплее белых, около 12–14 °C.','Грузия считается одной из древнейших винных стран мира, история виноделия насчитывает около восьми тысяч лет. Вино здесь традиционно делают в глиняных сосудах квеври, которые закапывают в землю.

Белые сорта, например Ркацители и Мцване, выдерживаются на кожице и получаются янтарными, терпкими и пряными. Из красных главный Саперави, густой, тёмный, с высокой кислотностью и танинами.');
INSERT INTO "concepts" VALUES(1,'Вино','Базовый класс','Алкогольный напиток, получаемый полным или частичным брожением виноградного сусла.');
INSERT INTO "concepts" VALUES(2,'Красное вино','Тип вина','Производится из тёмных сортов с мацерацией на кожице; содержит танины.');
INSERT INTO "concepts" VALUES(3,'Белое вино','Тип вина','Отличается выраженной кислотностью, свежестью и отсутствием танинов.');
INSERT INTO "concepts" VALUES(4,'Розовое вино','Тип вина','Создаётся методом короткого контакта сусла с кожицей красного винограда.');
INSERT INTO "concepts" VALUES(5,'Игристое вино','Тип вина','Насыщено природным диоксидом углерода в результате вторичного брожения.');
INSERT INTO "concepts" VALUES(6,'Сорт винограда','Атрибут','Определяет ароматический профиль, цвет, кислотность и структуру напитка.');
INSERT INTO "concepts" VALUES(7,'Терруар и Регион','География','Совокупность климата, почвы и традиций виноделия конкретного места.');
INSERT INTO "concepts" VALUES(8,'Танинность','Органолептика','Степень терпкости и сухости, важная для расщепления жиров в мясных блюдах.');
INSERT INTO "concepts" VALUES(9,'Кислотность','Органолептика','Освежающая характеристика, балансирующая жирные, сливочные и томатные блюда.');
INSERT INTO "concepts" VALUES(10,'Сладость','Органолептика','Уровень остаточного сахара: сухое, полусухое, полусладкое, сладкое.');
INSERT INTO "concepts" VALUES(11,'Тело вина','Органолептика','Ощущение плотности и веса напитка (лёгкое, среднетелое, полнотелое).');
INSERT INTO "concepts" VALUES(12,'Ароматический букет','Органолептика','Первичные фруктовые, вторичные бродильные и третичные дубовые ноты.');
INSERT INTO "concepts" VALUES(13,'Гастрономическая пара','Сочетаемость','Блюдо, вкус которого гармонирует с характеристиками выбранного вина.');
INSERT INTO "concepts" VALUES(14,'Температура подачи','Сервировка','Оптимальный температурный режим раскрытия аромата и баланса вкуса.');
INSERT INTO "concepts" VALUES(15,'Форма бокала','Сервировка','Инструмент подачи (Бордо, Бургундия, Флюте, Монраше), направляющий аромат.');
INSERT INTO "concepts" VALUES(16,'Декантация','Сервировка','Переливание вина в декантер для насыщения кислородом и отделения осадка.');
INSERT INTO "concepts" VALUES(17,'Каберне Совиньон','Красный сорт','Полнотелый сорт с высокими танинами и нотами чёрной смородины.');
INSERT INTO "concepts" VALUES(18,'Пино Нуар','Красный сорт','Деликатный сорт с низкой танинностью, нотами вишни и малины.');
INSERT INTO "concepts" VALUES(19,'Шардоне','Белый сорт','Пластичный сорт: от минерального Шабли до дубовой Калифорнии.');
INSERT INTO "concepts" VALUES(20,'Совиньон Блан','Белый сорт','Свежий высококислотный сорт с ароматами цитруса, лайма и крыжовника.');
INSERT INTO "concepts" VALUES(21,'Рислинг','Белый сорт','Ароматичный сорт с высокой кислотностью и потенциалом к выдержке.');
INSERT INTO "concepts" VALUES(22,'Стейк и красное мясо','Категория блюд','Плотные белковые и жирные блюда, требующие танинной структуры.');
INSERT INTO "concepts" VALUES(23,'Морепродукты и рыба','Категория блюд','Деликатные блюда, сочетающиеся с кислотными и нетанинными винами.');
INSERT INTO "concepts" VALUES(24,'Десерты','Категория блюд','Сладкие блюда, требующие вин с более высоким уровнем сахара.');
INSERT INTO "relations" VALUES(1,'Красное вино','is_a','Вино','Является подклассом сущности Вино');
INSERT INTO "relations" VALUES(2,'Белое вино','is_a','Вино','Является подклассом сущности Вино');
INSERT INTO "relations" VALUES(3,'Розовое вино','is_a','Вино','Является подклассом сущности Вино');
INSERT INTO "relations" VALUES(4,'Игристое вино','is_a','Вино','Является подклассом сущности Вино');
INSERT INTO "relations" VALUES(5,'Вино','made_from','Сорт винограда','Производится из одного или нескольких сортов');
INSERT INTO "relations" VALUES(6,'Вино','produced_in','Терруар и Регион','Обладает географическим происхождением');
INSERT INTO "relations" VALUES(7,'Вино','has_aroma','Ароматический букет','Характеризуется набором ароматических дескрипторов');
INSERT INTO "relations" VALUES(8,'Вино','pairs_with','Гастрономическая пара','Рекомендуется к определённым категориям блюд');
INSERT INTO "relations" VALUES(9,'Вино','served_at','Температура подачи','Требует соблюдения температурного диапазона');
INSERT INTO "relations" VALUES(10,'Вино','requires_glass','Форма бокала','Раскрывается в специализированном бокале');
INSERT INTO "relations" VALUES(11,'Каберне Совиньон','has_tannins','Танинность','Обладает высоким уровнем полифенольных танинов');
INSERT INTO "relations" VALUES(12,'Пино Нуар','pairs_with','Морепродукты и рыба','Низкие танины допускают сочетание с жирной рыбой');
INSERT INTO "relations" VALUES(13,'Танинность','balances','Стейк и красное мясо','Танины расщепляют жиры и смягчают вкус мяса');
INSERT INTO "relations" VALUES(14,'Кислотность','balances','Морепродукты и рыба','Кислотность освежает вкус и работает как лимон');
INSERT INTO "relations" VALUES(15,'Сладость','matches','Десерты','Вино должно быть не менее сладким, чем десерт');
INSERT INTO "relations" VALUES(16,'Совиньон Блан','has_acidity','Кислотность','Характеризуется высокой хрустящей кислотностью');
INSERT INTO "relations" VALUES(17,'Рислинг','balances','Острая кухня','Остаточный сахар смягчает жгучесть специй');
INSERT INTO "relations" VALUES(18,'Красное вино','benefits_from','Декантация','Полнотелые красные вина смягчаются при аэрации');
INSERT INTO "rules" VALUES('R01','Стейк и красное мясо','Красное','Полнотелые красные вина с выраженными танинами связывают белки и балансируют жирность жареного мяса.');
INSERT INTO "rules" VALUES('R02','Стейк и красное мясо','Розовое','Насыщенное испанское розе из сорта Гарнача справится с лёгким стейком или мясом на гриле в жаркую погоду.');
INSERT INTO "rules" VALUES('R03','Барбекю и шашлык','Красное','Сочные ягодные красные вина с пряным профилем идеально дополняют дымный аромат мяса с мангала.');
INSERT INTO "rules" VALUES('R04','Барбекю и шашлык','Розовое','Сухое гастрономичное розе отлично освежает на пикнике и сочетается с шашлыком из курицы или свинины.');
INSERT INTO "rules" VALUES('R05','Рыба','Белое','Белые вина обладают необходимой кислотностью, работают подобно соку лимона и не дают металлического привкуса.');
INSERT INTO "rules" VALUES('R06','Рыба','Красное','Из красных к рыбе (особенно лососю и тунцу) подходят только деликатные вина с минимальными танинами — например, Пино Нуар.');
INSERT INTO "rules" VALUES('R07','Рыба','Игристое','Пузырьки и высокая кислотность сухого игристого превосходно подчёркивают нежный вкус запечённой или слабосолёной рыбы.');
INSERT INTO "rules" VALUES('R08','Морепродукты','Белое','Минеральные белые вина без дуба и танинов — классическая пара к устрицам, креветкам и мидиям.');
INSERT INTO "rules" VALUES('R09','Морепродукты','Игристое','Шампанское брют и Кава — идеальный гастрономический аккомпанемент к морским деликатесам.');
INSERT INTO "rules" VALUES('R10','Морепродукты','Розовое','Сухое прованское розе деликатно подчёркивает сладость креветок, гребешков и краба.');
INSERT INTO "rules" VALUES('R11','Птица','Красное','Лёгкие и среднетельные красные вина не перебивают нежное мясо курицы, индейки или утки.');
INSERT INTO "rules" VALUES('R12','Птица','Белое','Выдержанное Шардоне или австрийский Грюнер Вельтлинер отлично сочетаются с птицей в сливочном соусе.');
INSERT INTO "rules" VALUES('R13','Паста и пицца','Красное','Высокая вишнёвая кислотность Кьянти Classico уравновешивает кислотность томатных соусов и сыра.');
INSERT INTO "rules" VALUES('R14','Паста и пицца','Белое','К пасте со сливочными соусами, морепродуктами или песто идеально подходит сухое белое вино.');
INSERT INTO "rules" VALUES('R15','Сыры','Красное','Выдержанные твёрдые сыры (пармезан, пекорино, чеддер) требуют структурных красных вин с хорошей кислотностью.');
INSERT INTO "rules" VALUES('R16','Сыры','Белое','Совиньон Блан незаменим к козьим сырам, а сладкий Сотерн и пряный Гевюрцтраминер — к сырам с голубой плесенью.');
INSERT INTO "rules" VALUES('R17','Салаты и закуски','Белое','Лёгкие, травянистые и цитрусовые белые вина гармонируют со свежей зеленью и лёгкими заправками.');
INSERT INTO "rules" VALUES('R18','Острая кухня','Белое','Остаточная сладость и низкий алкоголь Рислинга и Гевюрцтраминера гасят жгучесть специй, в отличие от танинных вин.');
INSERT INTO "rules" VALUES('R19','Десерты','Игристое','Сладкое ароматное игристое из белого муската не проигрывает сладости фруктовых тартов и бисквитов.');
INSERT INTO "rules" VALUES('R20','Десерты','Белое','По правилу сомелье вино к десерту должно быть слаще самого блюда — благородный Сотерн и сладкий Рислинг подходят идеально.');
INSERT INTO "rule_wines" VALUES('R01',0,'Château Margaux Reserve');
INSERT INTO "rule_wines" VALUES('R01',1,'Catena Zapata Malbec');
INSERT INTO "rule_wines" VALUES('R01',2,'Teliani Valley Saperavi');
INSERT INTO "rule_wines" VALUES('R01',3,'Penfolds Koonunga Hill Shiraz');
INSERT INTO "rule_wines" VALUES('R01',4,'Barolo Serralunga d''Alba');
INSERT INTO "rule_wines" VALUES('R02',0,'Torres De Casta Rosado');
INSERT INTO "rule_wines" VALUES('R03',0,'Teliani Valley Saperavi');
INSERT INTO "rule_wines" VALUES('R03',1,'Catena Zapata Malbec');
INSERT INTO "rule_wines" VALUES('R03',2,'Penfolds Koonunga Hill Shiraz');
INSERT INTO "rule_wines" VALUES('R04',0,'Torres De Casta Rosado');
INSERT INTO "rule_wines" VALUES('R04',1,'Whispering Angel Rosé');
INSERT INTO "rule_wines" VALUES('R05',0,'Chablis Premier Cru William Fèvre');
INSERT INTO "rule_wines" VALUES('R05',1,'Kendall-Jackson Chardonnay');
INSERT INTO "rule_wines" VALUES('R05',2,'Cloudy Bay Sauvignon Blanc');
INSERT INTO "rule_wines" VALUES('R05',3,'Santa Margherita Pinot Grigio');
INSERT INTO "rule_wines" VALUES('R06',0,'Louis Jadot Bourgogne Pinot Noir');
INSERT INTO "rule_wines" VALUES('R07',0,'Moët & Chandon Impérial Brut');
INSERT INTO "rule_wines" VALUES('R07',1,'Prosecco Valdobbiadene Superiore');
INSERT INTO "rule_wines" VALUES('R07',2,'Cava Freixenet Cordón Negro');
INSERT INTO "rule_wines" VALUES('R08',0,'Chablis Premier Cru William Fèvre');
INSERT INTO "rule_wines" VALUES('R08',1,'Cloudy Bay Sauvignon Blanc');
INSERT INTO "rule_wines" VALUES('R08',2,'Vinho Verde Quinta da Aveleda');
INSERT INTO "rule_wines" VALUES('R08',3,'Santa Margherita Pinot Grigio');
INSERT INTO "rule_wines" VALUES('R09',0,'Moët & Chandon Impérial Brut');
INSERT INTO "rule_wines" VALUES('R09',1,'Prosecco Valdobbiadene Superiore');
INSERT INTO "rule_wines" VALUES('R09',2,'Cava Freixenet Cordón Negro');
INSERT INTO "rule_wines" VALUES('R10',0,'Whispering Angel Rosé');
INSERT INTO "rule_wines" VALUES('R11',0,'Louis Jadot Bourgogne Pinot Noir');
INSERT INTO "rule_wines" VALUES('R11',1,'Marqués de Riscal Reserva');
INSERT INTO "rule_wines" VALUES('R11',2,'Casillero del Diablo Carmenere');
INSERT INTO "rule_wines" VALUES('R12',0,'Kendall-Jackson Chardonnay');
INSERT INTO "rule_wines" VALUES('R12',1,'Chablis Premier Cru William Fèvre');
INSERT INTO "rule_wines" VALUES('R12',2,'Grüner Veltliner Lois');
INSERT INTO "rule_wines" VALUES('R13',0,'Villa Antinori Chianti Classico');
INSERT INTO "rule_wines" VALUES('R13',1,'Casillero del Diablo Carmenere');
INSERT INTO "rule_wines" VALUES('R13',2,'Marqués de Riscal Reserva');
INSERT INTO "rule_wines" VALUES('R14',0,'Kendall-Jackson Chardonnay');
INSERT INTO "rule_wines" VALUES('R14',1,'Santa Margherita Pinot Grigio');
INSERT INTO "rule_wines" VALUES('R15',0,'Barolo Serralunga d''Alba');
INSERT INTO "rule_wines" VALUES('R15',1,'Château Margaux Reserve');
INSERT INTO "rule_wines" VALUES('R15',2,'Marqués de Riscal Reserva');
INSERT INTO "rule_wines" VALUES('R15',3,'Villa Antinori Chianti Classico');
INSERT INTO "rule_wines" VALUES('R16',0,'Sauternes Château Guiraud');
INSERT INTO "rule_wines" VALUES('R16',1,'Cloudy Bay Sauvignon Blanc');
INSERT INTO "rule_wines" VALUES('R16',2,'Trimbach Gewürztraminer');
INSERT INTO "rule_wines" VALUES('R17',0,'Cloudy Bay Sauvignon Blanc');
INSERT INTO "rule_wines" VALUES('R17',1,'Vinho Verde Quinta da Aveleda');
INSERT INTO "rule_wines" VALUES('R17',2,'Grüner Veltliner Lois');
INSERT INTO "rule_wines" VALUES('R17',3,'Santa Margherita Pinot Grigio');
INSERT INTO "rule_wines" VALUES('R18',0,'Dr. Loosen Riesling Kabinett');
INSERT INTO "rule_wines" VALUES('R18',1,'Trimbach Gewürztraminer');
INSERT INTO "rule_wines" VALUES('R19',0,'Martini Asti DOCG');
INSERT INTO "rule_wines" VALUES('R20',0,'Sauternes Château Guiraud');
INSERT INTO "rule_wines" VALUES('R20',1,'Dr. Loosen Riesling Kabinett');
INSERT INTO "videos" VALUES(1,'Какое вино подать к стейку и красному мясу','Гастрономия','Как танины и жир мяса работают вместе, и какие красные вина выбрать к стейку.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%20%D0%B2%D1%8B%D0%B1%D1%80%D0%B0%D1%82%D1%8C%20%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D1%81%D1%82%D0%B5%D0%B9%D0%BA%D1%83','dish','Стейк и красное мясо');
INSERT INTO "videos" VALUES(2,'Вино к рыбе и морепродуктам','Гастрономия','Белые, игристые и даже лёгкие красные: что подходит к рыбе, устрицам и креветкам.','https://www.youtube.com/results?search_query=%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D1%80%D1%8B%D0%B1%D0%B5%20%D0%B8%20%D0%BC%D0%BE%D1%80%D0%B5%D0%BF%D1%80%D0%BE%D0%B4%D1%83%D0%BA%D1%82%D0%B0%D0%BC%20%D1%81%D0%BE%D0%BC%D0%B5%D0%BB%D1%8C%D0%B5','dish','Морепродукты');
INSERT INTO "videos" VALUES(3,'Вино и сыр: пары, которые работают','Гастрономия','Козьи, твёрдые и голубые сыры: подбираем вино к каждому типу.','https://www.youtube.com/results?search_query=%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%B8%20%D1%81%D1%8B%D1%80%20%D1%81%D0%BE%D1%87%D0%B5%D1%82%D0%B0%D0%BD%D0%B8%D0%B5%20%D1%81%D0%BE%D0%BC%D0%B5%D0%BB%D1%8C%D0%B5','dish','Сыры');
INSERT INTO "videos" VALUES(4,'Вино к шашлыку и барбекю','Гастрономия','Какое красное или розовое вино выбрать для пикника и мангала.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%D0%BE%D0%B5%20%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D1%88%D0%B0%D1%88%D0%BB%D1%8B%D0%BA%D1%83','dish','Барбекю и шашлык');
INSERT INTO "videos" VALUES(5,'Вино к пасте и пицце','Гастрономия','Как подобрать вино к томатным, сливочным и мясным соусам.','https://www.youtube.com/results?search_query=%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D0%BF%D0%B0%D1%81%D1%82%D0%B5%20%D0%B8%20%D0%BF%D0%B8%D1%86%D1%86%D0%B5%20%D1%81%D0%BE%D0%BC%D0%B5%D0%BB%D1%8C%D0%B5','dish','Паста и пицца');
INSERT INTO "videos" VALUES(6,'Вино к острой кухне','Гастрономия','Почему к острому подходят Рислинг и Гевюрцтраминер.','https://www.youtube.com/results?search_query=%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D0%BE%D1%81%D1%82%D1%80%D0%BE%D0%B9%20%D0%BA%D1%83%D1%85%D0%BD%D0%B5','dish','Острая кухня');
INSERT INTO "videos" VALUES(7,'Вино к десертам','Гастрономия','Сотерн, Асти, Токай и другие десертные вина: как их сочетать со сладким.','https://www.youtube.com/results?search_query=%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%20%D0%B4%D0%B5%D1%81%D0%B5%D1%80%D1%82%D0%B0%D0%BC%20%D0%BA%D0%B0%D0%BA%20%D0%B2%D1%8B%D0%B1%D1%80%D0%B0%D1%82%D1%8C','dish','Десерты');
INSERT INTO "videos" VALUES(8,'Как дегустировать вино: цвет, аромат, вкус','Основы дегустации','Четыре шага дегустации и как распознавать ароматы в бокале.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%20%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D0%BB%D1%8C%D0%BD%D0%BE%20%D0%B4%D0%B5%D0%B3%D1%83%D1%81%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C%20%D0%B2%D0%B8%D0%BD%D0%BE','cat','Основы дегустации');
INSERT INTO "videos" VALUES(9,'Что такое танины и кислотность в вине','Основы дегустации','Простое объяснение главных структурных элементов вина.','https://www.youtube.com/results?search_query=%D1%82%D0%B0%D0%BD%D0%B8%D0%BD%D1%8B%20%D0%B8%20%D0%BA%D0%B8%D1%81%D0%BB%D0%BE%D1%82%D0%BD%D0%BE%D1%81%D1%82%D1%8C%20%D0%B2%20%D0%B2%D0%B8%D0%BD%D0%B5%20%D0%BF%D1%80%D0%BE%D1%81%D1%82%D1%8B%D0%BC%D0%B8%20%D1%81%D0%BB%D0%BE%D0%B2%D0%B0%D0%BC%D0%B8','cat','Основы дегустации');
INSERT INTO "videos" VALUES(10,'Как читать винную этикетку','Регионы и стили','Что значат названия, годы и обозначения на бутылке Старого и Нового Света.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%20%D1%87%D0%B8%D1%82%D0%B0%D1%82%D1%8C%20%D0%B2%D0%B8%D0%BD%D0%BD%D1%83%D1%8E%20%D1%8D%D1%82%D0%B8%D0%BA%D0%B5%D1%82%D0%BA%D1%83','cat','Регионы и стили');
INSERT INTO "videos" VALUES(11,'Основные сорта винограда для начинающих','Сорта винограда','Каберне, Мерло, Пино Нуар, Шардоне, Рислинг: чем они отличаются.','https://www.youtube.com/results?search_query=%D1%81%D0%BE%D1%80%D1%82%D0%B0%20%D0%B2%D0%B8%D0%BD%D0%BE%D0%B3%D1%80%D0%B0%D0%B4%D0%B0%20%D0%B4%D0%BB%D1%8F%20%D0%BD%D0%B0%D1%87%D0%B8%D0%BD%D0%B0%D1%8E%D1%89%D0%B8%D1%85%20%D0%B2%D0%B8%D0%BD%D0%BE','cat','Сорта винограда');
INSERT INTO "videos" VALUES(12,'Шардоне против Совиньон Блан','Сорта винограда','Два главных белых сорта: сравниваем вкус, стиль и блюда.','https://www.youtube.com/results?search_query=%D1%88%D0%B0%D1%80%D0%B4%D0%BE%D0%BD%D0%B5%20%D0%B8%20%D1%81%D0%BE%D0%B2%D0%B8%D0%BD%D1%8C%D0%BE%D0%BD%20%D0%B1%D0%BB%D0%B0%D0%BD%20%D1%80%D0%B0%D0%B7%D0%BD%D0%B8%D1%86%D0%B0','cat','Сорта винограда');
INSERT INTO "videos" VALUES(13,'Бордо и Бургундия: две столицы вина','Регионы и стили','Чем отличаются два самых известных французских региона.','https://www.youtube.com/results?search_query=%D0%B1%D0%BE%D1%80%D0%B4%D0%BE%20%D0%B8%20%D0%B1%D1%83%D1%80%D0%B3%D1%83%D0%BD%D0%B4%D0%B8%D1%8F%20%D0%BE%D1%82%D0%BB%D0%B8%D1%87%D0%B8%D1%8F%20%D0%B2%D0%B8%D0%BD%D0%BE','cat','Регионы и стили');
INSERT INTO "videos" VALUES(14,'Итальянские вина: Кьянти, Бароло, Просекко','Регионы и стили','Тоскана, Пьемонт и Венето: ключевые вина Италии.','https://www.youtube.com/results?search_query=%D0%B8%D1%82%D0%B0%D0%BB%D1%8C%D1%8F%D0%BD%D1%81%D0%BA%D0%B8%D0%B5%20%D0%B2%D0%B8%D0%BD%D0%B0%20%D0%BA%D1%8C%D1%8F%D0%BD%D1%82%D0%B8%20%D0%B1%D0%B0%D1%80%D0%BE%D0%BB%D0%BE%20%D0%BF%D1%80%D0%BE%D1%81%D0%B5%D0%BA%D0%BA%D0%BE','cat','Регионы и стили');
INSERT INTO "videos" VALUES(15,'Грузинское вино и квеври','Регионы и стили','Как делают янтарные вина в глиняных сосудах.','https://www.youtube.com/results?search_query=%D0%B3%D1%80%D1%83%D0%B7%D0%B8%D0%BD%D1%81%D0%BA%D0%BE%D0%B5%20%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%BA%D0%B2%D0%B5%D0%B2%D1%80%D0%B8%20%D0%BA%D0%B0%D0%BA%20%D0%B4%D0%B5%D0%BB%D0%B0%D1%8E%D1%82','cat','Регионы и стили');
INSERT INTO "videos" VALUES(16,'Игристые вина: шампанское, просекко, кава','Регионы и стили','Методы производства и разница между главными игристыми.','https://www.youtube.com/results?search_query=%D1%88%D0%B0%D0%BC%D0%BF%D0%B0%D0%BD%D1%81%D0%BA%D0%BE%D0%B5%20%D0%BF%D1%80%D0%BE%D1%81%D0%B5%D0%BA%D0%BA%D0%BE%20%D0%BA%D0%B0%D0%B2%D0%B0%20%D1%80%D0%B0%D0%B7%D0%BD%D0%B8%D1%86%D0%B0','cat','Регионы и стили');
INSERT INTO "videos" VALUES(17,'Как открыть шампанское и подать вино','Сервировка','Правильное открытие бутылки и температура подачи.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%20%D0%BF%D1%80%D0%B0%D0%B2%D0%B8%D0%BB%D1%8C%D0%BD%D0%BE%20%D0%BE%D1%82%D0%BA%D1%80%D1%8B%D1%82%D1%8C%20%D1%88%D0%B0%D0%BC%D0%BF%D0%B0%D0%BD%D1%81%D0%BA%D0%BE%D0%B5','cat','Сервировка');
INSERT INTO "videos" VALUES(18,'Бокалы для вина и декантация','Сервировка','Какие бывают бокалы и зачем нужен декантер.','https://www.youtube.com/results?search_query=%D0%B1%D0%BE%D0%BA%D0%B0%D0%BB%D1%8B%20%D0%B4%D0%BB%D1%8F%20%D0%B2%D0%B8%D0%BD%D0%B0%20%D0%BA%D0%B0%D0%BA%D0%B8%D0%B5%20%D0%B1%D1%8B%D0%B2%D0%B0%D1%8E%D1%82%20%D0%B4%D0%B5%D0%BA%D0%B0%D0%BD%D1%82%D0%B0%D1%86%D0%B8%D1%8F','cat','Сервировка');
INSERT INTO "videos" VALUES(19,'Как хранить вино дома','Сервировка','Условия хранения, которые сохранят вкус бутылки.','https://www.youtube.com/results?search_query=%D0%BA%D0%B0%D0%BA%20%D1%85%D1%80%D0%B0%D0%BD%D0%B8%D1%82%D1%8C%20%D0%B2%D0%B8%D0%BD%D0%BE%20%D0%B4%D0%BE%D0%BC%D0%B0','cat','Сервировка');
COMMIT;
