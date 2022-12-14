create extension if not exists "uuid-ossp";

begin;

  truncate categories cascade;
  truncate products cascade;

  create temporary table menu (
    id serial primary key,
    name_pl text, name_en text,
    description_pl text, description_en text,
    category text, price decimal
  );

copy menu (name_pl, name_en, description_pl, description_en, category, price)
from stdin csv header;
name_pl,name_en,description_pl,description_en,category,price
Daal,,wyborna wegańska zupa z czerwonej soczewicy,delicious red lentil soup,Zupy,18
Zupa Dnia,Soup of the Day,zapytaj kelnerkę,ask the waitress,Zupy,
Mix Pakora ,Indian Fritters,"chrupiące szatkowane warzywa smażone w panierce z mąki cieciorkowej, podawane z pikantnym sosem","crispy pieces of vegetables deep-fried in batter, served with spicy sauce",Przystawki,20
Aloo Tiki,Potato Patties,smakowite kotleciki warzywno-ziemniaczane przyprawione ziołami i indyjskimi przyprawami,spiced potato cutlets with herbs and Indian spices,Przystawki,25
Samosa Vege,Vege Samosa,pierożki indyjskie z nadzieniem warzywnym (3 szt.),Indian dumplings with vegetable filling (3 pcs.),Przystawki,25
Samosa z mięsem,Meat Samosa,pierożki indyjskie z mieloną wieprzowiną (3 szt.),Indian dumplings with minced pork (3 pcs.),Przystawki,25
Aloo Gobi,,aromatyczny kalafior z ziemniakami w gęstym sosie z groszkiem,cauliflower and potatoes cooked in aromatic sauce ,Vege,36
Daal,,pożywna tradycyjna potrawa z soczewicy,nourishing traditional lentil dish,Vege,32
Pindi Chana,,wyśmienita cieciorka w stylu Punjabi w sosie z granatu,delicious chickpea dish prepared in Punjabi style in granate sauce,Vege,33
Saag ,,zielone liście musztardowca duszone z czosnkiem i indyjskimi przyprawami,green mustard leaves stewed with garlic and Indian spices,Vege,35
Chili Chicken ,,pierś z kurczaka smażona z papryczkami chili,chicken breast fried with chili peppers,Dania główne · Mains,42
Chicken Sabji,,kurczak duszony w aksamitnym sosie warzywnym,chicken stewed in velvety vegetable sauce,Dania główne · Mains,45
Chicken Saag,,kurczak w sosie z liśćmi musztardowca ,chicken with mustard leaves sauce,Dania główne · Mains,42
Chili Pork ,,"soczyste kawałki wieprzowiny, z papryką, cebulką i papryczkami chili, ostry dreszcz w każdym kęsie","tender pork with hot chillies, onion and bell pepper",Dania główne · Mains,44
Pork Saag,,wieprzowina w z sosie z liśćmi musztardowca i indyjskimi przyprawami,tender pork in sauce with mustard leaves and Indian spices,Dania główne · Mains,44
Pork Bhuna,,mięso wieprzowe w bogatym sosie własnym z ciecierzycą,pork in rich sauce full of captivating flavors with chickpeas,Dania główne · Mains,44
Keema Mathar ,,mielona jagnięcina gotowana z groszkiem i przyprawami indyjskimi,minced lamb cooked with pea and Indian spices,Dania główne · Mains,52
Chili Keema ,,mielona pikantna jagnięcina gotowana z cebulką i papryką,spicy minced lamb stewed with onion and bell pepper,Dania główne · Mains,52
Keema Bhuna,,mielona jagnięcina duszona na wolnym ogniu z ciecierzycą w aromatycznym sosie z granatu,slow-cooked minced lamb with chickpeas and pomegranate sauce,Dania główne · Mains,52
Kadai Prawns,,"krewetki w gęstym sosie paprykowo-pomidorowym z cebulką, imbirem i czosnkiem ",prawn with paprika cooked in onion-tomato gravy,Dania główne · Mains,48
Veg Biryani / 2os.,,tradycyjna indyjska potrawa z ryżu i warzywami i przyprawami,traditional Indian rice and vegetable dish ,Dania główne · Mains,64
Chicken Biryani / 2 os.,,tradycyjna indyjska potrawa z ryżu i kurczaka z warzywami i przyprawami,traditional Indian rice and chicken dish ,Dania główne · Mains,68
Pork Biryani / 2os.,,tradycyjna indyjska potrawa z ryżu i mięsa wieprzowego z warzywami i przyprawami,traditional Indian rice and pork dish,Dania główne · Mains,68
Lamb Biryani / 2os.,,tradycyjna indyjska potrawa z ryżu i jagnięciny z warzywami i przyprawami,traditional Indian lamb and pork dish,Dania główne · Mains,84
Lamburchili,,burger z jagnięciny przyprawiony w stylu indyjskim podawany z frytkami i sałatką warzywną,Indian spiced lamb burger served with french fries and side salad,Burgery,45
Chicken tikka burger,,aromatyczny burger z kurczaka podawany z frytkami i sałatką warzywną,Indian spiced chicken burger served with french fries and side salad,Burgery,38
Falafel burger,,burger wegański z kotlecikiem z ciecierzycy podawany z frytkami i sałatką warzywną,vegan chickpeas burger served with french fries and side salad,Burgery,32
Mixed salad ,,,,Dodatki,10
Chlebek Naan,Naan bread,,,Dodatki,8
Chlebek Naan z czosnkiem,Naan bread with garlic,,,Dodatki,10
Chlebek Naan z masełkiem,Naan bread with butter,,,Dodatki,10
Raita,,sos jogurtowy z ogórkiem,,Dodatki,8
Sałatka z kurczakiem marynowanym w indyjskich przyprawach,,,Chicken tikka salad,Sałatki,35
Sałatka z krewetkami marynowanymi w imbirze i czosnku,,,Prawn marinated with ginger and garlic served on salad,Sałatki,39
Sałatka ze świeżych warzyw z oliwkami,,,Fresh vegetable salad with olives,Sałatki,25
Sorbet z bakaliami,,,,Desery,22
Deser dnia,Dessert of the day,zapytaj kelnerkę,ask the waitress,Desery,
"Piwo Tyskie z beczki 0,3l",,,,Napoje,10
"Piwo Tyskie z beczki 0,5l",,,,Napoje,12
"Lech Pils 0,5l",,,,Napoje,12
"Piwo Książęce Pszeniczne 0,5l",,,,Napoje,14
"Piwo Książęce Ciemne 0,5l",,,,Napoje,14
"Lech Free 0,3l",,,,Napoje,8
Wino domowe 175ml ,Vino da casa 175ml,,,Napoje,15
"Wino domowe karafka 0,5l ","Vino da casa 0,5l",,,Napoje,36
Herbata ,Tea,,,Napoje,8
Herbata z przyprawami indyjski,Chai,,,Napoje,8
Kawa czarna ,Black coffee,,,Napoje,10
Kawa z mlekiem ,Coffee with milk,,,Napoje,12
Mango Lassi,,,,Napoje,12
Woda mineralna,Mineral water,,,Napoje,6
"Napoje gazowane, soki","Soft drinks, fruit juices",,,Napoje,10
\.

  insert into categories (id, name_pl, name_en, slug, inserted_at, updated_at)
  select uuid_generate_v4(), names[1], names[2], slugify(names[1]), now() at time zone 'utc', now() at time zone 'utc' from (
    select distinct regexp_split_to_array(category, '\s*·\s*') names from menu
  ) s;

  insert into products (id, name_pl, name_en, slug, description_pl, description_en, price, inserted_at, updated_at)
  select uuid_generate_v4(), name_pl, name_en, slugify(name_pl) || '-' || substring(uuid_generate_v4()::text, 1, 4), description_pl, description_en, price, now() at time zone 'utc', now() at time zone 'utc'
  from menu;

  insert into products_categories (product_id, category_id, inserted_at) 
  select p.id, c.id, now() at time zone 'utc' from products p
  join menu m on m.name_pl = p.name_pl and (m.name_en = p.name_en or m.name_en is null and p.name_en is null) and (m.price = p.price or m.price is null and p.price is null)
  join categories c on c.name_pl = (regexp_split_to_array(category, '\s*·\s*'))[1];
commit;
