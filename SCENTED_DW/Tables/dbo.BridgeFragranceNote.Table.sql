USE [SCENTED_DW]
GO
/****** Object:  Table [dbo].[BridgeFragranceNote]    Script Date: 7/1/2025 1:24:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BridgeFragranceNote](
	[FragranceID] [int] NOT NULL,
	[NoteID] [int] NOT NULL,
	[NoteType] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FragranceID] ASC,
	[NoteID] ASC,
	[NoteType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BridgeFragranceNote]  WITH CHECK ADD FOREIGN KEY([FragranceID])
REFERENCES [dbo].[DimFragrance] ([FragranceID])
GO
ALTER TABLE [dbo].[BridgeFragranceNote]  WITH CHECK ADD FOREIGN KEY([NoteID])
REFERENCES [dbo].[DimNote] ([NoteID])
GO
ALTER TABLE [dbo].[BridgeFragranceNote]  WITH CHECK ADD CHECK  (([NoteType]='Base' OR [NoteType]='Middle' OR [NoteType]='Top'))
GO
