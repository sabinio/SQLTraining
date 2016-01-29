CREATE TABLE [CustomerOrders] (
    [OrderID]    INT      IDENTITY (1, 1) NOT NULL,
	[CustomerID] INT      NOT NULL,
    [OrderDate]  DATETIME NOT NULL DEFAULT GETDATE(),
    [FilledDate] DATETIME NULL,
    [Status]     CHAR (1) NOT NULL DEFAULT 'O',
    [Amount]     INT      NOT NULL
);
GO
ALTER TABLE [CustomerOrders]
    ADD CONSTRAINT [FK_Orders_Customer_CustID] FOREIGN KEY ([CustomerID]) REFERENCES [Customer] ([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [CustomerOrders]
    ADD CONSTRAINT [CK_Orders_FilledDate] CHECK ((FilledDate >= OrderDate));
GO
ALTER TABLE [CustomerOrders]
    ADD CONSTRAINT [PK_Orders_OrderID] PRIMARY KEY CLUSTERED ([OrderID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);