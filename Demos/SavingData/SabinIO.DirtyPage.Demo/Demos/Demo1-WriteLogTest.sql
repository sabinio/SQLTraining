USE [SabinIO.dirtyPage.Demo]
GO


--Insert A Record into the table
insert into WriteLogTest
Select 'CleanPage'

--Ensure written to disk
Checkpoint

--Check value 
select * from WriteLogTest




--Update value
update WriteLogTest
set StringColumn = 'DirtyPage'

--Using Task manager kill the "sqlservr.exe" process 
--Open the MDF file in HxD (Hex editor) (download from http://mh-nexus.de/en/hxd/)
--Search for DirtyPage
--Unable to find?
--Search for CleanPage
--What value is in the Data file (MDF)

--Start the SQL Service

--Now check what is stored in the database
select * from WriteLogTest

--Check the SQl Server Log to see what happened on Startup
EXEC sys.xp_readerrorlog 

--Starting up database 'SabinIO.DirtyPages.Demo'.
--1 transactions rolled forward in database 'SabinIO.DirtyPages.Demo'
--0 transactions rolled back in database 'SabinIO.DirtyPages.Demo'
--Recovery is writing a checkpoint in database 'SabinIO.DirtyPages.Demo'
--Recovery is complete.

