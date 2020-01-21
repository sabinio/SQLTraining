USE [SabinIO.dirtyPage.Demo]
GO

TRUNCATE TABLE WriteLogTest
GO

--Insert A Record into the table
insert into WriteLogTest
Select 'CleanPage'

--Ensure written to disk
Checkpoint

GO

--Check value 
select * from WriteLogTest

GO

--Update value
update WriteLogTest
set StringColumn = 'DirtyPage'

select * from WriteLogTest
GO
/*
--kill the "sqlservr.exe" process 
--Read the MDF file in HxD (Hex editor) (download from http://mh-nexus.de/en/hxd/)
--Search for DirtyPage
--Unable to find?
--Search for CleanPage
--What value is in the Data file (MDF)

$file = invoke-sqlcmd -Query "select physical_name from sys.master_files where database_id = db_id('SabinIO.dirtyPage.Demo') and type_desc = 'Rows'"
Get-CimInstance -class win32_service | Where-Object name -eq 'mssqlserver' |%{stop-process $_.processId -Force}
gc $file.physical_name -Force | Where-Object {$_ -match "DirtyPage"}
gc $file.physical_name -Force | Where-Object {$_ -match "CleanPage"}
start-service mssqlserver

--Start the SQL Service

--Now check what is stored in the database
*/
select * from WriteLogTest
GO
--Check the SQl Server Log to see what happened on Startup
declare @table table (LogDate datetime, ProcessINfo varchar(20), ErrorText nvarchar(max))
insert into @table EXEC sys.xp_readerrorlog 
select * from @table where ErrorText like '%dirty%'

--Starting up database 'SabinIO.DirtyPages.Demo'.
--1 transactions rolled forward in database 'SabinIO.DirtyPages.Demo'
--0 transactions rolled back in database 'SabinIO.DirtyPages.Demo'
--Recovery is writing a checkpoint in database 'SabinIO.DirtyPages.Demo'
--Recovery is complete.

