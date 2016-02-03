CREATE PROCEDURE TestLockingIsolation.TestDefaultValues

AS
 
BEGIN

IF NOT EXISTS (
			SELECT NAME
			FROM sys.objects
			WHERE NAME = 'Expected'
			)

CREATE TABLE [Expected]
(
	[Id] INT NOT NULL PRIMARY KEY,
	Col1	VARCHAR(4000) NOT NULL
)

	IF NOT EXISTS (
			SELECT NAME
			FROM sys.objects
			WHERE NAME = 'Actual'
			)

CREATE TABLE [Actual]
(
	[Id] INT NOT NULL PRIMARY KEY,
	Col1	VARCHAR(4000) NOT NULL
)

INSERT INTO Expected VALUES (1, 'aaaaaaaa');
INSERT INTO Expected VALUES (2, 'bbbbbbbb');
INSERT INTO Expected VALUES (3, 'cccccccc');

INSERT INTO dbo.Actual
SELECT * FROM [SabinIO.Locking.Isolation].[dbo].[TableA];

EXEC tSQLt.AssertEqualsTable 'Expected', 'Actual';

DROP TABLE dbo.Expected;
DROP TABLE dbo.Actual;

END;

GO