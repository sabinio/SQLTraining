Use [SabinIO.Performance.UnionUnionAll]
GO

INSERT INTO Table1
SELECT 'Hydrogen'
UNION ALL
SELECT 'Helium'
UNION ALL
SELECT 'Lithium'
UNION ALL
SELECT 'Beryllium'
UNION ALL
SELECT 'Boron'


INSERT INTO Table2
SELECT 'Hydrogen'
UNION ALL
SELECT 'Lithium'
UNION ALL
SELECT 'Boron'

--turn on actual execution results
--using UNION ALL returns all 8 rows, including duplicates
SELECT *
FROM Table1
UNION ALL
SELECT *
FROM Table2

--using UNION returns unique values
--this is achieved using a distinct sort
SELECT *
FROM Table1
UNION
SELECT *
FROM Table2
GO 

