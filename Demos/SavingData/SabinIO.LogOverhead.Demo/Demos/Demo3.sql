USE [SabinIO.LogOverhead.Demo]
GO

truncate table LogOverhead2

SET NOCOUNT ON;
GO

--INSERT Large number of records

--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'SabinIO.LogOverhead.Demo_log' , 2)
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
	select 6
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
--Check Table Size = 392kb
--record values
--log size before = 2 
--log size after = 8
--8mb transaction log for 392kb data inserted





--ensure transaction log is small
USE [SabinIO.LogOverhead.Demo];
DBCC SHRINKFILE (N'SabinIO.LogOverhead.Demo_log' , 2)
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

COMMIT TRANSACTION

select (size * 8)/1024 AS LogSize_MB
from sys.master_files
where database_id = db_id()
and type_desc = 'LOG'

exec sp_spaceused 'LogOverhead2'
/*TO HERE*/

--Check Table Size = 3.141mb
--record values
--log size before = 2 
--log size after = 74
--74mb transaction log for 3mb data inserted