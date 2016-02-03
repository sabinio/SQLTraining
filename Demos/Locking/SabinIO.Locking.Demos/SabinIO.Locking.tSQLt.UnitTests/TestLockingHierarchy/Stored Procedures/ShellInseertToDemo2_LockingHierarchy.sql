CREATE PROCEDURE ShellInsertToDemo2_LockingHierarchy @Ident TINYINT, @NameInsert VARCHAR (10), @COUNT TINYINT OUTPUT
AS
BEGIN TRANSACTION
INSERT INTO Demo2_LockingHierarchy
SELECT @Ident, @NameInsert
SELECT @COUNT = COUNT(*) FROM sys.dm_tran_locks
WHERE resource_type = 'RID'
AND request_mode = 'X'
COMMIT
RETURN
GO