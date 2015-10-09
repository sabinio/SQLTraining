set nocount on
go
insert into WideTableNoNCIndexes(createdate,id2,id3,txtstr,txtstr2,txtstr3,shipdate,flag,flag2,flag3,addr1,addr2,addr3,pc,txtstr4,txtstr5,id4,id5,moddate,archive,custid,id6,id7,txtstr6)
select getdate(),cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),'a','b','c',getdate(),0,1,0,'1','2','3','pc','d','e',cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),getdate(),1,2,6,7,'f'
go 2000

select sum(page_count) AS Page_Count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableNoNCIndexes'),1,null,'detailed')

--18secs to insert 20000 records





--identitcal table with additional 15 NC indexes
set nocount on
go
insert into WideTableWithNCIndexes(createdate,id2,id3,txtstr,txtstr2,txtstr3,shipdate,flag,flag2,flag3,addr1,addr2,addr3,pc,txtstr4,txtstr5,id4,id5,moddate,archive,custid,id6,id7,txtstr6)
select getdate(),cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),'a','b','c',getdate(),0,1,0,'1','2','3','pc','d','e',cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),getdate(),1,2,6,7,'f'
go 2000

select sum(page_count) AS Page_Count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableWithNCIndexes'),null ,null,'detailed')

--22secs to insert 20000 records
--to many additional indexes can have a detremental effect on dml performance





