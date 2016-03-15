USE [SabinIO.Performance.InMemoryOltp]
GO

--in memory object dlls are created and loaded
--expand name column and dlls are named using object_ids
SELECT OBJECT_ID('InMemTable')
SELECT OBJECT_ID('InMemTable2')
SELECT OBJECT_ID('InMemTable3')
SELECT OBJECT_ID('InMemTable4')
SELECT OBJECT_ID('usp_InsertData2')
SELECT OBJECT_ID('usp_InsertData4')
SELECT name, description FROM sys.dm_os_loaded_modules
where description = 'XTP Native DLL'
GO

-- run the following code multiple times
--ignore first run as memory is initialised
SET STATISTICS TIME OFF;
SET NOCOUNT ON;

-- Delete data from all tables to reset the example.
DELETE FROM [dbo].[DiskBasedTable] 
    WHERE [c1]>0
GO
DELETE FROM [dbo].[inMemTable] 
    WHERE [c1]>0
GO
DELETE FROM [dbo].[InMemTable2] 
    WHERE [c1]>0
GO
DELETE FROM [dbo].[InMemTable3] 
    WHERE [c1]>0
GO
DELETE FROM [dbo].[InMemTable4] 
    WHERE [c1]>0
GO


/*

MAIN SCRIPT RUN THE REST OF THIS SCRIPT AT ONCE

*/


-- Declare parameters for the test queries.
DECLARE @i INT = 1;
DECLARE @rowcount INT = 50000;  -- Tuned for Azure A2 VM. For local instance up to 1 million
DECLARE @c NCHAR(48) = N'12345678901234567890123456789012345678';
DECLARE @timems INT;
DECLARE @starttime datetime2 = sysdatetime();

-- Disk-based table queried with interpreted Transact-SQL.
BEGIN TRAN
  WHILE @I <= @rowcount
  BEGIN
    INSERT INTO [dbo].[DiskBasedTable](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
COMMIT

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT CAST(@timems AS VARCHAR(10)) + ' ms (disk-based table with interpreted Transact-SQL).';

-- Memory-optimized table queried with interpreted Transact-SQL.
SET @i = 1;
SET @starttime = sysdatetime();

BEGIN TRAN
  WHILE @i <= @rowcount
    BEGIN
      INSERT INTO [dbo].[InMemTable](c1,c2) VALUES (@i, @c);
      SET @i += 1;
    END
COMMIT

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT CAST(@timems AS VARCHAR(10)) + ' ms (memory-optimized table with interpreted Transact-SQL).';

-- Memory-optimized table with schema only durability queried with interpreted Transact-SQL.
SET @i = 1;
SET @starttime = sysdatetime();

BEGIN TRAN
WHILE @i <= @rowcount
  BEGIN
    INSERT INTO [dbo].[InMemTable3](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
COMMIT

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT CAST(@timems AS VARCHAR(10)) + ' ms (memory-optimized table with schema only durability and interpreted Transact-SQL).';

-- Memory-optimized table queried with a natively-compiled stored procedure.
SET @starttime = sysdatetime();

EXEC usp_InsertData2 @rowcount, @c;

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT CAST(@timems AS VARCHAR(10)) + ' ms (memory-optimized table with natively-compiled stored procedure).';

-- Memory-optimized table with schema only durability queried with a natively-compiled stored procedure.
SET @starttime = sysdatetime();

EXEC usp_InsertData4 @rowcount, @c;

SET @timems = datediff(ms, @starttime, sysdatetime());
SELECT CAST(@timems AS VARCHAR(10)) + ' ms (memory-optimized table with schema only durability and natively-compiled stored procedure).';
/*-- the results should be (from slowest to fastest)
	--DiskBasedTable
	--InMemTable
	--InMemTable2
	--InMemTable3
	--InMemTable4
--end of the insert code block demo*/

--get counts from the tables and restart the instance
SELECT COUNT(*), 'DiskBasedTable' FROM DiskBasedTable
UNION ALL
SELECT COUNT(*), 'InMemTable' FROM InMemTable
UNION ALL
SELECT COUNT(*), 'InMemTable2' FROM InMemTable2
UNION ALL
SELECT COUNT(*), 'InMemTable3' FROM InMemTable3
UNION ALL
SELECT COUNT(*), 'InMemTable4' FROM InMemTable4
--restart sql server

--now rerun the 5 count(*) tables 3 and 4 will now be empty
