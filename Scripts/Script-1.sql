-- verwijder alles wat er nu in staat
drop schema if exists sch_evenement cascade;

--begin opnieuw
create schema if  not exists sch_evenement;



DROP TABLE IF EXISTS sch_evenement.autorisatie_nivo cascade;
CREATE TABLE sch_evenement.autorisatie_nivo (
autorisatie_nivo_id serial PRIMARY KEY NOT NULL,
nivo_omschrijving varchar NULL,
opmerking varchar NULL,
registratie_begin TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
registratie_eind TIMESTAMP(0) WITHOUT TIME ZONE NULL,
registratie_user VARCHAR(50)   
);

COMMENT ON TABLE sch_evenement.autorisatie_nivo 
    IS 'Hier worden de autorisatie niveaus in vast gelegd.';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.autorisatie_nivo_id
    IS 'Primary key van de tabel';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.nivo_omschrijving
    IS 'Omschrijving van het betreffende autorisatie nivo dat bij het nivo_id hoort.';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.opmerking
    IS 'Opmerking over de betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.registratie_begin
    IS 'Datum/tijd van het begin van de registratie van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.registratie_eind
    IS 'Datum/tijd van het eind van de registratie van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_evenement.autorisatie_nivo.registratie_user
    IS 'Username die de insert/update doorgevoerd heeft van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';

INSERT INTO sch_evenement.autorisatie_nivo (autorisatie_nivo_id,nivo_omschrijving,registratie_user)
	VALUES	(1,'Alleen lezen','ADMIN'),
			(2,'Alleen export','ADMIN'),
			(3,'Alleen import','ADMIN'),
			(4,'Wijzigen en lezen','ADMIN'),
			(5,'Invoeren, wijzigen en lezen','ADMIN'),
			(6,'Invoeren, wijzigen, lezen en verwijderen','ADMIN'),
			(7,'Invoeren en lezen','ADMIN'),
			(8,'Verwijderen en lezen','ADMIN'),
			(9,'ADMIN','ADMIN')
;

drop table if exists sch_evenement.stam_lijst;
create table sch_evenement.stam_lijst (
stam_lijst_id serial primary key not null,
naam varchar not null
);

comment on table sch_evenement.stam_lijst
	is 'relaties tabel';
comment on column sch_evenement.stam_lijst.stam_lijst_id
	is 'primary key';
comment on column sch_evenement.stam_lijst.naam
	is 'naam van stam die in het tabel staan';
	
insert into sch_evenement.stam_lijst(naam)
values  ('betalingsmethode'),
		('bankrekening'),
		('rol'),
		('locatie')
;

drop table if exists sch_evenement.stam_item_lijst;
create table sch_evenement.stam_item_lijst (
stam_item_lijst_id serial primary key not null,
stam_lijst_id int not null references sch_evenement.stam_lijst(stam_lijst_id),
stam_item_lijst varchar not null 
);

comment on table sch_evenement.stam_item_lijst
	is 'informatie over alle labeltjes';
comment on column sch_evenement.stam_item_lijst.stam_item_lijst_id
	is 'primary key';
comment on column sch_evenement.stam_item_lijst.stam_lijst_id
	is 'foreign key, laat de id van de stam lijst zien die passen bij welk label';
comment on column sch_evenement.stam_item_lijst.stam_item_lijst
	is 'naam van  het label en wat de label eigenlijk inhoud';

insert into sch_evenement.stam_item_lijst (stam_lijst_id, stam_item_lijst)
values 	('1', 'PIN'),
		('1', 'Contant'),
		('1', 'Bank'),
		('2', 'NL59INGB8965873474'),
		('2', 'NL59INGB2384758548'),
		('2', 'NL59INGB3853875444'),
		('3', 'Beheerder'),
		('3', 'Staff'),
		('3', 'Crew'),
		('3', 'Bezoeker'),
		('3', 'VIP'),
		('3', 'Gastspreker'),
		('4', 'HL15-4.094'),
		('4', 'Aula'),
		('4', 'College zaal 1'),
		('4', 'College zaal 2'),
		('4', 'Collage zaal 3')
;

drop table if exists sch_evenement.relatie;
create table sch_evenement.relatie (
relatie_id serial primary key not null,
rol_id int not null references sch_evenement.stam_item_lijst(stam_item_lijst_id),
autorisatie_nivo_id int not null references sch_evenement.autorisatie_nivo(autorisatie_nivo_id),
voornaam varchar not null,
tussenvoegsel varchar null,
achternaam varchar not null,
telefoonnummer char(10) not null,
email varchar not null
);

comment on table sch_evenement.relatie
	is 'informatie over de verschillende relaties';
comment on column sch_evenement.relatie.rol_id
	is 'foreign key, geeft aan welke rol iets aanspeelt';
