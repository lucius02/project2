drop schema if exists sch_kennis cascade;

create schema if not exists sch_kennis;

drop table if exists sch_kennis.what cascade;
create table sch_kennis.what (
what_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.what
	is 'een tabel voor alle wat teksten';
comment on column sch_kennis.what.what_id
	is 'primary key en id van alle wat teksten';
comment on column sch_kennis.what.beschrijving
	is 'de teksten van wat dat op het kenniskaart stond';
	
drop table if exists sch_kennis.who cascade;
create table sch_kennis.who (
who_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.who
	is 'een tabel voor alle makers van de kenniskaarten';
comment on column sch_kennis.who.who_id
	is 'primary key en id van alle namen van de makers van de kenniskaarten';
comment on column sch_kennis.who.beschrijving
	is 'alle namen van makers';
	
drop table if exists sch_kennis.why cascade;
create table sch_kennis.why (
why_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.why
	is 'een tabel met alle redenen waarom de makers een kenniskaart maken';
comment on column sch_kennis.why.why_id
	is 'primary key en id van alle redenen';
comment on column sch_kennis.why.beschrijving
	is 'alle redenen';
	
drop table if exists sch_kennis.niveau cascade;
create table sch_kennis.niveau (
niveau_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.niveau
	is 'alle niveaus voor de filter';
comment on column sch_kennis.niveau.niveau_id
	is 'primary key en id van alle niveaus';
comment on column sch_kennis.niveau.beschrijving
	is 'alle niveaus';
	
drop table if exists sch_kennis.onderwerp cascade;
create table sch_kennis.onderwerp (
onderwerp_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.onderwerp
	is 'een tabel voor de filter over alle onderwerpen';
comment on column sch_kennis.onderwerp.onderwerp_id
	is 'primary key en id voor alle onderwerpen';
comment on column sch_kennis.onderwerp.beschrijving
	is 'alle onderwerpen';
	
drop table if exists sch_kennis.rol cascade;
create table sch_kennis.rol (
rol_id serial primary key not null,
beschrijving varchar not null
);

comment on table sch_kennis.rol
	is 'een tabel voor alle rollen';
comment on column sch_kennis.rol.rol_id
	is 'primary key en id voor alle rollen in de filter';
comment on column sch_kennis.rol.beschrijving
	is 'alle rollen';

drop table if exists sch_kennis.filter cascade;
create table sch_kennis.filter (
filter_id serial primary key not null,
niveau_id int not null references sch_kennis.niveau(niveau_id),
onderwerp_id int not null references sch_kennis.onderwerp(onderwerp_id),
rol_id int not null references sch_kennis.rol(rol_id)
);

comment on table sch_kennis.filter
	is 'een tabel voor de filter';
comment on column sch_kennis.filter.filter_id
	is 'primary key en id van alle filters';
comment on column sch_kennis.filter.niveau_id
	is 'foreign key en id van alle niveaus';
comment on column sch_kennis.filter.onderwerp_id
	is 'foreign key en id van alle onderwerpen';
comment on column sch_kennis.filter.rol_id
	is 'foreign key en id van alle rollen';

drop table if exists sch_kennis.kenniskaart cascade;
create table sch_kennis.kenniskaart (
kenniskaart_id serial primary key not null,
title varchar not null,
what_id int not null references sch_kennis.what(what_id),
who_id int not null references sch_kennis.who(who_id),
why_id int not null references sch_kennis.why(why_id),
filter_id int not null references sch_kennis.filter(filter_id)
);

comment on table sch_kennis.kenniskaart
	is 'een tabel voor alle data van kenniskaarten';
comment on column sch_kennis.kenniskaart.kenniskaart_id 
	is 'een column en primary key voor het tabel kenniskaart';
comment on column sch_kennis.kenniskaart.title 
	is 'de titel van het kenniskaart';
comment on column sch_kennis.kenniskaart.what_id
	is 'het id en foreign key voor wat';
comment on column sch_kennis.kenniskaart.who_id
	is 'het id en foreign key voor wie';
comment on column sch_kennis.kenniskaart.why_id
	is 'het id en foreign key voor waarom';
comment on column sch_kennis.kenniskaart.filter_id
	is 'het id en foreign key voor de filter';
	
