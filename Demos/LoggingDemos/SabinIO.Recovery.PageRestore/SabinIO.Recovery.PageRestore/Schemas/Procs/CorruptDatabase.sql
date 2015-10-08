CREATE PROCEDURE [dbo].[CorruptDatabase]
AS

-- DBCC IND (N'DBName', N'Sales', -1);
-- Page 440 Should Always Exist

DECLARE @PageID INT

CREATE TABLE #IND(
	PageFID		INT,
	PagePID		INT,
	IAMFID		INT,
	IAMPID		INT,
	OBJECTID	INT,
	IndexId		INT,
	PartitionNumber INT,
	PartitionID	BIGINT,
	IAM_CHAIN_TYPE VARCHAR(500),
	PageType	INT,
	IndexLevelID	INT,
	NextPageFID	INT,
	NextPagePID	INT,
	PrevPageFID	INT,
	PrevPagePID	INT)

INSERT INTO #IND
EXEC ('DBCC IND (N''$(DatabaseName)'', N''Sales'', -1);')

SELECT @PageID = MAX(PagePID)
FROM #IND
WHERE PageType = 1
	AND NextPagePID > 0

DROP TABLE #IND


ALTER DATABASE [$(DatabaseName)] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 

DBCC WRITEPAGE (N'$(DatabaseName)', 1, @PageID, 4000, 1, 0x45, 1); 

PRINT @PageID

ALTER DATABASE [$(DatabaseName)] SET MULTI_USER; 
GO

