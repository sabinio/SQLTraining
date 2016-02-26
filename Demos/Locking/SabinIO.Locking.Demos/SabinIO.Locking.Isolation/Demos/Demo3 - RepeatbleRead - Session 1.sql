-- Session 1

/*

Demo shows that a UPDATE will be blocked by a session that has read a record until Repeatable Read
INSERT will succeed and cause a phantom read

*/

--00
USE [SabinIO.Locking.Isolation]
GO
--01
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
--02
BEGIN TRANSACTION
SELECT * FROM [SabinIO.Locking.Isolation]..TableA WHERE ID = 3
GO
--03
-- Run Session 2 in a different window

-- This session can continue
SELECT * FROM TableA WHERE ID = 3

-- Commit now and other session will complete the update
COMMIT TRANSACTION
GO



SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
SELECT COUNT(*) AS [COUNT] FROM TableA
GO
-- Run Session 2 in a different window

-- This session returns a different count now (Phantom read)
SELECT COUNT(*) AS [COUNT] FROM TableA

-- Commit now and other session will complete the update
COMMIT TRANSACTION
