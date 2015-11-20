-- Session 1

/*

Demo shows that a UPDATE will be blocked by a session that has read a record until Repeatable Read
INSERT will succeed and cause a phantom read

*/


USE [SabinIO.Locking.Isolation]
GO

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
SELECT * FROM TableA WHERE ID = 3

-- Run Session 2 in a different window

-- This session can continue
SELECT * FROM TableA WHERE ID = 3

-- Commit now and other session will complete the update
COMMIT TRANSACTION
GO



SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
SELECT COUNT(*) FROM TableA

-- Run Session 2 in a different window

-- This session returns a different count now (Phantom read)
SELECT COUNT(*) FROM TableA

-- Commit now and other session will complete the update
COMMIT TRANSACTION
GO
