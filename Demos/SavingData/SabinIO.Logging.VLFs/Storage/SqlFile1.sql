/*
Do not change the database path or name variables.
Any sqlcmd variables will be properly substituted during 
build and deployment.
*/
ALTER DATABASE [$(DatabaseName)]
ADD LOG FILE
(
	NAME = [SqlFile1_log],
	FILENAME = '$(DefaultLogPath)$(DefaultFilePrefix)_SqlFile1.ldf',
	SIZE = 5MB,
	FILEGROWTH = 5MB
)
