--00

USE [SabinIO.Recovery.PageVerify]
GO

--01
SET NOCOUNT ON

DECLARE @i INT = 0
WHILE @i < 200
BEGIN
-- Generate Test Data
INSERT INTO PV_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
SET @i = @i + 1
END
GO

--02
SELECT * FROM PV_Sales
GO

--03
-- Clean Environment
CHECKPOINT
GO

--04
DBCC DROPCLEANBUFFERS()
GO

--05
-- Find a page
DBCC IND ([SabinIO.Recovery.PageVerify], N'PV_Sales', -1);
GO

--06
-- View a Page in the table
DBCC TRACEON(3604)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 93, 3) WITH TABLERESULTS;
GO
-- m_tornBits = 0    -- Find a Slot view record below

--07
SELECT * FROM PV_Sales WHERE OrderID = 100;
GO
--1294	4283	0	7
--08
-- Find Slot Starting Place
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 93, 2) WITH TABLERESULTS;
GO

--09
-- Add 14 bytes (record header)
select 119+14

-- Corrupt Page

ALTER DATABASE [SabinIO.Recovery.PageVerify] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
GO
--10
DBCC WRITEPAGE (N'SabinIO.Recovery.PageVerify', 1, 93,		133,		2,			0x6263, 1); 
--													^Page	^Start		^Length		^Value
GO
--11
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET MULTI_USER;
GO
--12
-- Error is not detetced on select
SELECT TOP 10 * FROM PV_Sales WHERE OrderID >= 100;
GO

--13
-- Clear down table
TRUNCATE TABLE PV_Sales
GO

--14
-- Set Page Verify
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET PAGE_VERIFY CHECKSUM  WITH NO_WAIT
GO
SET NOCOUNT ON
--15

-- Generate Test Data
DECLARE @i INT = 0
WHILE @i < 600
BEGIN
-- Generate Test Data
INSERT INTO PV_Sales (CustomerID, ProductID, Qty)
SELECT RAND()*10000,RAND()*100,RAND()*10
SET @i = @i + 1
END
GO

--16
SELECT * FROM PV_Sales
GO

-- Clean Environment
--17
CHECKPOINT
GO
--18
DBCC DROPCLEANBUFFERS()
GO
--19
-- Find a page
DBCC IND ([SabinIO.Recovery.PageVerify], N'PV_Sales', -1);
GO
-- View a Page in the table
--20
DBCC TRACEON(3604)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 119, 3) WITH TABLERESULTS;
GO
-- i am seeing torn bits here
-- m_tornBits = 0    -- Find a Slot view record below
--21
-- Select a record
SELECT * FROM PV_Sales WHERE OrderID = 373;
GO
--1294	4283	0	7
--22
-- Find Slot Starting Place (Set PageID)
DBCC PAGE ([SabinIO.Recovery.PageVerify], 1, 119, 2) WITH TABLERESULTS;
GO
--23
-- Add 14 bytes (record header)
select 119+14
GO
--24
-- Corrupt Page
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
GO
--25
-- (Set PageID)
DBCC WRITEPAGE (N'SabinIO.Recovery.PageVerify', 1, 119,		133,		2,			0x6263, 1); 
--												^Page	^Start		^Length		^Value
GO
--26
ALTER DATABASE [SabinIO.Recovery.PageVerify] SET MULTI_USER;
GO
--27
-- Error IS detetced on select
SELECT TOP 10 * FROM PV_Sales WHERE OrderID >= 373;
GO