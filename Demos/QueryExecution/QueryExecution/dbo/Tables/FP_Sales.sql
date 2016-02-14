CREATE TABLE [dbo].[FP_Sales] (
    [SalesOrderID]           INT              IDENTITY (1, 1) NOT NULL,
    [RevisionNumber]         TINYINT          NOT NULL,
    [OrderDate]              DATETIME         NOT NULL,
    [DueDate]                DATETIME         NOT NULL,
    [ShipDate]               DATETIME         NULL,
    [Status]                 TINYINT          NOT NULL,
    [OnlineOrderFlag]        BIT              NOT NULL,
    [SalesOrderNumber]       NVARCHAR (25)    COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [PurchaseOrderNumber]    NVARCHAR (25)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [AccountNumber]          NVARCHAR (15)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CustomerID]             INT              NOT NULL,
    [SalesPersonID]          INT              NULL,
    [TerritoryID]            INT              NULL,
    [BillToAddressID]        INT              NOT NULL,
    [ShipToAddressID]        INT              NOT NULL,
    [ShipMethodID]           INT              NOT NULL,
    [CreditCardID]           INT              NULL,
    [CreditCardApprovalCode] VARCHAR (15)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [CurrencyRateID]         INT              NULL,
    [SubTotal]               MONEY            NOT NULL,
    [TaxAmt]                 MONEY            NOT NULL,
    [Freight]                MONEY            NOT NULL,
    [TotalDue]               MONEY            NOT NULL,
    [Comment]                NVARCHAR (128)   COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [rowguid]                UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]           DATETIME         NOT NULL,
	CONSTRAINT [PK_FP_Sales_FP_Sales_ID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC
)
);


