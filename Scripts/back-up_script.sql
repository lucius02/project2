drop table if exists sch_evenement.back_up;

select * into sch_evenement.back_up
from public.events_event ee 
;
-- wilt niet werken --
update
	sch_evenement.back_up
set
	id = ee.id
from 
	sch_evenement.back_up bp 
	inner join events_event ee
	on bp.id = ee.id 
where 
	bp.begin_datum <= bp.eind_datum
	and 
	ee.begin_datum <= ee.begin_datum 
;
