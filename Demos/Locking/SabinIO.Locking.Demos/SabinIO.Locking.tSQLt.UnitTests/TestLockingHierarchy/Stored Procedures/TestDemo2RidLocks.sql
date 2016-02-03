CREATE PROCEDURE TestLockingHierarchy.TestDemo2RidLocks
AS
BEGIN
	DECLARE @ridObjectID TINYINT
	DECLARE @requestMode CHAR(8)
	DECLARE @count TINYINT
	DECLARE @resource_description NVARCHAR(256)
	DECLARE @object_id BIGINT = OBJECT_ID(N'Demo2_LockingHierarchy')
	DECLARE @PartitionId BIGINT

	INSERT INTO Demo2_LockingHierarchy
	SELECT 0
		,'insert'

	SELECT @PartitionId = partition_id
	FROM sys.partitions p
	WHERE p.object_id = @object_id

	SELECT @resource_description = resource_description
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

	SELECT @ridObjectID = right(replace(resource_description, ' ', ''), 1)
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

		EXEC tSQLT.AssertEquals 0
		,@RidObjectID

	INSERT INTO Demo2_LockingHierarchy
	SELECT 1
		,'insert'

	SELECT @resource_description = resource_description
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

	SELECT @ridObjectID = right(replace(resource_description, ' ', ''), 1)
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

	EXEC tSQLT.AssertEquals 1
		,@RidObjectID

	SELECT @COUNT = COUNT(*)
	FROM sys.dm_tran_locks
	WHERE resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

	INSERT INTO Demo2_LockingHierarchy
	SELECT 2
		,'insert'

	SELECT @ridObjectID = right(replace(resource_description, ' ', ''), 1)
		,@requestMode = request_mode
	FROM sys.dm_tran_locks
	WHERE request_session_id = @@SPID
		AND resource_type = 'RID'
		AND resource_associated_entity_id = @PartitionId

	EXEC tSQLT.AssertEquals 'X'
		,@requestMode
END
GO


