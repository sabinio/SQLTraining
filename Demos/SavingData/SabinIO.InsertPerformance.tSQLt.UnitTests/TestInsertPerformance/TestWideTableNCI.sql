CREATE PROCEDURE TestInsertPerformance.TestWideTableNCI
AS 
BEGIN


truncate table WideTableNoNCIndexes
declare @a INT = 1
declare @NoNCIndexes_page_count TINYINT
declare @WithNCIndexes_page_count TINYINT
while @a <=20
BEGIN
insert into WideTableNoNCIndexes(createdate,id2,id3,txtstr,txtstr2,txtstr3,shipdate,flag,flag2,flag3,addr1,addr2,addr3,pc,txtstr4,txtstr5,id4,id5,moddate,archive,custid,id6,id7,txtstr6)
select getdate(),cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),'a','b','c',getdate(),0,1,0,'1','2','3','pc','d','e',cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),getdate(),1,2,6,7,'f'
set @a = @a + 1
END
SELECT @NoNCIndexes_page_count = SUM(page_count) from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableNoNCIndexes'),1,null,'detailed')

truncate table WideTableWithNCIndexes
set @a = 1
while @a <=20
BEGIN
insert into WideTableWithNCIndexes(createdate,id2,id3,txtstr,txtstr2,txtstr3,shipdate,flag,flag2,flag3,addr1,addr2,addr3,pc,txtstr4,txtstr5,id4,id5,moddate,archive,custid,id6,id7,txtstr6)
select getdate(),cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),'a','b','c',getdate(),0,1,0,'1','2','3','pc','d','e',cast(rand()*10000 as bigint),cast(rand()*10000 as bigint),getdate(),1,2,6,7,'f'
set @a = @a + 1
END
SELECT @WithNCIndexes_page_count = sum(page_count) from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableWithNCIndexes'),null ,null,'detailed')

	IF @WithNCIndexes_page_count <= @NoNCIndexes_page_count
	BEGIN
		EXEC tSQLt.Fail 'Wide table with Non Clustered Indexes has less of a page count than wide table with no non clustered indexes.'
	END

END
