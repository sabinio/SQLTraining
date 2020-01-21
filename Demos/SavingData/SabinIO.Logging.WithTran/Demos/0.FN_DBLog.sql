
use master
go
drop database logtest
go
create database logtest
go
use logtest
go
create table test (col1 int not null primary key, nonpokcol1 int)
go
--This shows all the rows being added into the internal system tables, they are just tables like any other table with rows and indexes
select 'after table created', *
 from sys.fn_dblog(null,null)
 order by [Current LSN] desc
go
insert into test(col1) values (100)
go
--This shows the first row requires space to be allocated in the pages that hold the allocation details, which pages/extents are allocated to which object  
select 'after 1 insert',*
 from sys.fn_dblog(null,null)
 order by [Current LSN] desc
go
insert into test(col1) values (1)
go
-- The second insert is much simpler, only the begin and end records and the insert of the row
select 'after 2nd insert',*
 from sys.fn_dblog(null,null)
 order by [Current LSN] desc
go
update test set nonpokcol1 = 99
go
-- The update is as simple as the second insert, only the begin and end records and the rows being updated
select 'after update',*
 from sys.fn_dblog(null,null)
 order by [Current LSN] desc
go
--Look at the size of the transaction log records, when only a single 4byte value is being inserted.
--It still requires >100 Bytes to record the change

