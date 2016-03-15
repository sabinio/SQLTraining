CREATE SCHEMA [SQL Cop]
AUTHORIZATION [dbo]
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'tSQLt.TestClass', @xp, 'SCHEMA', N'SQL Cop', NULL, NULL, NULL, NULL
GO
