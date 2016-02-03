USE [SabinIO.Recovery.PageVerify]
GO


SET NOCOUNT ON

-- Generate Test Data
INSERT INTO PV_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
GO 2000


SELECT * FROM PV_Sales
GO

-- Clean Environment
CHECKPOINT
GO
DBCC DROPCLEANBUFFERS()
GO

-- View a Page in the table
DBCC TRACEON(3604)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 162, 3);
-- m_tornBits = 0    -- Find a Slot view record below


SELECT * FROM PV_Sales WHERE OrderID = 1294;

--1294	4283	0	7

-- Find Slot Starting Place
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 162, 2);

-- Add 14 bytes (record header)
select 119+14

-- Corrupt Page
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
GO
DBCC WRITEPAGE (N'SabinIO.Recovery.PageVerify', 1, 162,		133,		2,			0x6263, 1); 
--													^Page	^Start		^Length		^Value
GO
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET MULTI_USER;
GO

-- Error is not detetced on select
SELECT TOP 10 * FROM PV_Sales WHERE OrderID >= 1290;
GO

-- Clear down table
TRUNCATE TABLE PV_Sales
GO

-- Set Page Verify
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET PAGE_VERIFY CHECKSUM  WITH NO_WAIT
GO


SET NOCOUNT ON

-- Generate Test Data
INSERT INTO PV_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
GO 2000


SELECT * FROM PV_Sales
GO

-- Clean Environment
CHECKPOINT
GO
DBCC DROPCLEANBUFFERS()
GO

-- Find a page
DBCC IND ([SabinIO.Recovery.PageVerify], N'PV_Sales', -1);

-- View a Page in the table
DBCC TRACEON(3604)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 338, 3);
-- m_tornBits = 0    -- Find a Slot view record below

-- Select a record
SELECT * FROM PV_Sales WHERE OrderID = 5493;

--1294	4283	0	7

-- Find Slot Starting Place (Set PageID)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 338, 2);

-- Add 14 bytes (record header)
select 119+14

-- Corrupt Page
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
GO
-- (Set PageID)
DBCC WRITEPAGE (N'SabinIO.Recovery.PageVerify', 1, 338,		133,		2,			0x6263, 1); 
--													^Page	^Start		^Length		^Value
GO
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET MULTI_USER;
GO

-- Error IS detetced on select
SELECT TOP 10 * FROM PV_Sales WHERE OrderID >= 5493;
GO