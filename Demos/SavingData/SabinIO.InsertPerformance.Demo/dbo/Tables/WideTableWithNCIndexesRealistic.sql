CREATE TABLE [dbo].[WideTableWithNCIndexesRealistic] (
    [id]         BIGINT    IDENTITY (1, 1) NOT NULL,
    [createdate] DATETIME  NULL,
    [id2]        BIGINT    NULL,
    [id3]        BIGINT    NULL,
    [txtstr]     CHAR (10) NULL,
    [txtstr2]    CHAR (5)  NULL,
    [txtstr3]    CHAR (5)  NULL,
    [shipdate]   DATETIME  NULL,
    [flag]       BIT       NULL,
    [flag2]      BIT       NULL,
    [flag3]      BIT       NULL,
    [addr1]      CHAR (15) NULL,
    [addr2]      CHAR (15) NULL,
    [addr3]      CHAR (15) NULL,
    [pc]         CHAR (10) NULL,
    [txtstr4]    CHAR (10) NULL,
    [txtstr5]    CHAR (10) NULL,
    [id4]        BIGINT    NULL,
    [id5]        BIGINT    NULL,
    [moddate]    DATETIME  NULL,
    [archive]    BIT       NULL,
    [custid]     BIGINT    NULL,
    [id6]        BIGINT    NULL,
    [id7]        BIGINT    NULL,
    [txtstr6]    CHAR (7)  NULL,
    CONSTRAINT [PK_WideTableWithNCIndexesRealistic] PRIMARY KEY CLUSTERED ([id] ASC) with (data_compression=page)
);


GO
CREATE NONCLUSTERED INDEX [idx_nc1]
    ON [dbo].[WideTableWithNCIndexesRealistic]([custid] ASC, [moddate] ASC)
    with (data_compression=page);
 

GO
CREATE NONCLUSTERED INDEX [idx_nc2]
    ON [dbo].[WideTableWithNCIndexesRealistic]([custid] ASC, [id] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc3]
    ON [dbo].[WideTableWithNCIndexesRealistic]([id2] ASC, [id] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc4]
    ON [dbo].[WideTableWithNCIndexesRealistic]([pc] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc5]
    ON [dbo].[WideTableWithNCIndexesRealistic]([shipdate] ASC, [custid] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc6]
    ON [dbo].[WideTableWithNCIndexesRealistic]([id6] ASC, [id7] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc7]
    ON [dbo].[WideTableWithNCIndexesRealistic]([id4] ASC, [txtstr6] ASC)
    with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc8]
    ON [dbo].[WideTableWithNCIndexesRealistic]([moddate] ASC, [pc] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc9]
    ON [dbo].[WideTableWithNCIndexesRealistic]([archive] ASC, [custid] ASC, [moddate] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc10]
    ON [dbo].[WideTableWithNCIndexesRealistic]([custid] ASC, [createdate] ASC, [shipdate] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc11]
    ON [dbo].[WideTableWithNCIndexesRealistic]([custid] ASC, [archive] ASC, [createdate] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc12]
    ON [dbo].[WideTableWithNCIndexesRealistic]([flag2] ASC, [flag3] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc13]
    ON [dbo].[WideTableWithNCIndexesRealistic]([flag] ASC, [flag3] ASC)
	with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc14]
    ON [dbo].[WideTableWithNCIndexesRealistic]([txtstr] ASC, [txtstr2] ASC)with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc15]
    ON [dbo].[WideTableWithNCIndexesRealistic]([custid] ASC, [txtstr] ASC, [txtstr2] ASC, [createdate] ASC)
	with (data_compression=page);

