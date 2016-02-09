USE [SabinIO.LogOverhead.Demo]
GO

SET NOCOUNT ON;
GO



--UPDATE Large number of records

--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'SabinIO.LogOverhead.Demo_log' , 2)
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
