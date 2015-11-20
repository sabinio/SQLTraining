-- Session 2

USE [SabinIO.Locking.Isolation]
GO

-- This is the default isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Run all INCLUDING COMMIT

BEGIN TRANSACTION

UPDATE TableA
SET Col1 = 'test2'
WHERE Id = 2

COMMIT TRANSACTION