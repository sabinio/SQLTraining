
USE [master]
GO

:setvar DatabaseName "SabinIO.InsertPerformance.Demo"

DECLARE @mdfCurrentSize BIGINT
DECLARE @mdfNewSize BIGINT = 500
DECLARE @ldfCurrentSize BIGINT
DECLARE @ldfNewSize BIGINT = 600

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
PRINT 'Database exists. Checking if new size is less than or equal to default size...'

select @mdfCurrentSize = size * 8 / 1024.0
FROM [master].[sys].[master_files]
where name = '$(DatabaseName)'

select @ldfCurrentSize = size * 8 / 1024.0
FROM [master].[sys].[master_files]
where name = '$(DatabaseName)_log'

if (@mdfCurrentSize < @mdfNewSize)
BEGIN
PRINT 'increasing data file size'
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME =[$(DatabaseName)], SIZE = 500MB , FILEGROWTH = 100MB )
END
if (@ldfCurrentSize < @ldfNewSize)
BEGIN
PRINT 'increasing log size'
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME =[$(DatabaseName)_log], SIZE = 600MB , FILEGROWTH = 100MB )
END

END
