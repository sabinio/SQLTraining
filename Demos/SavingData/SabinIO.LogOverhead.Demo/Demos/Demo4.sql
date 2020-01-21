USE [SabinIO.LogOverhead.Demo]
GO

SET NOCOUNT ON;
GO



--UPDATE Large number of records

--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'Log_log' , 2)
GO



--update 1,000,000 records in a transaction
--RUN STATEMENTS FROM HERE ~10 secs
set nocount on
GO
select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

BEGIN TRANSACTION

	update LogOverhead2 
	set ID = 10


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
/*TO HERE*/

--record values
--log size before = 2 
--log size after = 109
--109mb transaction log to update 3mb data 

select count(*) from LogOverhead2
