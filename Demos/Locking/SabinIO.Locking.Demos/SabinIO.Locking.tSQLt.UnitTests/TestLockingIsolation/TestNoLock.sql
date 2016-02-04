CREATE PROCEDURE TestLockingIsolation.TestNoLock

AS 

TRUNCATE TABLE TableA;

INSERT INTO TableA VALUES (1, 'aaaaaaaa');
INSERT INTO TableA VALUES (2, 'bbbbbbbb');
INSERT INTO TableA VALUES (3, 'cccccccc');

IF NOT EXISTS (
			SELECT name
			FROM sys.tables
			WHERE name = 'Expected'
			)
BEGIN
CREATE TABLE [Expected]
(
	[Id] INT NOT NULL PRIMARY KEY,
	Col1	VARCHAR(16) NOT NULL
)
END
	IF NOT EXISTS (
			SELECT NAME
			FROM sys.tables
			WHERE NAME = 'Actual'
			)
BEGIN
CREATE TABLE [Actual]
(
	[Id] INT NOT NULL PRIMARY KEY,
	Col1	VARCHAR(16) NOT NULL
)
END
INSERT INTO expected VALUES (1, 'test');
INSERT INTO expected VALUES (2, 'bbbbbbbb');
INSERT INTO expected VALUES (3, 'cccccccc');

-- This is the default isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION

UPDATE TableA
SET Col1 = 'test'
WHERE Id = 1

insert into actual
exec shellNoLock

COMMIT

EXEC tSQLt.AssertEqualsTable 'Expected', 'Actual';

DROP TABLE Actual;
DROP TABLE Expected;

GO