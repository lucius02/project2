drop table if exists sch_evenement.back_up;

select * into sch_evenement.back_up
from public.events_event ee 
;

ALTER TRIGGER trigger_backup_update
   ON sch_evenement.back_up 
   AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;    

    UPDATE back_up 
    SET modified = GETDATE()
       , ModifiedUser = SUSER_NAME()
       , ModifiedHost = HOST_NAME()
    FROM back_up bck 
    INNER JOIN Inserted I ON bck.OrderNo = I.OrderNo and bck.PartNumber = I.PartNumber
    INNER JOIN Deleted D ON bck.OrderNo = D.OrderNo and bck.PartNumber = D.PartNumber                  
    WHERE bck.QtyToRepair <> I.QtyToRepair
    AND D.QtyToRepair <> I.QtyToRepair
END
;