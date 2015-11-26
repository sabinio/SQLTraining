USE [SabinIO.Logging.Demo1]
GO

SET NOCOUNT ON;


-- Prep
TRUNCATE TABLE Test1
GO


-- RERUN WATCHING COUNTERS
DECLARE @StartFlushes INT = (SELECT cntr_value FROM sys.dm_os_performance_counters where counter_name = 'Log Flushes/sec' AND instance_name = DB_NAME())

DECLARE @x INT = 0
WHILE @x < 2000
BEGIN
	INSERT INTO Test1 (Col2)
	VALUES (REPLICATE('a',8000))
	SET @x = @x + 1
END

DECLARE @EndFlushes INT = (SELECT cntr_value FROM sys.dm_os_performance_counters where counter_name = 'Log Flushes/sec' AND instance_name = DB_NAME())

SELECT @EndFlushes-@StartFlushes Flushes  -- Should be around 20k
GO







DECLARE @StartFlushes INT = (SELECT cntr_value FROM sys.dm_os_performance_counters where counter_name = 'Log Flushes/sec' AND instance_name = DB_NAME())

DECLARE @x INT = 0
BEGIN TRANSACTION
	WHILE @x < 2000
	BEGIN
		INSERT INTO Test1 (Col2)
		VALUES (REPLICATE('a',8000))
		SET @x = @x + 1
	END
COMMIT TRANSACTION

DECLARE @EndFlushes INT = (SELECT cntr_value FROM sys.dm_os_performance_counters where counter_name = 'Log Flushes/sec' AND instance_name = DB_NAME())

SELECT @EndFlushes-@StartFlushes Flushes -- Should be about 3.3k
GO

-- Lots of small flushes vs fewer larger flushes
-- Using a single transaction each insert does not have to wait for the log record to be written to disk