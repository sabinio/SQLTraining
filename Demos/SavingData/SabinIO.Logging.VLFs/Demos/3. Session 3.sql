USE [SabinIO.Logging.VLFs]
GO

SET NOCOUNT ON;
GO



-- Run without commit
BEGIN TRANSACTION
	INSERT INTO Test3 VALUES ('ccc')

-----------------------------------------------------------------

-- Revert to Script 1

COMMIT TRANSACTION