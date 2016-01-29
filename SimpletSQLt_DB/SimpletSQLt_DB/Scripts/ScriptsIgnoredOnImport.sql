
--create database simpleunittest_db
--CREATE TABLES
PRINT N'Creating Customer...';
GO

PRINT N'Creating Orders...';
GO

--CREATE INDEX ON CUSTOMER
PRINT N'Creating PK_Customer_CustID...';
GO

--CREATE INDEX ON SALES
PRINT N'Creating PK_Orders_OrderID...';
GO

--CREATE FORIEGN KEY INDEX ON ORDERS
PRINT N'Creating FK_Orders_Customer_CustID...';
GO

--CONSTRAINT ON ORDERS
--VERIFY THAT FILLEDDATE IS GREATER THAN OR EQUAL TO ORDER DATE
PRINT N'Creating CK_Orders_FilledDate...';
GO

--STORED PROCEDURES
--CANCEL ORDER
PRINT N'Creating uspCancelOrder...';
GO

--FILL ORDER
PRINT N'Creating uspFillOrder...';
GO

--NEW CUSTOMER
PRINT N'Creating uspNewCustomer...';
GO

--NEW ORDER
PRINT N'Creating uspPlaceNewOrder...';
GO
