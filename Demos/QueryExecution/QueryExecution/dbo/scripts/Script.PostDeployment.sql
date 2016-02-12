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
:r .\Populate_FP_Sales.sql	

--C:\Users\Richard\Source\Repos\SQL Training\Demos\QueryExecution\QueryExecution\dbo\scripts\Populate_FPSales.sql
--C:\USERS\RICHARD\SOURCE\REPOS\SQL TRAINING\DEMOS\QUERYEXECUTION\QUERYEXECUTION\DBO\SCRIPTS\SCRIPTS\POPULATE_FP_SALES.SQL