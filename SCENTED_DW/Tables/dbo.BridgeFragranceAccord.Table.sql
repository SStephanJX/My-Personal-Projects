USE [SCENTED_DW]
GO
/****** Object:  Table [dbo].[BridgeFragranceAccord]    Script Date: 7/1/2025 1:24:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BridgeFragranceAccord](
	[FragranceID] [int] NOT NULL,
	[AccordID] [int] NOT NULL,
	[AccordOrder] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[FragranceID] ASC,
	[AccordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BridgeFragranceAccord]  WITH CHECK ADD FOREIGN KEY([AccordID])
REFERENCES [dbo].[DimAccord] ([AccordID])
GO
ALTER TABLE [dbo].[BridgeFragranceAccord]  WITH CHECK ADD FOREIGN KEY([FragranceID])
REFERENCES [dbo].[DimFragrance] ([FragranceID])
GO
ALTER TABLE [dbo].[BridgeFragranceAccord]  WITH CHECK ADD CHECK  (([AccordOrder]>=(1) AND [AccordOrder]<=(5)))
GO
