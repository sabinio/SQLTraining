CREATE TABLE [dbo].[WidgetReferences]
(
[WidgetID] [int] NOT NULL IDENTITY(1, 1),
[Reference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WidgetReferences] ADD CONSTRAINT [PK_WidgetReferences] PRIMARY KEY NONCLUSTERED  ([WidgetID]) ON [PRIMARY]
GO
