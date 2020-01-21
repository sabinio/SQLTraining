USE [SabinIO.LogOverhead.Demo]
GO

truncate table LogOverhead
truncate table LogOverhead2

SET NOCOUNT ON;
GO

--INSERT Large number of records

--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'Log_log' , 2)
GO


--Insert 1 record per loop in a transaction (25,000)
--RUN STATEMENTS FROM HERE ~30 secs
--Check Table Size first = 0.008mb

exec sp_spaceused 'LogOverhead'

set nocount on
GO
select (size * 8)/1024 AS LogSize_MB
from sys.master_files mf
where database_id = db_id()
and type_desc = 'LOG'

BEGIN TRANSACTION
declare @id int = 0
while @id <= 100000
begin
	insert into LogOverhead
	select @id
	set @id = @id + 1
end
COMMIT TRANSACTION

select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG';


exec sp_spaceused 'LogOverhead'

GO
/*TO HERE*/
--Check Table Size = 1352KB
--record values
--log size before ~ 2 
--log size after ~ 65
--63Mb transaction log for 1.352 MB data inserted





--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'Log_log' , 2)
GO



--Insert 100,000 records in a transaction
--RUN STATEMENTS FROM HERE ~6 secs
--Check Table Size first = 0.000mb
set nocount on
GO
select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

BEGIN TRANSACTION

	insert into LogOverhead2 (ID)
	select ID from LogOverhead


select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid

COMMIT TRANSACTION

select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

exec sp_spaceused 'LogOverhead2'
/*TO HERE*/

--Check Table Size = 1.288 mb
--record values
--log size before = 2 
--log size after = 67
--67mb transaction log for 1.2mb data inserted