

USE [master]
GO

:setvar DatabaseName "SabinIO.Logging.WithTran"

DECLARE @mdfCurrentSize BIGINT
DECLARE @mdfNewSize BIGINT = 100
DECLARE @ldfCurrentSize BIGINT
DECLARE @ldfNewSize BIGINT = 100

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
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME =[$(DatabaseName)], SIZE = 100MB , FILEGROWTH = 100MB )
END
if (@ldfCurrentSize < @ldfNewSize)
BEGIN
PRINT 'increasing log size'
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME =[$(DatabaseName)_log], SIZE = 100MB , FILEGROWTH = 100MB )
END

END
