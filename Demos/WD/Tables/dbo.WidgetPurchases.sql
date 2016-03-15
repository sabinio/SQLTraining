CREATE TABLE [dbo].[WidgetPurchases]
(
[PurchaseID] [int] NOT NULL IDENTITY(1, 1),
[WidgetPriceID] [int] NOT NULL,
[Quantity] [int] NOT NULL CONSTRAINT [DF__WidgetPur__Quant__1367E606] DEFAULT ((1)),
[InvoiceNumber] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF__WidgetPurc__Date__145C0A3F] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [IX_WidgetPurchases] ON [dbo].[WidgetPurchases] ([PurchaseID]) ON [PRIMARY]
GO
