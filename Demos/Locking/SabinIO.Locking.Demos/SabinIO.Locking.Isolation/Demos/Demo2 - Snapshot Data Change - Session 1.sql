-- Session 1

USE [SabinIO.Locking.Isolation]
GO

SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO
BEGIN TRANSACTION
SELECT * FROM TableA
GO

-- Run Session 2 in a different window

UPDATE TableA
SET Col1 = 'somethingDifferent'
WHERE Id = 2
GO
-- Should fail:
--Snapshot isolation transaction aborted due to update conflict. You cannot use snapshot isolation to access table 'dbo.TableA' directly or indirectly in database 'SabinIO.Locking.Isolation' to update, delete, or insert the row that has been modified or deleted by another transaction. Retry the transaction or change the isolation level for the update/delete statement.

-- Session 2 won:
SELECT * FROM TableA

-- Had we not have run the select at the start this would be fine