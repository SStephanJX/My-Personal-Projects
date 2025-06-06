USE [SCENTED]
GO
/****** Object:  StoredProcedure [dbo].[MergeFragranceCollection]    Script Date: 6/3/2025 2:38:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified by:		Stephen T. Stephan
-- Modified date:	2025.06.02
-- Description:		New Merge Proc for Fragrance Collection table.
-- =============================================

CREATE PROCEDURE [dbo].[MergeFragranceCollection]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE INTO dbo.tblFragranceCollection AS TGT
    USING (SELECT [Brand]
      ,[Fragrance]
      ,[Release Year]
      ,[Concentration]
      ,[Size]
      ,[Decant]
      ,[Top]
      ,[Middle]
      ,[Base]
  FROM [SCENTED].[TEMP].[tblFragranceCollection]) AS SRC
    ON TGT.Brand = SRC.Brand 
		AND TGT.Fragrance = SRC.Fragrance
    WHEN MATCHED THEN
        UPDATE SET
            TGT.[Release Year] = SRC.[Release Year],
            TGT.[Concentration] = SRC.[Concentration],
            TGT.[Size] = SRC.[Size],
            TGT.[Decant] = SRC.[Decant],
            TGT.[Top] = SRC.[Top],
            TGT.[Middle] = SRC.[Middle],
            TGT.[Base] = SRC.[Base]
    WHEN NOT MATCHED THEN
        INSERT (
		[Brand]
		, [Fragrance]
		, [Release Year]
		, [Concentration]
		, [Size]
		, [Decant]
		, [Top]
		, [Middle]
		, [Base])
        VALUES (
		SRC.[Brand]
		, SRC.[Fragrance]
		, SRC.[Release Year]
		, SRC.[Concentration]
		, SRC.[Size]
		, SRC.[Decant]
		, SRC.[Top]
		, SRC.[Middle]
		, SRC.[Base]
);

END;

GO
