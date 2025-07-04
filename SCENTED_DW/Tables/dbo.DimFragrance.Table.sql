USE [SCENTED_DW]
GO
/****** Object:  Table [dbo].[DimFragrance]    Script Date: 7/1/2025 1:24:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimFragrance](
	[FragranceID] [int] IDENTITY(1,1) NOT NULL,
	[PerfumeName] [nvarchar](255) NOT NULL,
	[BrandID] [int] NOT NULL,
	[GenderID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FragranceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimFragrance]  WITH CHECK ADD FOREIGN KEY([BrandID])
REFERENCES [dbo].[DimBrand] ([BrandID])
GO
ALTER TABLE [dbo].[DimFragrance]  WITH CHECK ADD FOREIGN KEY([GenderID])
REFERENCES [dbo].[DimGender] ([GenderID])
GO
