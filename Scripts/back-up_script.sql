select * into sch_evenement.back_up
from public.events_event ee 
;

update sch_evenement.back_up bp
set public.events_event ee = bp