comment on column sch_evenement.relatie.autorisatie_nivo_id
	is 'foreign key, geeft aan wat voor autorisatie niveau iets heeft';
comment on column sch_evenement.relatie.voornaam
	is 'voornaam van de bepaalde persoon';
comment on column sch_evenement.relatie.tussenvoegsel
	is 'tussenvoegsel van de bepaalde persoon';
comment on column sch_evenement.relatie.achternaam 
	is 'achternaam van de bepaalde persoon';
comment on column sch_evenement.relatie.telefoonnummer
	is 'telefoonnummer van het bepaalde persoon';
comment on column sch_evenement.relatie.email
	is 'emailadres van het bepaalde persoon';

insert into sch_evenement.relatie (rol_id, autorisatie_nivo_id, voornaam, tussenvoegsel, achternaam, telefoonnummer, email)
values  ('7', '9', 'admin', '', 'admin', '0611111111', 'admin@info.nl'),
		('7', '9', 'Hugo', '', 'Jannink', '0643134082', 'hugo.jannink@student.hu.nl'),
		('12', '1', 'Bill', '', 'Gates', '0646543284', 'Bill.Gates@hotmail.com')
;

drop table if exists sch_evenement.gebruiker cascade;
create table sch_evenement.gebruiker (
gebruiker_id serial primary key not null,
autorisatie_nivo_id smallint not null references sch_evenement.autorisatie_nivo(autorisatie_nivo_id),
voornaam varchar not null,
tussenvoegsel varchar null,
achternaam varchar not null,
telefoonnummer char(10) not null,
email varchar not null,
ww varchar not null
);

comment on table sch_evenement.gebruiker
	is 'een tabel over alle gebruikers en basis informatie over hun';
comment on column sch_evenement.gebruiker.gebruiker_id
	is 'primary key van dit tabel';
comment on column sch_evenement.gebruiker.autorisatie_nivo_id
    is 'Foreign key, Autorisatie nivo van de registratie van een specifieke instantie van de geadministreerde gegevens van een gebruiker.';
comment on column sch_evenement.gebruiker.voornaam
	is 'voornaam van de betreffende gebruiker';
comment on column sch_evenement.gebruiker.tussenvoegsel
	is 'tussenvoegsel van de betreffende gebruiker';
comment on column sch_evenement.gebruiker.achternaam
	is 'achternaam van de betreffende gebruiker';
comment on column sch_evenement.gebruiker.telefoonnummer
	is 'telefoonnummer van de betreffende gebruiker';
comment on column sch_evenement.gebruiker.email
	is 'email-adres van de betreffende gebruiker';
comment on column sch_evenement.gebruiker.ww
	is 'wachtwoord van de betreffende gebruiker';

insert into sch_evenement.gebruiker(autorisatie_nivo_id, voornaam, tussenvoegsel, achternaam, telefoonnummer, email, ww)
values (9, 'Hugo', '', 'Jannink', '0643134082', 'Hugo.jannink@student.hu.nl', 'WelkomHUGO'),
	   (1, 'Bert', '', 'Heesakkers', '0612345678', 'Bert.Heesakkers@hu.nl', 'HUWelkom'),
	   (1, 'Bill', '', 'Gates', '0646543284', 'Bill.Gates@hotmail.com', 'WelkomBILL')   
;
   
drop table if exists sch_evenement.evenement cascade;
create table sch_evenement.evenement (
evenement_id serial primary key not null,
gebruiker_id int not null  references sch_evenement.gebruiker(gebruiker_id),
naam varchar not null,
beschrijving text not null,
begin_datum Timestamp(0) without time zone not null default current_timestamp,
eind_datum Timestamp(0) without time zone not null default current_timestamp
);

insert into sch_evenement.evenement( gebruiker_id, naam, beschrijving, begin_datum, eind_datum)
values ('1', 'admin','dit is een admin test', '17/02/2020', '21/02/2020 00:17:00'),
	   ('2', 'Tech convention', 'een convention over allerlei nieuwe en recente techs die worden gebruikt en zijn uitgevonden', '12/03/2020 00:12:00', '12/03/2020 00:17:00')
;

comment on table sch_evenement.evenement
	is 'geef overzicht over alle evenementen';
comment on column sch_evenement.evenement.evenement_id
	is 'het id van alle evenementen die worden ingepland en de primary key van het tabel';
comment on column sch_evenement.evenement.gebruiker_id
	is 'foreign key, laat zien wie er allemaal voor een evenement hebben ingeschreven';
comment on column sch_evenement.evenement.naam
	is 'de naam van het evenement';
comment on column sch_evenement.evenement.beschrijving
	is 'de beschrijving van het evenement';
comment on column sch_evenement.evenement.begin_datum
	is 'de begin datum van dat het evenement begint';
