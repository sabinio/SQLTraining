USE [master]
GO

DECLARE @mdf NVARCHAR(400)
DECLARE @ldf NVARCHAR(400)
DECLARE @sql NVARCHAR(MAX)
DECLARE @mdfCurrentSize BIGINT
DECLARE @mdfNewSize BIGINT = 500
DECLARE @ldfCurrentSize BIGINT
DECLARE @ldfNewSize BIGINT = 600


SELECT * FROM sys.master_files
WHERE database_id = DB_ID('SabinIO.InsertPerformance.tSQLt.UnitTests') 

SELECT @mdf = NAME
FROM sys.master_files
WHERE database_id = DB_ID('SabinIO.InsertPerformance.tSQLt.UnitTests')
	AND right(physical_name, 3) = 'mdf'
	and file_id = 1

select @mdfCurrentSize = size * 8 / 1024.0
FROM sys.master_files
where name = @mdf

SELECT @ldf = NAME
FROM sys.master_files
WHERE database_id = DB_ID('SabinIO.InsertPerformance.tSQLt.UnitTests')
	AND right(physical_name, 3) = 'ldf'
	and file_id = 2

select @ldfCurrentSize = size * 8 / 1024.0
FROM sys.master_files
where name = @ldf

if (@mdfCurrentSize < @mdfNewSize)
BEGIN
PRINT 'beginning data'
SELECT @sql = 'ALTER DATABASE [SabinIO.InsertPerformance.tSQLt.UnitTests] MODIFY FILE ( NAME = N''' + @mdf + ''', SIZE = '+CAST(@mdfNewSize AS NVARCHAR (8))+'MB , FILEGROWTH = 100MB )'
PRINT @SQL
EXEC (@SQL)
END
if (@ldfCurrentSize < @ldfNewSize)
BEGIN
PRINT 'beginning log'
SELECT @sql = 'ALTER DATABASE [SabinIO.InsertPerformance.tSQLt.UnitTests] MODIFY FILE ( NAME = N''' + @ldf + ''', SIZE = '+CAST(@ldfNewSize AS NVARCHAR (8))+'MB , FILEGROWTH = 100MB )'
PRINT @SQL
EXEC (@SQL)
END
