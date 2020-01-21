/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
ADD LOG FILE
(
	NAME = [Log_log],
	FILENAME = '$(DefaultLogPath)$(DefaultFilePrefix)_Log.ldf',
	SIZE = 1024 KB,
	FILEGROWTH = 1MB
)
