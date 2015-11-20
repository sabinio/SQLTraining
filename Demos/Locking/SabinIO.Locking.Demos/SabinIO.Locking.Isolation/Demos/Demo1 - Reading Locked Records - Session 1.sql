-- Session 1

USE [SabinIO.Locking.Isolation]
GO

-- This is the default isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION

UPDATE TableA
SET Col1 = 'test'
WHERE Id = 1

-- Leave transaction open for now
-- COMMIT TRANSACTION