-- 1) Zalijepi cijeli ovaj SQL u Supabase > SQL Editor > New query > Run.
-- Tablice javno čitljive; izmjene dopuštene samo vlasniku s Auth app_metadata role=admin.
create table if not exists public.games (
 id text primary key,
 name text not null check (length(btrim(name)) between 1 and 140),
 category text not null,
 players integer[] not null default '{}',
 difficulty text not null,
 description text not null,
 rules_learning boolean not null default false,
 expansions text[] not null default '{}',
 created_at timestamptz not null default now()
);
create table if not exists public.events (
 id text primary key,
 title text not null check (length(btrim(title)) between 1 and 140),
 description text not null default '',
 event_date date not null,
 event_time time not null,
 location text not null,
 contact text not null default 'gordan.belas@gmail.com',
 created_at timestamptz not null default now()
);
alter table public.games enable row level security;
alter table public.events enable row level security;
revoke all on table public.games, public.events from anon, authenticated;
grant select on table public.games, public.events to anon, authenticated;
grant insert, update, delete on table public.games, public.events to authenticated;
drop policy if exists "Public can read games" on public.games;
drop policy if exists "Public can read events" on public.events;
drop policy if exists "Admins manage games" on public.games;
drop policy if exists "Admins manage events" on public.events;
create policy "Public can read games" on public.games for select to anon, authenticated using (true);
create policy "Public can read events" on public.events for select to anon, authenticated using (true);
create policy "Admins manage games" on public.games for all to authenticated
 using ((select auth.jwt()->'app_metadata'->>'role') = 'admin')
 with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
create policy "Admins manage events" on public.events for all to authenticated
 using ((select auth.jwt()->'app_metadata'->>'role') = 'admin')
 with check ((select auth.jwt()->'app_metadata'->>'role') = 'admin');
