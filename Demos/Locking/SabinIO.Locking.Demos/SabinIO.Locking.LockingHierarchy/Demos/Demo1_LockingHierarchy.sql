USE [SabinIO.Locking.LockingHierarchy]
GO
--01
--Execute the transaction (including the commmit)
begin transaction
insert into Demo1_LockingHierarchy
select 0,'insert'

select * from sys.dm_tran_locks
where request_session_id = @@SPID

commit transaction
GO
/*
We have a 
Shared lock on the database
Intent Exclusive lock on the Object (Table)
Intent Exclusive lock on the Page
Exclusive lock on the row being inserted (RID)

*/
--02
--Where resource_type = OBJECT, copy resource_associated_entity_id into the query below
select * from sys.objects where object_id in (/*insert here*/)
GO
--03
--Where resource_type = PAGE/RID, copy resource_associated_entity_id into the query below
select * from sys.partitions where partition_id in(/*insert here*/)
GO
--run both selects above
--first query shows table we are inserting into
--second query shows the partition number of the table we are inserting into (always 1 if table is not partitioned)



--04
--Change the table from a Heap to a clustered table (add clustered index)
create clustered index ind_Demo1_LockingHierarchy on Demo1_LockingHierarchy
(id)
GO

--05
--Execute the transaction (including the commmit)
begin transaction
insert into Demo1_LockingHierarchy
select 0,'insert'

select * from sys.dm_tran_locks
where request_session_id = @@SPID

commit transaction

/*
We have a 
Shared lock on the database
Intent Exclusive lock on the Object (Table)
Intent Exclusive lock on the Page
Exclusive lock on the row being inserted (KEY)

*/


