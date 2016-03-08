USE [SabinIO.Performance.TruncateDelete]
GO
/*
TRUNCATE TABLE removes the data by de-allocating the data pages used to store the table’s data, 
and only the page de-allocations are recorded in the transaction log. 
The DELETE statement removes rows one at a time and records an entry in the transaction log for each deleted row. 
It’s important to understand that TRUNCATE is logged, just not at the row level.
*/
 
SET NOCOUNT ON
DECLARE @INT INT = 1
WHILE @INT < 1000
BEGIN
INSERT INTO TruncTable (ID, IntColumnOne, IntColumnTwo, IntColumnThree)
SELECT RAND()*10000, RAND()*10000, RAND()*10000, RAND()*10000
SET @INT = @INT + 1
END
GO

SET NOCOUNT OFF
SET STATISTICS IO ON
SET STATISTICS TIME ON
TRUNCATE TABLE TruncTable
GO
 
SET NOCOUNT ON
DECLARE @INT INT = 1
WHILE @INT < 1000
BEGIN
INSERT INTO DelTable(ID, IntColumnOne, IntColumnTwo, IntColumnThree)
SELECT RAND()*10000, RAND()*10000, RAND()*10000, RAND()*10000
SET @INT = @INT + 1
END
GO

SET NOCOUNT OFF
 
SET STATISTICS IO ON
SET STATISTICS TIME ON
DELETE FROM DelTable
GO
SET STATISTICS IO OFF
GO
SET STATISTICS TIME OFF
GO
/*
The TRUNCATE completely skips any scan; it doesn’t even touch the table, whilst the DELETE scans the table before taking any action. 
As the number of rows increase, so the time taken to DELETE will increase, whilst executing a TRUNCATE won't take any longer.
*/