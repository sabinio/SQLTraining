--00
USE [SabinIO.Logging.VLFs]
GO
--01
SET NOCOUNT ON;
GO
--02
DBCC LOGINFO()
GO
--03
-- Run until two active VLF's
DECLARE @i INT = 0
WHILE @i < 30
BEGIN
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
SET @i = @i + 1
END
GO
--04
DBCC LOGINFO()
GO
--05
-- Checkpoint to free up first VLF
CHECKPOINT
GO
--06
-- Only VLF 2 is now active
DBCC LOGINFO()
GO
--07
-- Create Transactions in session 2 (Script 2)
-- Run until all VLF's active to show recycle
DECLARE @i INT = 0
WHILE @i < 60
BEGIN
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
SET @i = @i + 1
END
GO
--08
DBCC LOGINFO()
GO
--09
-- Checkpoint cannot free up any VLFs
CHECKPOINT
GO
--10
-- All Active
DBCC LOGINFO()
GO

-- Continue until Auto Grow
DECLARE @i INT = 0
WHILE @i < 30
BEGIN
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
SET @i = @i + 1
END
GO

--12
DBCC LOGINFO()
GO
--13
-- Run Script 3 in new session


-- Continue all VLF's active
DECLARE @i INT = 0
WHILE @i < 30
BEGIN
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
SET @i = @i + 1
END
GO
--14
DBCC LOGINFO()
GO
--15
-- Commit Script 2

-- Checkpoint to free up VLF's to 2nd transaction
CHECKPOINT
GO
--16
-- All Active
DBCC LOGINFO()
GO
--17
-- Commit Script 3
CHECKPOINT
GO
--18
-- All Active
DBCC LOGINFO()