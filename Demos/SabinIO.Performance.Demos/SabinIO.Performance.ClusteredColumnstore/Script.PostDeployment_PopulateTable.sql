USE [SabinIO.Performance.ClusteredColumnstore]
GO

IF NOT EXISTS(SELECT 1 FROM dbo.Table1)
exec dbo.PopulateTable 440000, 1