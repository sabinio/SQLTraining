CREATE TABLE [dbo].[Guitar] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [GuitarName] NVARCHAR (12) NOT NULL,
    [OrderID]    INT           NOT NULL,
    [Date]       DATETIME2 (3) Constraint [AddDate] DEFAULT (getdate()) NOT NULL
);
