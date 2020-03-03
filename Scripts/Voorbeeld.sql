/* Dit is het create script voor de database
 * Pas op: alle data wordt weggegooid
 * Vul het script met enkele data, zodat het makkelijker leest/test met de frontend.
 * Er is ook een script voor de eventuele functies. Deze kan je altijd ongestraft opnieuw draaien, zonder verlies van data.
 */

-- verwijder alles wat er nog staat
DROP SCHEMA IF EXISTS sch_system CASCADE;

-- begin opnieuw
CREATE SCHEMA if not exists sch_system;

--deze is handig als je alleen even onderstaande tabel opnieuw wilt aanmaken ipv alles.
DROP TABLE IF EXISTS sch_system.patch;
CREATE TABLE sch_system.patch (
patch_id serial PRIMARY KEY NOT NULL,
naam VARCHAR NOT NULL,
referentie VARCHAR NULL,
omschrijving VARCHAR NULL,
uitgevoerd TIMESTAMP(0) WITHOUT TIME ZONE NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE sch_system.patch 
    IS 'Geeft overzicht van de patches die op deze database zijn uitgevoerd';
COMMENT ON COLUMN sch_system.patch.patch_id
    IS 'Geeft de unieke id van de patch';
COMMENT ON COLUMN sch_system.patch.naam
    IS 'Geeft de bestandsnaam van de patch';
COMMENT ON COLUMN sch_system.patch.referentie
    IS 'Geeft de referentie naar de issue/email tav de reden van de patch';
COMMENT ON COLUMN sch_system.patch.omschrijving
    IS 'Geeft een korte omschrijving van de reden van de patch';
COMMENT ON COLUMN sch_system.patch.uitgevoerd
    IS 'Geeft het datum&tijdstip van uitvoer van de patch';

-- even een kleine test. copie in unittest
insert into sch_system.patch (naam, referentie, omschrijving) VALUES 
('patch0001 RB-1234 Example Patch.sql','RB-1234','Example Patch')
;

DROP TABLE IF EXISTS sch_system.autorisatie_nivo ;
CREATE TABLE sch_system.autorisatie_nivo (
autorisatie_nivo_id serial PRIMARY KEY NOT NULL,
nivo_omschrijving varchar NULL,
opmerking varchar NULL,
registratie_begin TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
registratie_eind TIMESTAMP(0) WITHOUT TIME ZONE NULL,
registratie_user VARCHAR(50)   
);

COMMENT ON TABLE sch_system.autorisatie_nivo 
    IS 'Hier worden de autorisatie niveaus in vast gelegd.';
COMMENT ON COLUMN sch_system.autorisatie_nivo.autorisatie_nivo_id
    IS 'Primary key van de tabel';
COMMENT ON COLUMN sch_system.autorisatie_nivo.nivo_omschrijving
    IS 'Omschrijving van het betreffende autorisatie nivo dat bij het nivo_id hoort.';
COMMENT ON COLUMN sch_system.autorisatie_nivo.opmerking
    IS 'Opmerking over de betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_system.autorisatie_nivo.registratie_begin
    IS 'Datum/tijd van het begin van de registratie van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_system.autorisatie_nivo.registratie_eind
    IS 'Datum/tijd van het eind van de registratie van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';
COMMENT ON COLUMN sch_system.autorisatie_nivo.registratie_user
    IS 'Username die de insert/update doorgevoerd heeft van een specifieke instantie van de geadministreerde gegevens van het betreffende autorisatie nivo.';

INSERT INTO sch_system.autorisatie_nivo (autorisatie_nivo_id,nivo_omschrijving,registratie_user)
	VALUES	(1,'Alleen lezen','ADMIN'),
			(2,'Alleen export','ADMIN'),
			(3,'Alleen imort','ADMIN'),
			(4,'Wijzigen en lezen','ADMIN'),
			(5,'Invoeren, wijzigen en lezen','ADMIN'),
			(6,'Invoeren, wijzigen, lezen en verwijderen','ADMIN'),
			(7,'Invoeren en lezen','ADMIN'),
			(8,'Verwijderen en lezen','ADMIN'),
			(9,'ADMIN','ADMIN')
;

DROP TABLE IF EXISTS sch_system.sys_user ;
CREATE TABLE sch_system.sys_user (
sys_user_id serial PRIMARY KEY NOT NULL,
autorisatie_nivo_id smallint NOT NULL REFERENCES sch_system.autorisatie_nivo(autorisatie_nivo_id) DEFAULT 1,
username varchar NOT NULL,
voornaam varchar NOT NULL,
tussenvoegsel varchar NULL,
achternaam varchar NOT NULL,
laatst_ingelogd TIMESTAMP(0) WITHOUT TIME ZONE NULL,
opmerking varchar NULL,
registratie_begin TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
registratie_eind TIMESTAMP(0) WITHOUT TIME ZONE NULL,
registratie_user VARCHAR(50)   
);

-- door deze constraints kan er geen dubbele username ontstaan
ALTER TABLE sch_system.sys_user ADD CONSTRAINT unique_username UNIQUE (username) ; 

COMMENT ON TABLE sch_system.sys_user 
    IS 'Hier worden de gebruikers in vast gelegd.';
COMMENT ON COLUMN sch_system.sys_user.sys_user_id
    IS 'Primary key van de gebruiker';
COMMENT ON COLUMN sch_system.sys_user.autorisatie_nivo_id
    IS 'Foreign key, Autorisatie nivo van de registratie van een specifieke instantie van de geadministreerde gegevens van een gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.username
    IS 'Unieke systeemnaam van de betreffende gebruiker. Deze wordt gebruikt in de andere tabellen bij de registratie_user. Dit had ook met de user_id gekund, maar een username heeft net dat beetje betekenis wat het interpreteren wat makkelijker maakt. ';
COMMENT ON COLUMN sch_system.sys_user.voornaam
    IS 'Voornaam van de betreffende gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.tussenvoegsel
    IS 'Tussenvoegsel van de betreffende gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.achternaam
    IS 'Achternaam de betreffende gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.laatst_ingelogd
    IS 'Laatste datum/tijdstip van inlog van de betreffende gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.opmerking
    IS 'Opmerking over de betreffende gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.registratie_begin
    IS 'Datum/tijd van het begin van de registratie van een specifieke instantie van de geadministreerde gegevens van een gebruiker';
COMMENT ON COLUMN sch_system.sys_user.registratie_eind
    IS 'Datum/tijd van het eind van de registratie van een specifieke instantie van de geadministreerde gegevens van een gebruiker.';
COMMENT ON COLUMN sch_system.sys_user.registratie_user
    IS 'Username die de insert/update doorgevoerd heeft van een specifieke instantie van de geadministreerde gegevens van een gebruiker.';

INSERT INTO sch_system.sys_user (username,voornaam,tussenvoegsel,achternaam,registratie_user)
VALUES ('ADMIN','',NULL,'admin','ADMIN');

