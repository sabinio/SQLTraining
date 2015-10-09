USE [SabinIO.Recovery.PageRestore]
GO


SET NOCOUNT ON


INSERT INTO Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
GO 2000

SELECT * FROM Sales
GO

-- First validate the database
DBCC CHECKDB()

-- Create a Full Backup
BACKUP DATABASE [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\FullBackup_PageRestore.bak'
GO

-- Insert some more data to make things a little more tricky (ie data has changed since the last full backup)
INSERT INTO Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
GO 1000

-- Backup the log (assume this is on a 15 min schedule or similiar)
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore1.trn'
GO

-- Corrupt a page
EXEC CorruptDatabase
GO

-- User Runs this query
SELECT * FROM Sales

-- MSDB Keeps a record
SELECT * FROM msdb.dbo.suspect_pages WHERE database_id = DB_ID()

-- Table can still be inserted to
INSERT INTO dbo.Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
GO 10

-- At this point we should 51010 records in sales - Remember this

-- Validate there is an issue
DBCC CHECKDB
GO


USE [Master]
GO

-- First after any failure is to backup the tail of the log
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore_Tail.trn'
GO

-- SET THE PAGE ID IN THE NEXT STATEMENT
-- We now go through the latest backup chain to restore the page
RESTORE DATABASE [SabinIO.Recovery.PageRestore] PAGE='1:489' FROM DISK='C:\Temp\FullBackup_PageRestore.bak' 
WITH NORECOVERY
GO

-- Notice even though recovery has started the DB is still online for users (Enterprise feature)
SELECT TOP 10 * FROM [SabinIO.Recovery.PageRestore]..Sales

-- Restore the logs
RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore1.trn'
WITH NORECOVERY
GO

RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore_Tail.trn'
WITH NORECOVERY
GO

-- Backup the tail again in case of changes whilst we restored
BACKUP LOG [SabinIO.Recovery.PageRestore] TO DISK='C:\Temp\LogBackup_PageRestore_Tail2.trn'
GO

-- Recover tail 
RESTORE DATABASE [SabinIO.Recovery.PageRestore] FROM DISK='C:\Temp\LogBackup_PageRestore_Tail2.trn'
WITH RECOVERY
GO


-- Verify fix
USE [SabinIO.Recovery.PageRestore]
GO

SELECT COUNT(*) FROM dbo.Sales
GO

DBCC CHECKDB()
GO
