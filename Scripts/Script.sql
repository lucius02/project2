-- verwijder alles wat er nu in staat
drop schema if exists main cascade;

--begin opnieuw
create schema if not exists main;

-- verwijder tabel
drop table if exists main.vacature cascade;
create table main.vacature (
vacature_id serial primary key not null,
naam varchar,
job varchar,
locatie varchar,
salaris money,
opleiding varchar,
taal varchar,
com_taal varchar
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
