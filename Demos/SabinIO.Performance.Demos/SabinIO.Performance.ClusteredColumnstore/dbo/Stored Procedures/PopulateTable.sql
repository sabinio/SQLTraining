CREATE PROCEDURE dbo.PopulateTable (@numberofRowsX10 INT, @DropIndex BIT)
AS 
BEGIN

SET NOCOUNT ON

IF OBJECT_ID('dbo.Tally', 'U') IS NOT NULL 
  DROP TABLE dbo.Tally; 

TRUNCATE TABLE dbo.Table1

DECLARE @SQL NVARCHAR(MAX)
SET @SQL = '
SELECT TOP '+CAST (@numberofRowsX10 AS NVARCHAR (16))+' IDENTITY(INT, 1, 1) AS N
INTO dbo.Tally
FROM Master.dbo.SysColumns sc1
	,Master.dbo.SysColumns sc2'

EXEC (@SQL)

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 1
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 2
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 3
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 4
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 5
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 6
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 7
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 8
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 9
	,RAND() * 12
FROM dbo.Tally

INSERT INTO dbo.Table1 (
	Id
	,memberId
	)
SELECT 10
	,RAND() * 12
FROM dbo.Tally



IF exists(
select 1 from [SabinIO.Performance.ClusteredColumnstore].sys.indexes i
where i.name = 'CCI_Table1'
and type = 5
and OBJECT_ID('Table1') = i.object_id
)
BEGIN
IF @DropIndex = 0
BEGIN
ALTER INDEX [CCI_Table1] ON [dbo].[Table1] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE)
END
ELSE
DROP INDEX [CCI_Table1] ON dbo.Table1
END
END