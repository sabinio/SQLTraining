CREATE TABLE [dbo].[CountryCodes]
(
[CountryName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CountryCode] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CountryCodes] ADD CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED  ([CountryCode]) ON [PRIMARY]
GO
