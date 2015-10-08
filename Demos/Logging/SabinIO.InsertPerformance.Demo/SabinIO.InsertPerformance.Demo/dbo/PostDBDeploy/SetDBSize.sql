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

USE [master]
GO
ALTER DATABASE [SabinIO.InsertPerformance.Demo] MODIFY FILE ( NAME = N'SabinIO.InsertPerformance.Demo', SIZE = 400MB , FILEGROWTH = 100MB )
GO
ALTER DATABASE [SabinIO.InsertPerformance.Demo] MODIFY FILE ( NAME = N'SabinIO.InsertPerformance.Demo_log', SIZE = 500MB , FILEGROWTH = 100MB )
GO
