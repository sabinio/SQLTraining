CREATE PROCEDURE TestLockingHierarchy.TestClusteredIXLockHierarchy
AS
BEGIN
DELETE FROM [Demo1_LockingHierarchy]

BEGIN TRANSACTION
	IF NOT EXISTS (
			SELECT name
			FROM sysindexes
			WHERE name = 'ind_Demo1_LockingHierarchy'
			)
		CREATE CLUSTERED INDEX ind_Demo1_LockingHierarchy ON Demo1_LockingHierarchy (id)
COMMIT

	DECLARE

		 @TableObjectID BIGINT = OBJECT_ID(N'Demo1_LockingHierarchy')
		,@DbLock CHAR(2)
		,@ObjectLock CHAR(2)
		,@PageLock CHAR(2)
		,@KeyLock CHAR(2)
		,@partitionId BIGINT

	SELECT @PartitionId = partition_id
	FROM sys.partitions p
	WHERE p.object_id = @TableObjectID

	BEGIN TRANSACTION

	INSERT INTO Demo1_LockingHierarchy
	SELECT 0
		,'insert'

	SELECT @DbLock = request_mode
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'database'
		AND resource_subtype = ''

	SELECT @ObjectLock = request_mode
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'object'
		AND resource_associated_entity_id = @TableObjectID

	SELECT @PageLock = request_mode
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'page'
		AND resource_associated_entity_id = @PartitionId

	SELECT @keyLock = request_mode
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'key'
		AND resource_associated_entity_id = @PartitionId

	COMMIT TRANSACTION

	EXEC tSQLt.AssertEquals 'S'
		,@DbLock;

	EXEC tSQLt.AssertEquals 'IX'
		,@ObjectLock;

	EXEC tSQLt.AssertEquals 'IX'
		,@PageLock;

	EXEC tSQLt.AssertEquals 'X'
		,@KeyLock;

			IF EXISTS (
			SELECT NAME
			FROM sysindexes
			WHERE NAME = 'ind_Demo1_LockingHierarchy'
			)
		DROP  INDEX ind_Demo1_LockingHierarchy ON Demo1_LockingHierarchy 
		/*
We have a 
Shared lock on the database
Intent Exclusive lock on the Object (Table)
Intent Exclusive lock on the Page
Exclusive lock on the row being inserted (KEY)
*/
END;
GO
