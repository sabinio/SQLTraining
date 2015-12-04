USE [SabinIO.Logging.VLFs]
GO

SET NOCOUNT ON;
GO


DBCC LOGINFO()

-- Run until two active VLF's
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
GO 20
DBCC LOGINFO()
GO

-- Checkpoint to free up first VLF
CHECKPOINT
GO
-- Only VLF 2 is now active
DBCC LOGINFO()
GO

-- Create Transactions in session 2 (Script 2)

-- Run until all VLF's active to show recycle
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
GO 50
DBCC LOGINFO()
GO


-- Checkpoint cannot free up any VLFs
CHECKPOINT
GO
-- All Active
DBCC LOGINFO()
GO

-- Continue until Auto Grow
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
GO 50
DBCC LOGINFO()
GO


-- Run Script 3 in new session


-- Continue all VLF's active
INSERT INTO Test1 (col1) VALUES (REPLICATE('a',8000))
GO 50
DBCC LOGINFO()
GO

-- Commit Script 2

-- Checkpoint to free up VLF's to 2nd transaction
CHECKPOINT
GO
-- All Active
DBCC LOGINFO()
GO

-- Commit Script 3
