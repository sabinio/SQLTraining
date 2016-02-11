USE [SabinIO.Recovery.PageRestore]
GO --0

DELETE FROM msdb.dbo.suspect_pages WHERE database_id = DB_ID('SabinIO.Recovery.PageRestore')

ALTER DATABASE [SabinIO.Recovery.PageRestore] SET RECOVERY FULL

TRUNCATE TABLE PR_Sales
GO --1
-- PLEASE MAKE SURE THERE ARE NO BACKUPS FILES IN C:\TEMP BEFORE RUNNING (OR IF YOU WANT TO RERUN)

SET NOCOUNT ON

DECLARE @i INT = 0
WHILE (@i <200)
BEGIN
INSERT INTO PR_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
SET @i = @i + 1;
END
GO --2

SELECT * FROM PR_Sales
GO --3

-- First validate the database
DBCC CHECKDB WITH TABLERESULTS

-- Create a Full Backup
BACKUP DATABASE [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\FullBackup_PageRestore.bak'
GO --4

DECLARE @i INT = 0
WHILE (@i < 200)
BEGIN
-- Insert some more data to make things a little more tricky (ie data has changed since the last full backup)
INSERT INTO PR_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
SET @i = @i + 1;
END
GO --5

SELECT * FROM PR_Sales

GO --6

-- Backup the log (assume this is on a 15 min schedule or similiar)
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore1.trn'
GO --7


-- Corrupt a page
EXEC [PR_CorruptDatabase]
GO --8

-- User Runs this query
SELECT * FROM PR_Sales
GO --9

-- MSDB Keeps a record
SELECT * FROM msdb.dbo.suspect_pages WHERE database_id = DB_ID('SabinIO.Recovery.PageRestore')
GO --10

---- Table can still be inserted to
DECLARE @i INT = 0
WHILE (@i < 10)
BEGIN
INSERT INTO [SabinIO.Recovery.PageRestore]..PR_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
SET @i = @i + 1;
END
GO --11

---- At this point we should 410 records in PR_Sales - Remember this

-- Validate there is an issue
DBCC CHECKDB ('SabinIO.Recovery.PageRestore') WITH TABLERESULTS;
GO--12


USE [Master]
GO
--13
-- First after any failure is to backup the tail of the log
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore_Tail.trn'
GO--14

-- SET THE PAGE ID IN THE NEXT STATEMENT
-- We now go through the latest backup chain to restore the page
RESTORE DATABASE [SabinIO.Recovery.PageRestore] PAGE='1:77' FROM DISK='C:\Temp\FullBackup_PageRestore.bak' 
WITH NORECOVERY
GO--15

-- Notice even though recovery has started the DB is still online for users (Enterprise feature)
SELECT TOP 10 * FROM [SabinIO.Recovery.PageRestore]..PR_Sales
GO
---- Restore the logs
RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore1.trn'
WITH NORECOVERY
GO

RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore_Tail.trn'
WITH NORECOVERY
GO

---- Backup the tail again in case of changes whilst we restored
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore_Tail2.trn'
GO

---- Recover tail 
RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore_Tail2.trn'
WITH RECOVERY
GO


-- Verify fix
USE [SabinIO.Recovery.PageRestore]
GO

SELECT COUNT(*) FROM [SabinIO.Recovery.PageRestore]..PR_Sales AS TotalRows;
GO

DBCC CHECKDB ('SabinIO.Recovery.PageRestore') WITH TABLERESULTS;
GO
