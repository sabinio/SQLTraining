CREATE TABLE [dbo].[WidgetDescriptions]
(
[WidgetID] [int] NOT NULL IDENTITY(1, 1),
[ShortDescription] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Description] [text] COLLATE Latin1_General_CI_AS NULL,
[WidgetName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Picture] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[WidgetDescriptions] ADD CONSTRAINT [PK_WidgetDescriptions] PRIMARY KEY CLUSTERED  ([WidgetID]) ON [PRIMARY]
GO
