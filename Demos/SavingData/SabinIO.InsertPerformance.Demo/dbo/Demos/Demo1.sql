--Page Splits Demo
set nocount on
go
--Insert 160000 records
--Create 20000 pages in table
BEGIN TRANSACTION

declare @a int = 1
while @a <= 20000
begin
	insert into PageSplits(id,col1)
	values (@a,'a'),(@a,'b'),(@a,'c'),(@a,'d'),(@a,'e'),(@a,'f'),(@a,'g'),(@a,'h')
	set @a = @a + 1
end

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid
select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)

COMMIT TRANSACTION
GO
--5 secs
--transaction log bytes - 183925500
--transaction log bytes reserved - 49654176
--page count 20000


--Insert 20000 records 
--1 to each page
BEGIN TRANSACTION

declare @a int = 1
while @a <= 20000
begin
	insert into PageSplits(id,col1)
	values (@a,'a')
	set @a = @a + 1
end

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid
select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)

COMMIT TRANSACTION
GO
--3 secs
--transaction log bytes - 121933532
--transaction log bytes reserved - 46742070
--page count 40000


/*
Took just over half the time to insert 1/8th the amount of data.
We inserted 12.5% the number of records
yet created 66% of the TLog Bytes
Each insert created a new page
*/



--To reduce Page Splits
--remove data from table 
truncate table PageSplits

--Page Splits Demo

--Insert 160000 records
--Create 20000 pages in table
BEGIN TRANSACTION

declare @a int = 1
while @a <= 20000
begin
	insert into PageSplits(id,col1)
	values (@a,'a'),(@a,'b'),(@a,'c'),(@a,'d'),(@a,'e'),(@a,'f'),(@a,'g'),(@a,'h')
	set @a = @a + 1
end

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid
select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)

COMMIT TRANSACTION
GO
--5 secs
--transaction log bytes - 183925500
--transaction log bytes reserved - 49654176
--page count 20000


--rebuild index with fill factor of 80%
alter index idx_PageSplits on PageSplits rebuild with (fillfactor = 70)
go
select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)
go
--page count 22860


--Insert 20000 records 
--1 to each page
BEGIN TRANSACTION

declare @a int = 1
while @a <= 20000
begin
	insert into PageSplits(id,col1)
	values (@a,'a')
	set @a = @a + 1
end

select er.session_id,dt.database_transaction_log_record_count,dt.database_transaction_log_bytes_used,dt.database_transaction_log_bytes_reserved 
from sys.dm_exec_requests er
inner join sys.dm_tran_database_transactions dt
on er.transaction_id = dt.transaction_id
where er.session_id = @@spid
select page_count from sys.dm_db_index_physical_stats(db_id(),object_id('PageSplits'),1,Null,null)

COMMIT TRANSACTION
GO
--1 secs
--transaction log bytes - 20400144
--transaction log bytes reserved - 1489170
--page count 22860


/*
Inserting data was quicker
We inserted 12.5% the number of records
this time we created 11% of the TLog Bytes
Each insert was placed in the free space of the page
we didnt create any new pages
*/

