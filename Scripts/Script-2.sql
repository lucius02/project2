drop schema if exists sch_kennis cascade;

create schema if not exists sch_kennis;

drop table if exists sch_kennis.kenniskaart cascade;
create table sch_kennis.kenniskaart (
kenniskaart_id serial primary key not null,
title varchar not null,
wat varchar not null,
wie varchar not null,
hoe varchar not null,
waarom varchar not null,
niveau varchar not null,
rol varchar not null,
onderwerp varchar not null,
bronnen varchar not null
);

comment on table sch_kennis.kenniskaart
	is 'een tabel voor alle data van kenniskaarten';
comment on column sch_kennis.kenniskaart.kenniskaart_id 
	is 'een column en primary key voor het tabel kenniskaart';
comment on column sch_kennis.kenniskaart.title 
	is 'de titel van het kenniskaart';
comment on column sch_kennis.kenniskaart.wat
	is 'waar de kenniskaart over gaat';
comment on column sch_kennis.kenniskaart.wie
	is 'wie de kennis kaart heeft gemaakt';
comment on column sch_kennis.kenniskaart.hoe
	is '';
comment on column sch_kennis.kenniskaart.waarom
	is 'waarom de kenniskaart is gemaakt';
comment on column sch_kennis.kenniskaart.niveau
	is 'het niveau van de kenniskaart';
comment on column sch_kennis.kenniskaart.rol
	is 'voor wie is de kenniskaart bedoeld';
comment on column sch_kennis.kenniskaart.onderwerp
	is 'het onderwerp van de kenniskaart';
comment on column sch_kennis.kenniskaart.bronnen
	is 'de bronnen van de kenniskaart';