insert into public.games (id,name,category,players,difficulty,description,rules_learning,expansions) values
('1','Dune: Imperium – Uprising','Strategija',ARRAY[1,2,3,4,6]::integer[],'Zahtjevno','Izgradnja špila, postavljanje agenata i borba za političku i vojnu prevlast na Arrakisu.',false,ARRAY[]::text[]),
('2','Mistborn: The Deckbuilding Game','Kartaška igra',ARRAY[1,2,3,4]::integer[],'Srednje','Gradite špil i koristite alomantijske moći spaljivanjem metala. Igrajte natjecateljski ili se zajednički suprotstavite Lordu Vladaru.',false,ARRAY[]::text[]),
('3','Brass: Birmingham','Ekonomska strategija',ARRAY[2,3,4]::integer[],'Zahtjevno','Razvijajte industriju, financirajte poduzeća i gradite prometnu mrežu u vrijeme industrijske revolucije.',false,ARRAY[]::text[]),
('4','Blood Rage','Sukob i teritoriji',ARRAY[2,3,4]::integer[],'Srednje','Vodite vikinški klan prema slavi kroz odabir karata, osvajanja i borbe prije Ragnaröka.',false,ARRAY[]::text[]),
('5','Fallout','Avantura',ARRAY[1,2,3,4]::integer[],'Srednje','Istražujte postapokaliptičnu pustoš, razvijajte lika i rješavajte zadatke kroz susrete i odluke.',true,ARRAY[]::text[]),
('6','Wingspan','Strategija',ARRAY[1,2,3,4,5]::integer[],'Srednje','Privlačite ptice u staništa i povezujte njihove sposobnosti u sve učinkovitiji sustav akcija.',false,ARRAY[]::text[]),
('7','This War of Mine','Kooperativna igra',ARRAY[1,2,3,4,5,6]::integer[],'Zahtjevno','Pomozite civilima preživjeti u opkoljenom gradu uz oskudne resurse i teške moralne odluke.',false,ARRAY[]::text[]),
('8','Terraforming Mars','Ekonomska strategija',ARRAY[1,2,3,4,5]::integer[],'Zahtjevno','Razvijajte korporaciju i projekte kojima podižete temperaturu, kisik i oceane na Marsu.',false,ARRAY[]::text[]),
('9','Cthulhu: Death May Die','Kooperativna igra',ARRAY[1,2,3,4,5]::integer[],'Srednje','Zajednički prekidajte obrede, borite se s kultistima i suočite s drevnim užasima.',false,ARRAY['Cthulhu: Death May Die – Season 2 Expansion','Cthulhu: Death May Die – Yog-Sothoth Expansion']::text[]),
('10','Gloomhaven: Jaws of the Lion','Kampanja',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Taktička kooperativna kampanja u kojoj kartama upravljate kretanjem i napadima kroz povezane scenarije.',false,ARRAY[]::text[]),
('11','Inferno','Ekonomska strategija',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Povežite spletke u Firenci s vođenjem duša kroz devet krugova Danteova Pakla. Usmjeravajte grešnike i stječite zloglasnost.',false,ARRAY[]::text[]),
('12','Star Wars: Rebellion','Sukob i teritoriji',ARRAY[2,3,4]::integer[],'Zahtjevno','Imperij traži skrivenu bazu, dok Pobunjenici izvode misije i prikupljaju potporu u galaktičkom sukobu.',false,ARRAY[]::text[]),
('13','Root','Sukob i teritoriji',ARRAY[2,3,4]::integer[],'Zahtjevno','Asimetrične šumske frakcije bore se za prevlast koristeći vlastita pravila i načine bodovanja.',true,ARRAY[]::text[]),
('14','A Feast for Odin','Ekonomska strategija',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Postavljajte radnike, trgujte, istražujte i slažite pločice dobara razvijajući vikinško naselje.',true,ARRAY[]::text[]),
('15','Ticket to Ride: Legends of the West','Legacy / kampanja',ARRAY[2,3,4,5]::integer[],'Srednje','Gradite željezničke rute kroz povezane partije koje donose nove mogućnosti i trajne promjene kampanje.',true,ARRAY[]::text[]),
('16','Ark Nova','Ekonomska strategija',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Gradite zoološki vrt, smještajte životinje i podupirite zaštitu vrsta pažljivim odabirom akcija.',false,ARRAY[]::text[]),
('17','The Lord of the Rings: War of the Ring','Sukob i teritoriji',ARRAY[2,3,4]::integer[],'Zahtjevno','Vodite rat u Međuzemlju dok Prstenova družina pokušava dovršiti svoje opasno putovanje.',false,ARRAY[]::text[]),
('18','Pandemic Legacy: Season 1','Legacy / kampanja',ARRAY[2,3,4]::integer[],'Srednje','Zajedno zaustavljajte epidemije u kampanji čije posljedice trajno mijenjaju ploču, likove i pravila.',true,ARRAY[]::text[]),
('19','SETI: Search for Extraterrestrial Intelligence','Ekonomska strategija',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Tražite izvanzemaljski život slanjem sondi, obradom podataka i razvojem znanstvenih tehnologija.',false,ARRAY[]::text[]),
('20','Lost Ruins of Arnak','Strategija',ARRAY[1,2,3,4]::integer[],'Srednje','Spajajte izgradnju špila i postavljanje radnika kako biste istražili ruševine i svladali čuvare.',false,ARRAY[]::text[]),
('21','Andromeda’s Edge','Svemirska strategija',ARRAY[2,3,4]::integer[],'Zahtjevno','Raspoređujte brodove, razvijajte postaju i natječite se za resurse i tehnologije na rubu galaksije.',false,ARRAY[]::text[]),
('22','Scythe','Strategija',ARRAY[1,2,3,4,5]::integer[],'Zahtjevno','Razvijajte gospodarstvo, širite utjecaj i koristite mechove u alternativnoj povijesti Europe.',false,ARRAY[]::text[]),
('23','Nemesis: Lockdown','Preživljavanje',ARRAY[1,2,3,4,5]::integer[],'Zahtjevno','Preživite u postrojenju na Marsu uz upravljanje energijom, prijetnje i skrivene interese suigrača.',false,ARRAY[]::text[]),
('24','Twilight Imperium: Rex','Sukob i teritoriji',ARRAY[3,4,5,6]::integer[],'Zahtjevno','Pregovarajte, sklapajte saveze i borite se za Mecatol City u igri Rex: Final Days of an Empire.',false,ARRAY[]::text[]),
('25','The Witcher: Old World','Avantura',ARRAY[1,2,3,4,5]::integer[],'Srednje','Kao vještac istražujte kontinent, razvijajte špil borbenih karata i lovite čudovišta.',false,ARRAY['Old World – Skellige Expansion','Adventure Pack Expansion','Monster Trail Expansion','Legendary Hunt Expansion']::text[]),
('26','Frostpunk','Kooperativna igra',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Zajednički upravljajte gradom u zaleđenom svijetu, održavajte generator i donosite teške društvene odluke.',true,ARRAY[]::text[]),
('27','Sleeping Gods','Kampanja',ARRAY[1,2,3,4]::integer[],'Srednje','Kao posada parobroda istražujte otvoreni svijet, pratite razgranate priče i zajednički rješavajte izazove.',true,ARRAY[]::text[]),
('28','Everdell','Strategija',ARRAY[1,2,3,4]::integer[],'Srednje','Gradite šumski grad od karata stanovnika i građevina te raspoređujte radnike kroz godišnja doba.',false,ARRAY[]::text[]),
('29','Hegemony','Ekonomska strategija',ARRAY[2,3,4]::integer[],'Zahtjevno','Društvene klase i država nadmeću se i pregovaraju o zakonima, radu, porezima i javnim uslugama.',true,ARRAY[]::text[]),
('30','Twilight Imperium: Fourth Edition','Svemirska strategija',ARRAY[3,4,5,6]::integer[],'Zahtjevno','Istražujte galaksiju, trgujte, pregovarajte i ratujte kako biste ostvarili ciljeve svoje frakcije.',false,ARRAY[]::text[]),
('31','Castles of Burgundy','Strategija',ARRAY[2,3,4]::integer[],'Srednje','Razvijajte kneževinu postavljanjem pločica i pretvarajte rezultate kockica u učinkovite kombinacije akcija.',true,ARRAY[]::text[]),
('32','Spirit Island','Kooperativna igra',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Kao otočni duhovi usklađujte moći i zajedno branite otok od kolonizatora.',false,ARRAY[]::text[]),
('33','Darkest Doom','Avantura',ARRAY[1,2,3,4]::integer[],'Zahtjevno','Mračna fantasy strategija s RPG elementima u kojoj istražujete Betel, razvijate čuvare i suočavate se sa sukobima i odlukama.',true,ARRAY[]::text[])
on conflict (id) do nothing;
insert into public.events (id,title,description,event_date,event_time,location,contact) values
('twilight-imperium-2026-11-21','Twilight Imperium: Fourth Edition','Pridruži nam se na partiji četvrtog izdanja Twilight Imperiuma.','2026-11-21','14:00','Put malog Balana 6, 21000 Trogir','gordan.belas@gmail.com')
on conflict (id) do nothing;
-- VAŽNO: kreiraj korisnika putem Supabase Dashboard > Authentication > Users.
-- Zatim Dashboard > SQL Editor i izvrši ovaj upit sa svojim stvarnim Auth user UUID:
-- update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data,'{}'::jsonb) || '{"role":"admin"}'::jsonb where id = 'TVOJ-USER-UUID';
