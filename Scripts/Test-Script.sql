-- verwijder alles wat er nu in staat
drop schema if exists sch_test cascade;

--begin opnieuw
create schema if  not exists sch_test;

drop table if exists sch_test.stam_lijst;
create table sch_test.stam_lijst (
stam_lijst_id serial primary key not null,
naam varchar not null
);

comment on table sch_test.stam_lijst
	is 'relaties tabel';
comment on column sch_test.stam_lijst.stam_lijst_id
	is 'primary key';
comment on column sch_test.stam_lijst.naam
	is 'naam van stam die in het tabel staan';
	
insert into sch_test.stam_lijst(naam)
values  ('betalingsmethode'),
		('bankrekening'),
		('rol'),
		('locatie')
;

drop table if exists sch_test.stam_item_lijst;
create table sch_test.stam_item_lijst (
stam_item_lijst_id serial primary key not null,
stam_lijst_id int not null references sch_test.stam_lijst(stam_lijst_id),
stam_item_lijst varchar not null 
);

comment on table sch_test.stam_item_lijst
	is 'informatie over alle items';
comment on column sch_test.stam_item_lijst.stam_item_lijst_id
	is 'primary key';
comment on column sch_test.stam_item_lijst.stam_lijst_id
	is 'foreign key, laat de id van de stam lijst zien die passen bij welk label';
comment on column sch_test.stam_item_lijst.stam_item_lijst
	is 'naam van  het label en wat de label eigenlijk inhoud';

insert into sch_test.stam_item_lijst (stam_lijst_id, stam_item_lijst)
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

drop table if exists sch_test.test;
create table sch_test.test (
test_id serial primary key not null,
betaalwijze_id int not null references sch_test.stam_item_lijst(stam_item_lijst_id),
naam varchar not null,
kost money not null
);

comment on table sch_test.test 
	is 'een test tabel die de relatie tussen de test en stam_item_lijst tabellen laat zien.';
comment on column sch_test.test.test_id
	is 'id van de item';
comment on column sch_test.test.betaalwijze_id
	is 'foreign key, een test of deze manier beter werkt';
comment on column sch_test.test.naam
	is 'naam van de betaling';
comment on column sch_test.test.kost
	is 'de bedrag dat betaald word/moet worden betaald';

insert into sch_test.test(betaalwijze_id, naam, kost)
values  ('2', 'verjaardag', '50,00'),
		('1', 'boodschappen', '-10,00')
;

create trigger sch_test.updatetrigger1
	on test
	after update 
	as 
	begin
		
	end