-- Session 1

USE [SabinIO.Locking.Isolation]
GO

SELECT * FROM [SabinIO.Locking.Isolation]..TableA

-- This is the default isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION

UPDATE TableA
SET Col1 = 'test'
WHERE Id = 1
GO

-- Leave transaction open for now
-- COMMIT TRANSACTION