USE [SabinIO.Performance.ClusteredColumnstore]
GO

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT Id
	,SUM(memberId)
FROM dbo.Table1
GROUP BY id

DBCC FREEPROCCACHE

DBCC DROPCLEANBUFFERS

SELECT DISTINCT id
FROM dbo.Table1

CREATE CLUSTERED COLUMNSTORE INDEX [CCI_Table1] ON [dbo].[Table1]
	WITH (DROP_EXISTING = OFF)
GO

DBCC FREEPROCCACHE

DBCC DROPCLEANBUFFERS

SELECT Id
	,SUM(memberId)
FROM dbo.Table1
GROUP BY id

DBCC FREEPROCCACHE

DBCC DROPCLEANBUFFERS

SELECT DISTINCT id
FROM dbo.Table1


--table already has values
--if you need to add more then run sproc below
--first value is number of rows to insert; this value is multipled by 10 in the sproc
--second value determines whether to drop the clustered columnstore index or not
--sproc checks first if index exists first; if value isset to 1 then index is dorpped
--if set to 0 then index is just rebuilt so taht dictionaries etc are created for clustered columnstore
--exec dbo.PopulateTable 2000000, 1
--select * from sys.column_store_dictionaries;
--select * from sys.column_store_segments;
--select * from sys.column_store_row_groups;