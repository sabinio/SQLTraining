CREATE TABLE [dbo].[orders] (
    [OrderId]    INT      IDENTITY (1, 1) NOT NULL,
    [OrderDate]  DATETIME NULL,
    [CustomerId] INT      NULL
);
