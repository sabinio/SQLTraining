-- Session 2

USE [SabinIO.Locking.Isolation]
GO

SELECT * FROM TableA (NOLOCK)
-- This retruns with a dirty read, session 1 could rollback yet and we have incorrect data


SET TRANSACTION ISOLATION LEVEL SNAPSHOT
SELECT * FROM TableA
-- This returns with a clean pre session 1 transaction state


-- This is the default isolation level (the same behaviour will happen for higher levels (repeatable read/serializable)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Query will be blocked
SELECT * FROM TableA
-- Stop the query manually


-- Query will ignore locked record
SELECT * FROM TableA (READPAST)


-- Commit Session 1