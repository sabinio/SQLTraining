-- Session 2

USE [SabinIO.Locking.Isolation]
GO

-- This is the default isolation level (could be anything for this test)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
-- Run section INCLUDING COMMIT
BEGIN TRANSACTION
UPDATE [SabinIO.Locking.Isolation]..TableA
SET Col1 = 'test3'
WHERE Id = 3
COMMIT TRANSACTION
-- Session will be blocked by the read

-- STOP
-- RETURN TO SESSION 1
GO

SELECT * FROM [SabinIO.Locking.Isolation]..TableA
GO

INSERT INTO [SabinIO.Locking.Isolation]..TableA VALUES (4, 'NoBlocking')
SELECT * FROM [SabinIO.Locking.Isolation]..TableA
-- Insert will NOT be blocked