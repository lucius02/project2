-- verwijder alles wat er nu in staat
drop schema if exists main cascade;

--begin opnieuw
create schema if not exists main;

drop table if exists main.zoekpagina;
create table main.zoekpagina (
zoekpagina_id serial primary key not null,
zoek_url varchar not null,
onderwerp varchar not null
);

--truncate main.zoekpagina cascade;

insert into main.zoekpagina(zoek_url, onderwerp)
values ('https://www.indeed.nl/python-vacatures', 'python'),
	   ('https://www.indeed.nl/mysql-vacatures', 'mysql')
;

drop table if exists main.zoekresult;
create table main.zoekresult (
zoekresult_id serial primary key not null,
zoekpagina_id int not null references main.zoekpagina(zoekpagina_id),
pagina_result varchar not null
);

create or replace function main.buildzoekscript()
returns void as $$
begin 
drop table if exists main.zoekscript;
create table main.zoekscript as select coalesce(' curl "'||z.zoek_url||'" -o "%pg_data%\temp\'||z.onderwerp||z.zoekpagina_id||'.txt"','')
from main.zoekpagina z;

copy main.zoekscript to 'C:\live_vacature\_zoekscript.bat';
end;
$$ language plpgsql;


create or replace function main.getdata()
returns void as $$
begin
	--
	insert into main.zoekresult (
	zoekpagina_id,
	pagina_result
	) select z.zoekpagina_id,pg_read_file('.\temp\'||z.onderwerp||z.zoekpagina_id||'.txt')
	from main.zoekpagina z;
	--
	insert into main.zoekitemdata(zoekpagina_id, zoekitem_id, waarde)
	select zoekpagina_id, 1,
	replace (
		substring(
					substring(
								pagina_result,
								position ('pagina 1 van ' in lower(pagina_result))+13,
								100 ),
					1,
					position (' vacatures' in lower(substring( pagina_result, position ('pagina 1 van ' in lower(pagina_result))+13,100 )))-1)
	,'.','')
	from main.zoekresult z
	where pagina_result ~* 'www.indeed.nl';
	--
end;
$$ language plpgsql;

--select main.getdata();

drop table if exists main.zoekitem cascade;
create table main.zoekitem(
zoekitem_id serial primary key not null,
naam varchar not null,
datum timestamp (0) default now()
);

--alter table main.zoekitem alter column datum set default now();


insert into main.zoekitem ( naam) 
values ('aantal vacatures' );

drop table if exists main.zoekitemdata;
create table main.zoekitemdata(
zoekitemdata_id bigserial primary key not null,
zoekpagina_id int not null references main.zoekpagina(zoekpagina_id),
zoekitem_id int not null references main.zoekitem(zoekitem_id),
waarde varchar,
datum timestamp (0) default now()
);

--alter table main.zoekitemdata alter column datum set default now();

select * from main.zoekitemdata ;

create or replace function main.find_zoekitemdata()
returns table(zoek_url varchar, onderwerp varchar, naam varchar, waarde varchar, datum timestamp(0)) as $$
begin
select --*,
zp.zoek_url, zp.onderwerp, zi.naam, zid.waarde, zid.datum 
from main.zoekitemdata zid
inner join main.zoekpagina zp on zid.zoekpagina_id = zp.zoekpagina_id 
inner join main.zoekitem zi on zi.zoekitem_id = zid.zoekitem_id 
order by zp.zoekpagina_id, zi.zoekitem_id, zid.datum 
;
end;
$$ language plpgsql;

--select * from main.find_zoekitemdata;

create or replace function main.find_zoekitem()
returns table(zoekitem_id int, naam varchar) as $$
begin
	return query select --*,
	zi.zoekitem_id, zi.naam 
	from main.zoekitem zi
	order by zi.naam, zi.zoekitem_id
	;
end;
$$ language plpgsql;

-- select * from main.find_zoekitem();

--drop function if exists main.find_zoekpagina;
create or replace function main.find_zoekpagina()
returns table(zoekpagina_id int, zoek_url varchar, onderwerp varchar) as $$
begin
	return query select --*,
	zp.zoekpagina_id, zp.zoek_url, zp.onderwerp  
	from main.zoekpagina zp 
	order by zp.onderwerp 
	;
end;
$$ language plpgsql;

-- select * from main.find_zoekpagina();

--drop function if exists main.upsert_zoekitem();
create or replace function main.upsert_zoekitem(input_zoekitem_id int, input_naam varchar)
returns table(zoekitem_id int, naam varchar) as $$
declare ZoekitemId int;
begin
	if coalesce(input_zoekitem_id,0) =0 then --insert
		insert into main.zoekitem (naam) values (input_naam)
		returning zoekitem.zoekitem_id into ZoekitemId; 
	else --update
		update main.zoekitem set naam = input_naam
		where zoekitem.zoekitem_id = input_zoekitem_id
		returning zoekitem.zoekitem_id into ZoekitemId;
	end if ;
	if ZoekitemId > 0 then
		return query select --*,
		zi.zoekitem_id, zi.naam
		from main.zoekitem zi
		where zi.zoekitem_id = ZoekitemId
		order by zi.naam, zi.zoekitem_id
		;
	else
		raise 'upsert niet gelukt. zoekitem_id = %, naam = %.', input_zoekitem_id, input_naam;
	end if;
end;
$$ language plpgsql;

-- select main.upsert_zoekitem(2,'test_naam2');

--drop function if exists main.upsert_zoekpagina();
create or replace function main.upsert_zoekpagina(input_zoekpagina_id int, input_zoek_url varchar, input_onderwerp varchar)
returns table(zoekpagina_id int, zoek_url varchar, onderwerp varchar) as $$
declare ZoekpaginaId int;
begin
	if coalesce(input_zoekpagina_id,0) =0 then --insert
		insert into main.zoekpagina (zoek_url, onderwerp) values (input_zoek_url, input_onderwerp)
		returning zoekpagina.zoekpagina_id into ZoekpaginaId;
	else --update
		update main.zoekpagina set zoek_url = input_zoek_url, onderwerp = input_onderwerp
		where zoekpagina.zoekpagina_id = input_zoekpagina_id
		returning zoekpagina.zoekpagina_id into ZoekpaginaId;
	end if;
	if 	ZoekpaginaId > 0 then  
		return query select --*,
		zp.zoekpagina_id, zp.zoek_url, zp.onderwerp
		from main.zoekpagina zp
		where zp.zoekpagina_id = ZoekpaginaId
		order by zp.onderwerp 
		;
	else 
		raise 'upsert niet gelukt. zoekpagina_id = %, zoek_url = %, onderwerp = %.', input_zoekpagina_id, input_zoek_url, input_onderwerp;
	end if;
end;
$$ language plpgsql;

-- select main.upsert_zoekpagina(null,'www.nn.nl','cas');
-- select main.upsert_zoekpagina(0,'www.nummmno.nl','ckkoronas');
-- select main.upsert_zoekpagina(7,'www.nuuuuuuuu.nl','ckkoronas');

--truncate main.zoekscript;



































































