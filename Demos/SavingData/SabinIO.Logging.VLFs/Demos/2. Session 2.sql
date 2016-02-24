

USE [SabinIO.Logging.VLFs]
GO

SET NOCOUNT ON;
GO
-- Run without commit
BEGIN TRANSACTION
	INSERT INTO [SabinIO.Logging.VLFs].[dbo].[Test2] VALUES ('bbb')
-----------------------------------------------------------------
GO

-- Revert to Script 1

COMMIT TRANSACTION