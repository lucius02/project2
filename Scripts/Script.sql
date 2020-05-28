-- verwijder alles wat er nu in staat
drop schema if exists main cascade;

--begin opnieuw
create schema if not exists main;

-- verwijder tabel
drop table if exists main.vacature cascade;
create table main.vacature (
vacature_id serial primary key not null,
naam varchar not null,
job varchar not null,
locatie varchar not null,
salaris money not null,
opleiding varchar not null,
taal varchar not null,
com_taal varchar not null
);

COMMENT ON TABLE main.vacature
    IS 'Hier worden vacature in vast gelegd.';
COMMENT ON COLUMN main.vacature.vacature_id
    IS 'Primary key van de tabel';
comment on column main.vacature.naam
	is 'naam van de vacature';
comment on column main.vacature.job
	is 'welke rol je krijgt als je soliciteert voor die vacature';
comment on column main.vacature.locatie
	is 'locatie van de baan';
comment on column main.vacature.salaris
	is 'het hoeveelheid salaris dat je krijgt';
comment on column main.vacature.opleiding
	is 'welke opleiding je minstens hebt gedaan om in aanraaking te komen om aangenomen te worden';
comment on column main.vacature.taal
	is 'welke talen er vereist van je worden die je moet kennen';
comment on column main.vacature.com_taal
	is 'welke computer taal er verwacht van je wordt';
	
insert into main.vacature(naam, job, locatie, salaris, opleiding, taal, com_taal)
values ('test', '25-05-2020', 'IJsselstein', '3000,00', 'HBO', 'Nederlands, Engels', 'python')
;

drop table if exists main.zoekpagina;
create table main.zoekpagina (
zoekpagina_id serial primary key not null,
zoek_url varchar not null,
onderwerp varchar not null
);

insert into main.zoekpagina(zoek_url, onderwerp)
values ('https://www.indeed.nl/python', 'python'),
	   ('https://www.indeed.nl/mysql', 'mysql')
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








