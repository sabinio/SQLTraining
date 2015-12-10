/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- Make sure the files do not have to autgrow during demo
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME = N'$(DefaultFilePrefix)', SIZE = 100MB )
GO
ALTER DATABASE [$(DatabaseName)] MODIFY FILE ( NAME = N'$(DefaultFilePrefix)_log', SIZE = 100MB )
GO