drop table if exists public.events_event;
create table public.events_event (
id serial primary key not null,
Title text not null,
Naam text NOT null,
Beschrijving text NOT null,
Begin_datum date NOT null,
Eind_datum date NOT null,
Start_tijd time not null,
Eind_tijd time not null
);

comment on table public.events_event
	is 'tabel over de evenement die worden laten gezien op de website';
comment on column public.events_event.id 
	is 'primary key en foreign key, het id van het evenement';
comment on column public.events_event.title 
	is 'titel van het evenement';
comment on column public.events_event.naam 
	is 'naam van organisator van het evenement';
comment on column public.events_event.beschrijving 
	is 'beschrijving van het evenement';
comment on column public.events_event.begin_datum 
	is 'begin datum van het evenement';
comment on column public.events_event.eind_datum 
	is 'eind datum van het evenement';
