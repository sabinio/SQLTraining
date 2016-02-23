--include actual execution plan
set statistics IO ON

select P.BigId from dbo.Table1 P
group by p.BigId

select distinct P.BigId from dbo.Table1 P
--look at the messages tab and the execution plan; these are both identical
--both require a sort on the data

--add a nonclustered index to the table on the column we are querying
CREATE NONCLUSTERED INDEX [IX_Table1_BigId] 
ON dbo.Table1([BigId] ASC)

--run queries again
select P.BigId from dbo.Table1 P
group by p.BigId

select distinct P.BigId from dbo.Table1 P
-- both now no longer require the sort, and both read less pages
