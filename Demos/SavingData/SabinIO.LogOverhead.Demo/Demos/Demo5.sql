USE [SabinIO.LogOverhead.Demo]
GO

SET NOCOUNT ON;
GO




--DELETE / TRUNCATE Large number of records

--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'SabinIO.LogOverhead.Demo_log' , 2)
GO



--delete 1,000,000 records in a transaction
--RUN STATEMENTS FROM HERE ~7 secs
set nocount on
GO
select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

BEGIN TRANSACTION

	delete from LogOverhead2 

COMMIT TRANSACTION

select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'
/*TO HERE*/
GO

--record values
--log size before = 2 
--log size after = 109
--109mb transaction log to delete 3mb data 




--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'SabinIO.LogOverhead.Demo_log' , 2)
GO





--truncate table in a transaction
--RUN STATEMENTS FROM HERE ~0 secs
set nocount on
GO
select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

BEGIN TRANSACTION

	 truncate table LogOverhead 

COMMIT TRANSACTION

select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'
/*TO HERE*/

--record values
--log size before = 2 
--log size after = 2
--0mb transaction log to delete 3mb data 

