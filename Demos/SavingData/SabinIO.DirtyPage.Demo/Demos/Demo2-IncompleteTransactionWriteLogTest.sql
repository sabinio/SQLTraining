USE [SabinIO.dirtyPage.Demo]
GO

TRUNCATE TABLE IncompleteTransactionWriteLogTest
GO

/*EXECUTE STATEMENT FROM HERE*/
BEGIN TRANSACTION
--Insert A Record into the table
insert into IncompleteTransactionWriteLogTest
Select 'Incomplete Transaction'

--Ensure written to disk
Checkpoint

--Check value 
select * from IncompleteTransactionWriteLogTest
/*TO HERE*/




--Using Task manager kill the "sqlservr.exe" process 
--Open the MDF file in HxD (Hex editor) (download from http://mh-nexus.de/en/hxd/)
--Search for DirtyPageTran
--Transaction not committed but in data file?
/*
$file = invoke-sqlcmd -Query "select physical_name from sys.master_files where database_id = db_id('SabinIO.dirtyPage.Demo') and type_desc = 'Rows'"
Get-CimInstance -class win32_service | Where-Object name -eq 'mssqlserver' |%{stop-process $_.processId -Force}
gc $file.physical_name -Force | Where-Object {$_ -match "Incomplete Transaction"}
start-service mssqlserver
*/

--Start the SQL Service

--Now check what is stored in the database
USE [SabinIO.dirtyPage.Demo]
GO
select * from IncompleteTransactionWriteLogTest
GO
--Check the SQL Server Log to see what happened on Startup
declare @table table (LogDate datetime, ProcessINfo varchar(20), ErrorText nvarchar(max))
insert into @table EXEC sys.xp_readerrorlog 
select * from @table where ErrorText like '%dirty%'
 
--Starting up database 'SabinIO.DirtyPages.Demo'.
--1 transactions rolled back in database 'SabinIO.DirtyPages.Demo'
--Recovery is writing a checkpoint in database 'SabinIO.DirtyPages.Demo'
--Recovery is complete.
