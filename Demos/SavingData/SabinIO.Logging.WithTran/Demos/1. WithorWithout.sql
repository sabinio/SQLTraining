USE [SabinIO.Logging.WithTran]
GO

SET NOCOUNT ON;

-- WHICH WILL BE FASTER AND WHY?


-- BATCH 1 - No Transaction
DECLARE @x INT = 0, @RunTime INT = 0
DECLARE @StartTime DATETIME2(3) = GETDATE();
WHILE @x < 2000
BEGIN
	INSERT INTO Test (Col2)
	VALUES (REPLICATE('a',8000))
	SET @x = @x + 1
END
SET @RunTime = DATEDIFF(ms,
 @StartTime, GETDATE());
SELECT @RunTime as RunTime;
GO


-- BATCH 2 - Explict Transaction
DECLARE @x INT = 0, @RunTime INT = 0
DECLARE @StartTime DATETIME2(3) = GETDATE();
BEGIN TRANSACTION
	WHILE @x < 2000
	BEGIN
		INSERT INTO Test (Col2)
		VALUES (REPLICATE('a',8000))
		SET @x = @x + 1
	END
COMMIT TRANSACTION
SET @RunTime = DATEDIFF(ms, @StartTime, GETDATE());
SELECT @RunTime as RunTime;
GO
