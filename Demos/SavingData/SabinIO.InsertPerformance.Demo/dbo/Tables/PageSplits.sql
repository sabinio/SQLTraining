CREATE TABLE [dbo].[PageSplits] (
    [id]   INT        NOT NULL,
    [col1] CHAR (900) NOT NULL
);


GO
CREATE CLUSTERED INDEX [idx_PageSplits]
    ON [dbo].[PageSplits]([id] ASC) WITH (FILLFACTOR = 100);

