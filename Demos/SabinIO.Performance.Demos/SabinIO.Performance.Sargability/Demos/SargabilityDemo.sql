

CREATE NONCLUSTERED INDEX IX_Guitar_GuitarName 
ON Guitar(GuitarName); 
GO

--include actual execution plan
SELECT GuitarName FROM Guitar WHERE GuitarName Like '%Gibson'
--not sargable; cannot seek, so will scan


--include actual execution plan
SELECT GuitarName FROM Guitar WHERE GuitarName Like 'Gibson%'
--this time able to seek

CREATE NONCLUSTERED INDEX IX_Guitar_OrderID 
ON Guitar(OrderID); 
GO

--arithmatic operator
SELECT OrderID FROM Guitar WHERE OrderID *3 = 33000

SELECT OrderID FROM Guitar WHERE OrderID = 33000/3

--scalar function

CREATE NONCLUSTERED INDEX IX_Guitar_Date 
ON Guitar([Date]); 
GO

SELECT [Date] FROM Guitar WHERE Year([Date]) = 2016

SELECT [Date] FROM Guitar WHERE [Date] >= '2016-01-01 ' AND [Date] <= '2016-12-31'

--Substring examples
--non sargable
SELECT GuitarName FROM Guitar WHERE SUBSTRING(GuitarName,1,4) = 'Rick'

--sargable
SELECT GuitarName FROM Guitar WHERE GuitarName LIKE 'Rick%'


--CASE Examples
--non sargable
SELECT GuitarName FROM Guitar WHERE UPPER(GuitarName) LIKE 'FENDER'

--sargable
SELECT GuitarName FROM Guitar WHERE GuitarName LIKE 'FENDER'


