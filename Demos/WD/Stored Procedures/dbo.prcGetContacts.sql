SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[prcGetContacts] 
    AS SELECT 
    ID ,
		ContactFullName
		FROM Contacts
		
GO
