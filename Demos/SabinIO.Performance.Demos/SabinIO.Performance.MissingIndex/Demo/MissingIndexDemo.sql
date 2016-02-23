use AdventureWorks2014
GO
SET STATISTICS IO ON
select [Schema] from dbo.DatabaseLog
where [Schema] = 'dbo'

CREATE NONCLUSTERED INDEX [IX_DatabaseLog_Schema]
ON [dbo].[DatabaseLog] ([Schema])

select [Schema] from dbo.DatabaseLog
where [Schema] = 'dbo'

SET STATISTICS IO OFF
