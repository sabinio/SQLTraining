CREATE TABLE [dbo].[TruncTable] (
    [ID]             INT              NULL,
    [IntColumnOne]   INT              NULL,
    [IntColumnTwo]   INT              NULL,
    [IntColumnThree] INT              NULL,
    [UniqueColumn]   UNIQUEIDENTIFIER DEFAULT (newid()) NULL
);


GO
CREATE CLUSTERED INDEX [TT_ID]
    ON [dbo].[TruncTable]([ID] ASC);

