Društveni krug – admin + Supabase

Datoteke u zipu: javne 4 stranice, admin.html, admin.js, admin.css, games.js, events.js, supabase-config.js, supabase-setup.sql, games.json, README.

Sigurnost: u browseru koristimo samo Supabase Publishable key. Nikad ne stavljaj Secret/service_role key u JS, HTML ili Git. Baza ograničava CRUD na auth user s app_metadata.role = admin; ne koristi user_metadata rolu.

1) Napravi Supabase projekt.
2) SQL Editor > New query: zalijepi i pokreni sav supabase-setup.sql. SQL kreira tablice games/events, čitačima javni SELECT, administratoru CRUD te početne 33 igre, 6 proširenja i Twilight Imperium događaj 21.11.2026. 14:00. Ponovno pokretanje ne briše postojeće redove zbog ON CONFLICT DO NOTHING.
3) Authentication > Users: Add user, unesi svoj email i password (registracija nije otvorena u admin sučelju).
4) Kopiraj UUID tog korisnika. SQL Editor pokreni naredbu iz komentara na kraju supabase-setup.sql, zamjenjujući placeholder stvarnim UUID-em:
update auth.users set raw_app_meta_data = coalesce(raw_app_meta_data,'{}'::jsonb) || '{"role":"admin"}'::jsonb where id = 'USER-UUID';
Potvrdi da je promijenjen 1 red.
5) Settings > API Keys: uzmi Project URL i Publishable key (sb_publishable_...). U supabase-config.js zamijeni PASTE_PROJECT_URL_HERE i PASTE_PUBLISHABLE_KEY_HERE. To su javne vrijednosti; nikad ne kopiraj secret key.
6) Supabase > Authentication > URL Configuration: Site URL postavi na punu adresu weba (uključujući /naziv-repozitorija/). Za ovu prijavu zaporkom ne koriste se e-mail redirectovi. U Authentication postavkama isključi Allow new users to sign up; zadrži Email provider uključenim. Korisnika ručno kreiraj s Auto Confirm User uključenim.
7) Kopiraj sve files ZIP-a u root svog Git repo-a. git add -A; git commit -m "Add secure admin for games and events"; git push. GitHub Pages main / root ostaje isto.
8) Otvori https://GITHUB-USERNAME.github.io/REPO-NAME/admin.html, prijavi se e-mailom i zaporkom. Dodaj/uredi/obriši Igre ili Događaje. Javne stranice čitaju iz Supabase.

Događaj inicijalno unesen iz upita: Twilight Imperium: Fourth Edition, 2026-11-21 14:00, Put malog Balana 6, 21000 Trogir. Vrijeme je Europe/Zagreb; frontend prikazuje vrijeme kako spremljeno.

VAŽNO: uzmi rezervnu kopiju baze prije brisanja. Supabase free projekt se može pauzirati nakon neaktivnosti. Početno admin login email/password napravljen kroz Dashboard; ne dijelji račun.

Ako Supabase tabela insert policy javlja problem ili klijent nema access, nemoj rješavati tako da ukloniš RLS ili izložiš secret key; provjeri SQL i app_metadata role.


KORIŠTENJE
- Igre: naziv, kategorija, broj igrača kao popis (1,2,3,4), težina, opis, proširenja svako u novom retku. Checkbox Pravila još učimo ostaje samo oznaka na kartici.
- Događaji: naziv, datum, vrijeme po lokalnom vremenu u Trogiru, lokacija i opis. Svi spremljeni događaji su javni; nema skica. Popis prikazuje i prošle događaje dok ih administrator ne izbriše.
- Spremanje mijenja bazu. Posjetitelji vide promjenu nakon osvježavanja stranice. Nema potrebe za novim git push za sadržaj.
- games.json je samo početna rezervna kopija iz ovog paketa. Javna stranica nakon migracije NE čita taj file i on se ne ažurira automatski. Aktualne podatke izvezi iz Supabase tablica prije većih promjena.
- Nemoj ponovno pokretati početni SQL za vraćanje brisanih redaka: ON CONFLICT ne mijenja postojeće, ali vraća izbrisane početne igre i događaj.
- Ako zaboraviš zaporku, reset korisnika napravi u Supabase Dashboardu; u ovom paketu nema zasebnog e-mail recovery toka.
- Uloga admin čita se iz potpisanog tokena. Nakon dodjele ili uklanjanja uloge treba obnoviti sesiju; stari token vrijedi do isteka. Pri hitnom ukidanju prava opozovi/isključi račun i sesije putem Supabasea.

PROVJERA PRIJE UPOTREBE
1. Odjavljen provjeri da se igre i događaji javno prikazuju.
2. Prijavljen kao admin dodaj testnu igru i događaj, uredi ih, potvrdi prikaz na javnoj stranici, zatim ih izbriši.
3. Napravi privremenog Auth korisnika bez app_metadata.role admin. Ne smije imati pravo INSERT/UPDATE/DELETE. U adminu će biti odbijen.
4. U Supabase Security Advisoru provjeri da su games i events zaštićeni RLS-om.
5. Priloženi security-check.sql možeš pokrenuti nakon setup SQL-a: provjerava stvarne zabrane INSERT/UPDATE/DELETE za posjetitelja i ne-admina te admin CRUD, u transakciji koja se vraća ROLLBACK-om.

Ograničenja testiranja paketa: konfiguracija tvog Supabase projekta i prijava nisu provjerene uživo. Prije javne upotrebe obavezno odradi navedene testove.
