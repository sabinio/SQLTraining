-- Session 2

USE [SabinIO.Locking.Isolation]
GO

SELECT * FROM [SabinIO.Locking.Isolation]..TableA (NOLOCK)
-- This retruns with a dirty read, session 1 could rollback yet and we have incorrect data
GO

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SELECT * FROM [SabinIO.Locking.Isolation]..TableA
-- This returns with a clean pre session 1 transaction state
GO

-- This is the default isolation level (the same behaviour will happen for higher levels (repeatable read/serializable)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
-- Query will be blocked
SELECT * FROM [SabinIO.Locking.Isolation]..TableA
-- Stop the query manually
GO

-- Query will ignore locked record
SELECT * FROM [SabinIO.Locking.Isolation]..TableA (READPAST)
GO

-- Commit Session 1