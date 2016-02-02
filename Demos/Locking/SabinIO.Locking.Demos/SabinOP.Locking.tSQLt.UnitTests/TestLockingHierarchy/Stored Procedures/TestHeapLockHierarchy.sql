
CREATE PROCEDURE TestLockingHierarchy.TestHeapLockHierarchy

AS 
BEGIN

DECLARE @TableObjectID bigint, @PartitionObjectId BIGINT, @DbLock CHAR (2), @ObjectLock CHAR (2), @PageLock CHAR (2), @RidLock CHAR(2), @partitionId BIGINT

select @TableObjectID = OBJECT_ID (N'Demo1_LockingHierarchy')

select @PartitionId = partition_id from sys.partitions p
where p.object_id = @TableObjectID

begin transaction
insert into Demo1_LockingHierarchy
select 0,'insert'

select @DbLock = request_mode from sys.dm_tran_locks
where request_session_id = @@SPID
and resource_type = 'database'

select @ObjectLock = request_mode from sys.dm_tran_locks
where request_session_id = @@SPID
and resource_type = 'object'
and resource_associated_entity_id = @TableObjectID

select @PageLock = request_mode from sys.dm_tran_locks
where request_session_id = @@SPID
and resource_type = 'page'
and resource_associated_entity_id = @PartitionId

select @RidLock = request_mode from sys.dm_tran_locks
where request_session_id = @@SPID
and resource_type = 'rid'
and resource_associated_entity_id = @PartitionId

commit transaction

/*
We have a 
Shared lock on the database
Intent Exclusive lock on the Object (Table)
Intent Exclusive lock on the Page
Exclusive lock on the row being inserted (RID)
*/

EXEC tSQLt.AssertEquals 'S', @DbLock;

EXEC tSQLt.AssertEquals 'IX', @ObjectLock;

EXEC tSQLt.AssertEquals 'IX', @PageLock;

EXEC tSQLt.AssertEquals 'X', @RidLock;

END;