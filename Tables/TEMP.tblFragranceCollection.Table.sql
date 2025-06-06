USE [SCENTED]
GO
/****** Object:  Table [TEMP].[tblFragranceCollection]    Script Date: 6/3/2025 2:38:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TEMP].[tblFragranceCollection](
	[Brand] [nvarchar](255) NULL,
	[Fragrance] [nvarchar](255) NULL,
	[Release Year] [nvarchar](4) NULL,
	[Concentration] [nvarchar](255) NULL,
	[Size] [nvarchar](255) NULL,
	[Decant] [nvarchar](255) NULL,
	[Top] [nvarchar](255) NULL,
	[Middle] [nvarchar](255) NULL,
	[Base] [nvarchar](255) NULL
) ON [PRIMARY]
GO
