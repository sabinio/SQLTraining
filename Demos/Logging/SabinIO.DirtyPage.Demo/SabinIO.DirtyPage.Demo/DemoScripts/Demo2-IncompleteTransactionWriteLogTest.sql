use [SabinIO.dirtyPage.Demo]
go


/*EXECUTE STATEMENT FROM HERE*/
BEGIN TRANSACTION
--Insert A Record into the table
insert into IncompleteTransactionWriteLogTest
Select 'DirtyPageTran'

--Ensure written to disk
Checkpoint

--Check value 
select * from IncompleteTransactionWriteLogTest
/*TO HERE*/



--Using Task manager kill the "sqlservr.exe" process 
--Open the MDF file in HxD (Hex editor) (download from http://mh-nexus.de/en/hxd/)
--Search for DirtyPageTran
--Transaction not committed but in data file?


--Start the SQL Service

--Now check what is stored in the database
select * from IncompleteTransactionWriteLogTest


--Check the SQL Server Log to see what happened on Startup
EXEC sys.xp_readerrorlog 

--Starting up database 'SabinIO.DirtyPages.Demo'.
--1 transactions rolled back in database 'SabinIO.DirtyPages.Demo'
--Recovery is writing a checkpoint in database 'SabinIO.DirtyPages.Demo'
--Recovery is complete.
