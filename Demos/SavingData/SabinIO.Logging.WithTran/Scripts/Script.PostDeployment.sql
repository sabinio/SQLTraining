/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

USE [master]
GO

DECLARE @mdf NVARCHAR(400)
DECLARE @ldf NVARCHAR(400)
DECLARE @sql NVARCHAR(MAX)
DECLARE @mdfCurrentSize BIGINT
DECLARE @mdfNewSize BIGINT = 100
DECLARE @ldfCurrentSize BIGINT
DECLARE @ldfNewSize BIGINT = 100

SELECT @mdf = NAME
FROM sys.master_files
WHERE database_id = DB_ID('SabinIO.Logging.WithTran')
	AND right(physical_name, 3) = 'mdf'

select @mdfCurrentSize = size * 8 / 1024.0
FROM sys.master_files
where name = @mdf
select @mdfCurrentSize

SELECT @ldf = NAME
FROM sys.master_files
WHERE database_id = DB_ID('SabinIO.Logging.WithTran')
	AND right(physical_name, 3) = 'ldf'

select @ldfCurrentSize = size * 8 / 1024.0
FROM sys.master_files
where name = @ldf
select @ldfCurrentSize
if (@mdfCurrentSize < @mdfNewSize)
BEGIN
SELECT @sql = 'ALTER DATABASE [SabinIO.Logging.WithTran] MODIFY FILE ( NAME = N''' + @mdf + ''', SIZE = '+CAST(@mdfNewSize AS NVARCHAR (8))+'MB , FILEGROWTH = 100MB )'
PRINT @SQL
EXEC (@SQL)
END
if (@ldfCurrentSize < @ldfNewSize)
BEGIN
SELECT @sql = 'ALTER DATABASE [SabinIO.Logging.WithTran] MODIFY FILE ( NAME = N''' + @ldf + ''', SIZE = '+CAST(@ldfNewSize AS NVARCHAR (8))+'MB , FILEGROWTH = 100MB )'
PRINT @SQL
END
EXEC (@SQL)

