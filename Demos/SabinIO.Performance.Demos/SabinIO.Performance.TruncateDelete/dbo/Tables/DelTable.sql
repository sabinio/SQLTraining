CREATE TABLE [dbo].[DelTable] (
    [ID]             INT              NULL,
    [IntColumnOne]   INT              NULL,
    [IntColumnTwo]   INT              NULL,
    [IntColumnThree] INT              NULL,
    [UniqueColumn]   UNIQUEIDENTIFIER DEFAULT (newid()) NULL
);


GO
CREATE CLUSTERED INDEX [DT_ID]
    ON [dbo].[DelTable]([ID] ASC);

