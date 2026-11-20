begin;
-- Test public read and denial of writes as anonymous, authenticated non-admin.
set local role anon;
select count(*) as public_game_count from public.games;
do $$ begin
 begin insert into public.games(id,name,category,players,difficulty,description) values ('_security_test','Test','Test',array[1],'Srednje','Test'); raise exception 'FAIL: anon insert allowed'; exception when insufficient_privilege then null; end;
 begin update public.games set name=name; raise exception 'FAIL: anon update grant exists'; exception when insufficient_privilege then null; end;
 begin delete from public.games where false; raise exception 'FAIL: anon delete grant exists'; exception when insufficient_privilege then null; end;
end $$;
reset role;
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated","app_metadata":{}}',true);
do $$ declare n integer; begin
 begin insert into public.games(id,name,category,players,difficulty,description) values ('_security_test','Test','Test',array[1],'Srednje','Test'); raise exception 'FAIL: non-admin insert allowed'; exception when insufficient_privilege then null; end;
 update public.games set name=name; get diagnostics n=row_count; if n<>0 then raise exception 'FAIL: non-admin updated rows'; end if;
 delete from public.games; get diagnostics n=row_count; if n<>0 then raise exception 'FAIL: non-admin deleted rows'; end if;
end $$;
select set_config('request.jwt.claims','{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated","app_metadata":{"role":"admin"}}',true);
do $$ declare n integer; begin
 insert into public.games(id,name,category,players,difficulty,description) values ('_security_test','Test','Test',array[1],'Srednje','Test');
 update public.games set name='Test updated' where id='_security_test'; get diagnostics n=row_count; if n<>1 then raise exception 'FAIL: admin update'; end if;
 delete from public.games where id='_security_test'; get diagnostics n=row_count; if n<>1 then raise exception 'FAIL: admin delete'; end if;
end $$;
reset role;
set local role anon;
select count(*) from public.events;
do $$ begin
 begin insert into public.events(id,title,event_date,event_time,location) values ('_security_test','Test','2026-11-21','14:00','Test'); raise exception 'FAIL: anon event insert'; exception when insufficient_privilege then null; end;
 begin update public.events set title=title; raise exception 'FAIL: anon event update grant'; exception when insufficient_privilege then null; end;
 begin delete from public.events where false; raise exception 'FAIL: anon event delete grant'; exception when insufficient_privilege then null; end;
end $$;
reset role;
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated","app_metadata":{}}',true);
do $$ declare n integer; begin
 begin insert into public.events(id,title,event_date,event_time,location) values ('_security_test','Test','2026-11-21','14:00','Test'); raise exception 'FAIL: non-admin event insert'; exception when insufficient_privilege then null; end;
 update public.events set title=title; get diagnostics n=row_count; if n<>0 then raise exception 'FAIL: non-admin event update'; end if;
 delete from public.events; get diagnostics n=row_count; if n<>0 then raise exception 'FAIL: non-admin event delete'; end if;
end $$;
select set_config('request.jwt.claims','{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated","app_metadata":{"role":"admin"}}',true);
do $$ declare n integer; begin
 insert into public.events(id,title,event_date,event_time,location) values ('_security_test','Test','2026-11-21','14:00','Test');
 update public.events set title='Updated' where id='_security_test'; get diagnostics n=row_count; if n<>1 then raise exception 'FAIL: admin event update'; end if;
 delete from public.events where id='_security_test'; get diagnostics n=row_count; if n<>1 then raise exception 'FAIL: admin event delete'; end if;
end $$;
reset role;
rollback;