comment on column sch_evenement.evenement.eind_datum
	is 'de eind datum van dat het evenement eindigt';

drop table if exists sch_evenement.timeline cascade;
create table sch_evenement.timeline (
timeline_id serial primary key not null,
evenement_id int not null references sch_evenement.evenement(evenement_id),
gebruiker_id int null references sch_evenement.gebruiker(gebruiker_id),
begin_datum Timestamp(0) without time zone not null default current_timestamp,
eind_datum Timestamp(0) without time zone not null default current_timestamp
); 

comment on table sch_evenement.timeline
	is 'geef basis overzicht over wat er allemaal in de timeline staat';
comment on column sch_evenement.timeline.timeline_id
	is 'primary key van dit tabel';
comment on column sch_evenement.timeline.evenement_id
	is 'foreign key die dit tabel met sch_evenement.evenement verbindt';
comment on column sch_evenement.timeline.gebruiker_id
	is 'foreign key die dit tabel met sch_evenement.gebruiker verbindt';
comment on column sch_evenement.timeline.begin_datum
	is 'begin datum van een evenement/gastspreker';
comment on column sch_evenement.timeline.eind_datum
	is 'eind datum van een evenement/gastspreker';

insert into sch_evenement.timeline(evenement_id, gebruiker_id, begin_datum, eind_datum)
values ('1', '1', '19/02/2020', '20/02/2020');


drop table if exists sch_evenement.betalingsmethode cascade;
create table sch_evenement.betalingsmethode (
betalingsmethode_id serial primary key not null,
beschrijving varchar not null
);

insert into sch_evenement.betalingsmethode(betalingsmethode_id, beschrijving)
values  (1, 'Pin'),
		(2, 'Contant'),
		(3, 'Bank')
;

drop table if exists sch_evenement.bankrekening cascade;
create table sch_evenement.bankrekening (
bankrekening_id serial primary key not null,
beschrijving varchar not null
);

insert into sch_evenement.bankrekening(bankrekening_id, beschrijving)
values (1, 'NL59INGB8965873474'),
	   (2, 'NL59INGB2384758548'),
	   (3, 'NL59INGB3853875444')
;

drop table if exists sch_evenement.betaling cascade;
create table sch_evenement.betaling (
betaling_id serial primary key not null,
evenement_id int not null references sch_evenement.evenement(evenement_id) default 1,
betalingsmethode_id int not null references sch_evenement.betalingsmethode(betalingsmethode_id) default 1,
bankrekening_id int not null references sch_evenement.bankrekening(bankrekening_id) default 1,
gebruiker_id int not null references sch_evenement.gebruiker(gebruiker_id) default 1,
relatie_id int not null references sch_evenement.relatie(relatie_id) default 1,
naam varchar not null,
beschrijving text not null,
bankrekening varchar not null,
datum timestamp(0) without time zone not null default current_timestamp,
kost money not null
);

comment on table sch_evenement.betaling
	is 'informatie over betalingen en wie betaald heeft';
comment on column sch_evenement.betaling.betaling_id
	is 'primary key van dit tabel';
comment on column sch_evenement.betaling.evenement_id
	is 'foreign key, laat zien voor welk/onderdeel evenement betaald is';
comment on column sch_evenement.betaling.betalingsmethode_id
	is 'foreign key, laat zien op welke manier de klant heeft betaald';
comment on column sch_evenement.betaling.bankrekening_id
	is 'foreign key, verteld naar wlek bankrekening het geld wordt gestuur';
comment on column sch_evenement.betaling.gebruiker_id
	is 'foreign key die dit tabel met sch_evenement.gebruiker verbindt';
comment on column sch_evenement.betaling.naam
	is 'merk naam van de betreffende betalling';
comment on column sch_evenement.betaling.beschrijving
	is 'beschrijvin van de betreffende betalling';
comment on column sch_evenement.betaling.bankrekening
	is 'het IBAN nummer van de betaler';
comment on column sch_evenement.betaling.datum
	is 'dag dat de betaling is gedaan';
comment on column sch_evenement.betaling.kost
	is 'bedrag dat betaald is of nog moet worden betaald';

insert into sch_evenement.betaling(evenement_id, betalingsmethode_id, bankrekening_id, gebruiker_id, naam, beschrijving, bankrekening, datum, kost)
values ('1', 2, 1, '1', 'AI convention', 'een convention over allemaal AI dingen', 'NL59INGB7135974575', '20/02/2020 00:08:19', '7,50'),
	   ('2', 2, 2, '2', 'Tech convention', 'een convention over allerlei nieuwe en recente techs die worden gebruikt en zijn uitgevonden', 'NL59INGB2384758548', '02/03/2020 00:08:45', '-150,00')
;


