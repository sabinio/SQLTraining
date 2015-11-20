-- Session 2

USE [SabinIO.Locking.Isolation]
GO

-- This is the default isolation level (could be anything for this test)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Run section INCLUDING COMMIT
BEGIN TRANSACTION
UPDATE TableA
SET Col1 = 'test3'
WHERE Id = 3
COMMIT TRANSACTION
-- Session will be blocked by the read

-- STOP
-- RETURN TO SESSION 1






INSERT INTO TableA VALUES (4, 'NoBlocking')
-- Insert will NOT be blocked