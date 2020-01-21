CREATE TABLE [dbo].[WideTableWithNCIndexesCompression] (
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
	CONSTRAINT [PK_WideTableWithNCIndexesCompression] PRIMARY KEY CLUSTERED ([id] ASC) with (data_compression=page)
);


GO
CREATE NONCLUSTERED INDEX [idx_nc1]
	ON [dbo].[WideTableWithNCIndexesCompression]([custid] ASC, [moddate] ASC)
	INCLUDE([archive], [shipdate], [id], [id2], [txtstr2], [id7], [txtstr6], [txtstr3], [txtstr4], [txtstr5])
	with (data_compression=page);
 

GO
CREATE NONCLUSTERED INDEX [idx_nc2]
	ON [dbo].[WideTableWithNCIndexesCompression]([custid] ASC, [id] ASC)
	INCLUDE([id2], [id3], [id4], [id5], [id6], [id7], [txtstr6], [pc], [txtstr4], [txtstr2], [addr1], [addr2], [addr3])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc3]
	ON [dbo].[WideTableWithNCIndexesCompression]([id2] ASC, [id] ASC)
	INCLUDE([txtstr], [txtstr2], [addr1], [addr2], [addr3], [pc], [txtstr6])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc4]
	ON [dbo].[WideTableWithNCIndexesCompression]([pc] ASC)
	INCLUDE([addr1], [addr2], [addr3], [custid], [shipdate], [txtstr], [txtstr2], [txtstr3], [txtstr4])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc5]
	ON [dbo].[WideTableWithNCIndexesCompression]([shipdate] ASC, [custid] ASC)
	INCLUDE([addr1], [addr2], [addr3], [flag], [flag2], [flag3], [pc], [id], [id2], [id3], [id4], [id5], [id6])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc6]
	ON [dbo].[WideTableWithNCIndexesCompression]([id6] ASC, [id7] ASC)
	INCLUDE([txtstr2], [txtstr5], [id2], [id3], [txtstr6], [pc], [addr1], [addr2], [addr3])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc7]
	ON [dbo].[WideTableWithNCIndexesCompression]([id4] ASC, [txtstr6] ASC)
	INCLUDE([id2], [id5], [id6], [txtstr4], [txtstr5], [createdate], [shipdate], [moddate])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc8]
	ON [dbo].[WideTableWithNCIndexesCompression]([moddate] ASC, [pc] ASC)
	INCLUDE([custid], [shipdate], [addr1], [addr2], [addr3], [txtstr6], [id2], [id3], [id4], [createdate], [txtstr2], [txtstr3])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc9]
	ON [dbo].[WideTableWithNCIndexesCompression]([archive] ASC, [custid] ASC, [moddate] ASC)
	INCLUDE([id2], [txtstr2], [txtstr5], [id5], [id7], [txtstr4], [pc], [txtstr6])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc10]
	ON [dbo].[WideTableWithNCIndexesCompression]([custid] ASC, [createdate] ASC, [shipdate] ASC)
	INCLUDE([flag], [id4], [flag2], [txtstr3], [id6], [moddate], [pc], [txtstr2])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc11]
	ON [dbo].[WideTableWithNCIndexesCompression]([custid] ASC, [archive] ASC, [createdate] ASC)
	INCLUDE([shipdate], [addr1], [addr2], [addr3], [pc], [id5], [txtstr3])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc12]
	ON [dbo].[WideTableWithNCIndexesCompression]([flag2] ASC, [flag3] ASC)
	INCLUDE([txtstr], [txtstr2], [txtstr3], [txtstr4], [txtstr5], [txtstr6])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc13]
	ON [dbo].[WideTableWithNCIndexesCompression]([flag] ASC, [flag3] ASC)
	INCLUDE([id], [id2], [id3], [id4], [id5], [id6], [id7])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc14]
	ON [dbo].[WideTableWithNCIndexesCompression]([txtstr] ASC, [txtstr2] ASC)
	INCLUDE([flag], [flag2], [flag3], [addr1], [addr2], [addr3], [pc], [custid], [shipdate], [moddate], [createdate])with (data_compression=page);


GO
CREATE NONCLUSTERED INDEX [idx_nc15]
	ON [dbo].[WideTableWithNCIndexesCompression]([custid] ASC, [txtstr] ASC, [txtstr2] ASC, [createdate] ASC)
	INCLUDE([addr1], [addr2], [addr3], [pc], [shipdate], [id5], [id6], [id3], [txtstr3])with (data_compression=page);

