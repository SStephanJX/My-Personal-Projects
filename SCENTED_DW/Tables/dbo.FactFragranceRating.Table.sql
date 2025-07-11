USE [SCENTED_DW]
GO
/****** Object:  Table [dbo].[FactFragranceRating]    Script Date: 7/1/2025 1:24:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactFragranceRating](
	[RatingID] [int] IDENTITY(1,1) NOT NULL,
	[FragranceID] [int] NOT NULL,
	[RatingValue] [float] NOT NULL,
	[LoadDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RatingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactFragranceRating] ADD  DEFAULT (getdate()) FOR [LoadDate]
GO
ALTER TABLE [dbo].[FactFragranceRating]  WITH CHECK ADD FOREIGN KEY([FragranceID])
REFERENCES [dbo].[DimFragrance] ([FragranceID])
GO
