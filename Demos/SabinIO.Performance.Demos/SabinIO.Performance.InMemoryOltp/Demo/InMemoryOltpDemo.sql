--add a filegroup that is marked for containing IMOLTP
ALTER DATABASE [SabinIO.Performance.InMemoryOltp]
 ADD FILEGROUP [FG_SabinIOPerformanceInMemoryOltp_IMOltp_Data] 
CONTAINS MEMORY_OPTIMIZED_DATA
GO

--add filestream folders to filegroup created above
DECLARE @FileLocation NVARCHAR (256)
SELECT @FileLocation = LEFT(physical_name, LEN(physical_name)- LEN(REVERSE(SUBSTRING(REVERSE(physical_name), 1, CHARINDEX('\', REVERSE(physical_name))-1)))) FROM [SabinIO.Performance.InMemoryOltp].[sys].[database_files]
WHERE type = 0

DECLARE @SQL NVARCHAR(MAX)

SET @SQL = 
'ALTER DATABASE [SabinIO.Performance.InMemoryOltp] ADD FILE 
( 
NAME = [SabinIOPerformanceInMemoryOltp_IMOltp_Folder_1], 
FILENAME = '''+@FileLocation+'SabinIOPerformanceInMemoryOltp_IMOltp_Folder_1''
) TO FILEGROUP [FG_SabinIOPerformanceInMemoryOltp_IMOltp_Data]'
EXEC (@SQL)

SET @SQL = 
'ALTER DATABASE [SabinIO.Performance.InMemoryOltp] ADD FILE 
(
NAME = [SabinIOPerformanceInMemoryOltp_IMOltp_Folder_2], 
FILENAME = '''+@FileLocation+'SabinIOPerformanceInMemoryOltp_IMOltp_Folder_2''
) TO FILEGROUP [FG_SabinIOPerformanceInMemoryOltp_IMOltp_Data]'
EXEC (@SQL)
GO

USE [SabinIO.Performance.InMemoryOltp]
GO

-- If the tables or stored procedure already exist, drop them to start clean.

IF EXISTS (SELECT NAME FROM sys.objects  WHERE NAME = 'usp_InsertData2')
   DROP PROCEDURE [dbo].[usp_InsertData2]
GO

IF EXISTS (SELECT NAME FROM sys.objects  WHERE NAME = 'usp_InsertData4')
   DROP PROCEDURE [dbo].[usp_InsertData4]
GO

IF EXISTS (SELECT NAME FROM sys.objects WHERE NAME = 'DiskBasedTable')
   DROP TABLE [dbo].[DiskBasedTable]
GO

IF EXISTS (SELECT NAME FROM sys.objects WHERE NAME = 'InMemTable')
   DROP TABLE [dbo].[InMemTable]
GO

IF EXISTS (SELECT NAME FROM sys.objects  WHERE NAME = 'InMemTable2')
   DROP TABLE [dbo].[InMemTable2]
GO

IF EXISTS (SELECT NAME FROM sys.objects  WHERE NAME = 'InMemTable3')
   DROP TABLE [dbo].[InMemTable3]
GO

IF EXISTS (SELECT NAME FROM sys.objects  WHERE NAME = 'InMemTable4')
   DROP TABLE [dbo].[InMemTable4]
GO

-- Create a traditional disk-based table.
CREATE TABLE [dbo].[DiskBasedTable] (
  c1 INT NOT NULL PRIMARY KEY,
  c2 NCHAR(48) NOT NULL
)
GO

-- Create a memory-optimized table.
--hash index
--secondary indexes are declared inline (none on this table now)
-- ball park for bucket count, it should be *2 the expected number of unique values
--bucket count determines the amount of memory consumed by table 
--need to specify bin2 collation on string columns or command will fail
CREATE TABLE [dbo].[InMemTable] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA);
GO

-- Create a 2nd memory-optimized table.
--we will insert into this table using a natively compiled sproc
CREATE TABLE [dbo].[InMemTable2] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_AND_DATA);
GO

-- Create a 3nd memory-optimized table.
--This tables durability is schema only, so data is not logged
--insert into this table using interpreted T-SQL
CREATE TABLE [dbo].[InMemTable3] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_ONLY);
GO

-- Create a 4th memory-optimized table.
--This tables durability is schema only, so data is not logged
--we will insert into this table using a natively compiled sproc
CREATE TABLE [dbo].[InMemTable4] (
  c1 INT NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),
  c2 NCHAR(48) NOT NULL
) WITH (MEMORY_OPTIMIZED=ON, DURABILITY = SCHEMA_ONLY);
GO

-- Create a natively-compiled stored procedure.
--keyword 'with native compilation' determines it is natively compiled
--'begin atomic' is required at least once in a native stored procedure and creates a transaction or save point
--atomic requires that isolation level and language are defined 
CREATE PROCEDURE [dbo].[usp_InsertData2] 
  @rowcount INT,
  @c NCHAR(48)
  WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
  AS 
  BEGIN ATOMIC 
  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'British')
  DECLARE @i INT = 1;
  WHILE @i <= @rowcount
  BEGIN
    INSERT INTO [dbo].[inMemTable2](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
END
GO

--create 2nd stored proc to insert into 4th table
CREATE PROCEDURE [dbo].[usp_InsertData4] 
  @rowcount INT,
  @c NCHAR(48)
  WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
  AS 
  BEGIN ATOMIC 
  WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'British')
  DECLARE @i INT = 1;
  WHILE @i <= @rowcount
  BEGIN
    INSERT INTO [dbo].[inMemTable4](c1,c2) VALUES (@i, @c);
    SET @i += 1;
  END
END
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

-- Declare parameters for the test queries.
DECLARE @i INT = 1;
DECLARE @rowcount INT = 1000000;
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
SELECT COUNT(*) FROM DiskBasedTable
SELECT COUNT(*) FROM InMemTable
SELECT COUNT(*) FROM InMemTable2
SELECT COUNT(*) FROM InMemTable3
SELECT COUNT(*) FROM InMemTable4
--restart

--now get the count and tables 3 and 4 will now be empty
select 1

USE [SabinIO.Performance.InMemoryOltp]
GO

SELECT COUNT(*) FROM DiskBasedTable
SELECT COUNT(*) FROM InMemTable
SELECT COUNT(*) FROM InMemTable2
SELECT COUNT(*) FROM InMemTable3
SELECT COUNT(*) FROM InMemTable4
