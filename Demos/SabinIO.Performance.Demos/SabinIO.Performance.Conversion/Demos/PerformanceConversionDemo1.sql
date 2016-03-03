USE [SabinIO.Performance.Conversion];
GO

SET NOCOUNT ON

DECLARE @i INT = 1

WHILE @i <= 26
BEGIN
	INSERT INTO _integer
	VALUES (@i)

	INSERT INTO _char
	VALUES (@i)

	SET @i = @i + 1
END

--turn on actual execution plan
SELECT *
FROM _char

SELECT *
FROM _integer

--as expected, both are scan
SELECT *
FROM _char
WHERE ch = 5

SELECT *
FROM _integer
WHERE id = 5

--first query is a scan, 2nd is a seek
--nvarchar can be converted to int and vice versa
--however the conversion will affect performance because only a scan can occur
--alter data type to verify
ALTER TABLE [dbo].[_char]

DROP CONSTRAINT [pk_char]

ALTER TABLE _char

ALTER COLUMN ch INT NOT NULL

ALTER TABLE [dbo].[_char] ADD CONSTRAINT [pk_char] PRIMARY KEY CLUSTERED ([ch] ASC)

--run queries again
SELECT *
FROM _char
WHERE ch = 5

SELECT *
FROM _integer
WHERE id = 5

--now both are seeks
--on a larger table, we can see the difference between a seek and a scan in terms of page reads
SET STATISTICS IO ON

--implicit conversion
SELECT NationalIDNumber
FROM [AdventureWorks2014].[HumanResources].[Employee]
WHERE NationalIDNumber = 509647174

--no conversion
SELECT NationalIDNumber
FROM [AdventureWorks2014].[HumanResources].[Employee]
WHERE NationalIDNumber = '509647174'

--some implicit conversions do not cause scans;
--below is a char against a varchar, but we will still get a seek
-- no warning in the query plan (hover over index seek to see implicit change)
SELECT NationalIDNumber
FROM [AdventureWorks2014].[HumanResources].[Employee]
WHERE NationalIDNumber = CAST('509647174' AS CHAR(15))

SET STATISTICS IO OFF
