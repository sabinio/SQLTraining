--00
USE [SabinIO.Locking.LockingHierarchy]
GO

--Row level locks

--01
--execute the next transaction (inluding the commmit)
begin transaction
insert into Demo2_LockingHierarchy
select 0,'insert'

select * from sys.dm_tran_locks
where request_session_id = @@SPID

commit transaction

--notice the resource_description for the RID lock
--the first 2 numbers are the pageid the last number is the slotid
--slotid = 0


--execute the next transaction (inluding the commmit)
begin transaction
insert into Demo2_LockingHierarchy
select 1,'insert'

select * from sys.dm_tran_locks
where request_session_id = @@SPID

commit transaction
GO
--notice the resource_description for the RID lock
--the first 2 numbers are the pageid the last number is the slotid
--slotid = 1

--02
--execute the next transaction but do not commit
begin transaction
insert into Demo2_LockingHierarchy
select 2,'insert'

select * from sys.dm_tran_locks
where request_session_id = @@SPID
GO
--commit transaction

--slotid 2 has an exclusive lock


--03
--copy and execute the next transaction to a new window
begin transaction
insert into [SabinIO.Locking.LockingHierarchy]..Demo2_LockingHierarchy
select 3,'insert'

select * from sys.dm_tran_locks
--where request_session_id = @@SPID

commit transaction
GO
--we can see that 2 Exclusive locks on individual records can co exist without blocking each other
--commit the above transaction


--04
--execute the next transaction but do not commit
begin transaction

insert into Demo2_LockingHierarchy with(paglock)
select 4,'insert'
select * from sys.dm_tran_locks
where request_session_id = @@SPID
GO

--commit transaction
--notice the page now has an exclusive lock

--05
--copy and execute the next transaction to a new window
begin transaction
insert into Demo2_LockingHierarchy
select 5,'insert'

select * from sys.dm_tran_locks
--where request_session_id = @@SPID

commit transaction
GO
--this time we insert into a different page as the other page is locked

--06
--copy and execute the next transaction to a new window
--this time we update a recored on the page that is locked
begin transaction
update Demo2_LockingHierarchy
set name = 'update'
where id = 2
select * from sys.dm_tran_locks
--where request_session_id = @@SPID

commit transaction
GO
--07

--we are waiting for the page lock to be released
--run the next query in a new window
select * from sys.dm_tran_locks
GO
--we now have an Intent Update lock on the page that is waiting (not yet granted)
COMMIT TRANSACTION
COMMIT TRANSACTION
GO

--commit the above transaction
--then check to make sure the update has completed


