USE [SabinIO.Logging.VLFs]
GO

SET NOCOUNT ON;
GO



-- Run without commit
BEGIN TRANSACTION
	INSERT INTO Test2 VALUES ('bbb')

-----------------------------------------------------------------

-- Revert to Script 1

COMMIT TRANSACTION