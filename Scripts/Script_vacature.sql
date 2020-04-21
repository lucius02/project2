-- verwijder alles wat er nu in staat
drop schema if exists sch_vacature cascade;

--begin opnieuw
create schema if not exists sch_vacature;

-- verwijder tabel
drop table if exists sch_vacature.vacatures cascade;
create table sch_vacature.vacatures (
vacatures_id serial primary key not null,
naam varchar,
datum_ingevoerd timestamp null,
job_title varchar,
job_description text,
company_title varchar,
salary money
);

COMMENT ON TABLE sch_vacature.vacatures
    IS 'Hier worden vacatures in vast gelegd.';
COMMENT ON COLUMN sch_vacature.vacatures.vacatures_id
    IS 'Primary key van de tabel';
comment on column sch_vacature.vacatures.naam
	is 'naam van de vacature';
comment on column sch_vacature.vacatures.datum_ingevoerd
	is 'datum van wanneer de vacature is ingevoerd';
comment on column sch_vacature.vacatures.job_title
	is 'naam van de baan';
comment on column sch_vacature.vacatures.job_description
	is 'beschrijving van de baan';
comment on column sch_vacature.vacatures.company_title
	is 'naam van de company';
comment on column sch_vacature.vacatures.salary
	is 'de hoeveelheid die je bij deze baan wordt betaald';
	
insert into sch_vacature.vacatures(naam, datum_ingevoerd, job_title, job_description, company_title, salary)
values ('test', '21-04-2020', 'Test1', 'Test2Test', 'Test3', '60000')
;