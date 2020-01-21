USE [SabinIO.InsertPerformance.Demo]
GO


set nocount on
go
declare @start datetime= getdate()
declare @i INT = 1
while (@i <50000)
	BEGIN
	update WideTableNoNCIndexes
	set createdate= getdate(),
		id2=		cast(rand()*10000 as bigint),
		id3=		cast(rand()*10000 as bigint),
		txtstr=		'a',
		txtstr2=	'b',
		txtstr3=	'c',
		shipdate=	getdate(),
		flag=		0,
		flag2=		1,
		flag3=		0,
		addr1=		'1',
		addr2=		'2',
		addr3=		'3',
		pc=			'pc',
		txtstr4=	'd',
		txtstr5=	'e',
		id4=		cast(rand()*10000 as bigint),
		id5=		cast(rand()*10000 as bigint),
		moddate=	getdate(),
		archive=	1,
		custid=		2,
		id6=		6,
		id7=		7,
		txtstr6= 	'f'
	where id between @i and @i + 20
	set @i = @i + 20
	END
select datediff(ms,@start,getdate()) duration
GO

select sum(page_count) AS Page_Count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableNoNCIndexes'),1,null,'detailed')
select i.name,index_level, index_depth, page_count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableNoNCIndexes'),null ,null,'detailed')s
join sys.indexes i on s.index_id = i.index_id and s.object_id = i.object_id

--18secs to insert 20000 records -old laptop


--identitcal table with additional 15 NC indexes
set nocount on
go

declare @start datetime= getdate()
declare @i INT = 1
while (@i < 50000)
	BEGIN
	update WideTableWithNCIndexes
	set createdate= getdate(),
		id2=		cast(rand()*10000 as bigint),
		id3=		cast(rand()*10000 as bigint),
		txtstr=		'a',
		txtstr2=	'b',
		txtstr3=	'c',
		shipdate=	getdate(),
		flag=		0,
		flag2=		1,
		flag3=		0,
		addr1=		'1',
		addr2=		'2',
		addr3=		'3',
		pc=			'pc',
		txtstr4=	'd',
		txtstr5=	'e',
		id4=		cast(rand()*10000 as bigint),
		id5=		cast(rand()*10000 as bigint),
		moddate=	getdate(),
		archive=	1,
		custid=		2,
		id6=		6,
		id7=		7,
		txtstr6= 	'f'
	where id between @i and @i + 20
	set @i = @i+20
	END
select datediff(ms,@start,getdate()) duration
GO

select sum(page_count) AS Page_Count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableWithNCIndexes'),null ,null,'detailed')
select i.name,index_level, index_depth, page_count from sys.dm_db_index_physical_stats(db_id(),object_id('WideTableWithNCIndexes'),null ,null,'detailed')s
join sys.indexes i on s.index_id = i.index_id and s.object_id = i.object_id


go

go
update WideTableWithNCIndexes
	set createdate= getdate(),
		id2=		cast(rand()*10000 as bigint),
		id3=		cast(rand()*10000 as bigint),
		txtstr=		'a',
		txtstr2=	'b',
		txtstr3=	'c',
		shipdate=	getdate(),
		flag=		0,
		flag2=		1,
		flag3=		0,
		addr1=		'1',
		addr2=		'2',
		addr3=		'3',
		pc=			'pc',
		txtstr4=	'd',
		txtstr5=	'e',
		id4=		cast(rand()*10000 as bigint),
		id5=		cast(rand()*10000 as bigint),
		moddate=	getdate(),
		archive=	1,
		custid=		2,
		id6=		6,
		id7=		7,
		txtstr6= 	'f'
	where id between 1 and 1000


go
update WideTableWithNCIndexes
	set createdate= getdate(),
		id2=		cast(rand()*10000 as bigint),
		id3=		cast(rand()*10000 as bigint),
		txtstr=		'a',
		txtstr2=	'b',
		txtstr3=	'c',
		shipdate=	getdate(),
		flag=		0,
		flag2=		1,
		flag3=		0,
		addr1=		'1',
		addr2=		'2',
		addr3=		'3',
		pc=			'pc',
		txtstr4=	'd',
		txtstr5=	'e',
		id4=		cast(rand()*10000 as bigint),
		id5=		cast(rand()*10000 as bigint),
		moddate=	getdate(),
		archive=	1,
		custid=		2,
		id6=		6,
		id7=		7,
		txtstr6= 	'f'
	where id =9999




