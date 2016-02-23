CREATE TABLE [dbo].[LargeTable] (
    [KeyVal]  INT NOT NULL,
    [DataVal] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([KeyVal] ASC),
    CHECK ([DataVal]>=(1) AND [DataVal]<=(10))
);

