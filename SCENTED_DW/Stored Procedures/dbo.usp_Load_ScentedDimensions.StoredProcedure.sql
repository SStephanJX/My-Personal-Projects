USE [SCENTED_DW]
GO
/****** Object:  StoredProcedure [dbo].[usp_Load_ScentedDimensions]    Script Date: 7/1/2025 1:24:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Stephen Stephan
-- Create date: 2025.06.25
-- Description:	Load tables into SCENTED_DW
-- =============================================
CREATE PROCEDURE [dbo].[usp_Load_ScentedDimensions]

	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
INSERT INTO SCENTED_DW.dbo.DimBrand (BrandName)
SELECT DISTINCT Brand
FROM SCENTED.dbo.FragranticaData_temp
WHERE Brand IS NOT NULL
  AND Brand NOT IN (
      SELECT BrandName FROM SCENTED_DW.dbo.DimBrand
  );

INSERT INTO SCENTED_DW.dbo.DimGender (GenderLabel)
SELECT DISTINCT Gender
FROM SCENTED.dbo.FragranticaData_temp
WHERE Gender IS NOT NULL
  AND Gender NOT IN (
      SELECT GenderLabel FROM SCENTED_DW.dbo.DimGender
  );

INSERT INTO SCENTED_DW.dbo.DimFragrance (PerfumeName, BrandID, GenderID)
SELECT 
    t.Perfume,
    b.BrandID,
    g.GenderID
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
WHERE NOT EXISTS (
    SELECT 1 FROM SCENTED_DW.dbo.DimFragrance f
    WHERE f.PerfumeName = t.Perfume 
      AND f.BrandID = b.BrandID 
      AND f.GenderID = g.GenderID
);

INSERT INTO SCENTED_DW.dbo.FactFragranceRating (FragranceID, RatingValue)
SELECT 
    f.FragranceID,
    t.[Rating Value]
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
JOIN SCENTED_DW.dbo.DimFragrance f
    ON f.PerfumeName = t.Perfume
   AND f.BrandID = b.BrandID
   AND f.GenderID = g.GenderID;

   -- Top Notes
INSERT INTO SCENTED_DW.dbo.DimNote (NoteName)
SELECT DISTINCT TRIM(value)
FROM SCENTED.dbo.FragranticaData_temp
CROSS APPLY STRING_SPLIT([Top], ',')
WHERE TRIM(value) NOT IN (
    SELECT NoteName FROM SCENTED_DW.dbo.DimNote
);

-- Middle Notes
INSERT INTO SCENTED_DW.dbo.DimNote (NoteName)
SELECT DISTINCT TRIM(value)
FROM SCENTED.dbo.FragranticaData_temp
CROSS APPLY STRING_SPLIT([Middle], ',')
WHERE TRIM(value) NOT IN (
    SELECT NoteName FROM SCENTED_DW.dbo.DimNote
);

-- Base Notes
INSERT INTO SCENTED_DW.dbo.DimNote (NoteName)
SELECT DISTINCT TRIM(value)
FROM SCENTED.dbo.FragranticaData_temp
CROSS APPLY STRING_SPLIT([Base], ',')
WHERE TRIM(value) NOT IN (
    SELECT NoteName FROM SCENTED_DW.dbo.DimNote
);

INSERT INTO SCENTED_DW.dbo.BridgeFragranceNote (FragranceID, NoteID, NoteType)
SELECT DISTINCT
    f.FragranceID,
    n.NoteID,
    'Top' AS NoteType
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
JOIN SCENTED_DW.dbo.DimFragrance f
    ON f.PerfumeName = t.Perfume
   AND f.BrandID = b.BrandID
   AND f.GenderID = g.GenderID
CROSS APPLY STRING_SPLIT(t.[Top], ',') s
JOIN SCENTED_DW.dbo.DimNote n ON LTRIM(RTRIM(s.value)) = n.NoteName;

INSERT INTO SCENTED_DW.dbo.BridgeFragranceNote (FragranceID, NoteID, NoteType)
SELECT DISTINCT
    f.FragranceID,
    n.NoteID,
    'Middle' AS NoteType
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
JOIN SCENTED_DW.dbo.DimFragrance f
    ON f.PerfumeName = t.Perfume
   AND f.BrandID = b.BrandID
   AND f.GenderID = g.GenderID
CROSS APPLY STRING_SPLIT(t.[Middle], ',') s
JOIN SCENTED_DW.dbo.DimNote n ON LTRIM(RTRIM(s.value)) = n.NoteName;

INSERT INTO SCENTED_DW.dbo.BridgeFragranceNote (FragranceID, NoteID, NoteType)
SELECT DISTINCT
    f.FragranceID,
    n.NoteID,
    'Base' AS NoteType
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
JOIN SCENTED_DW.dbo.DimFragrance f
    ON f.PerfumeName = t.Perfume
   AND f.BrandID = b.BrandID
   AND f.GenderID = g.GenderID
CROSS APPLY STRING_SPLIT(t.[Base], ',') s
JOIN SCENTED_DW.dbo.DimNote n ON LTRIM(RTRIM(s.value)) = n.NoteName;

INSERT INTO SCENTED_DW.dbo.DimAccord (AccordName)
SELECT DISTINCT TRIM(mainaccord1) FROM SCENTED.dbo.FragranticaData_temp
WHERE TRIM(mainaccord1) IS NOT NULL
  AND TRIM(mainaccord1) <> ''
  AND TRIM(mainaccord1) NOT IN (SELECT AccordName FROM SCENTED_DW.dbo.DimAccord)

UNION
SELECT DISTINCT TRIM(mainaccord2) FROM SCENTED.dbo.FragranticaData_temp
WHERE TRIM(mainaccord2) IS NOT NULL
  AND TRIM(mainaccord2) <> ''
  AND TRIM(mainaccord2) NOT IN (SELECT AccordName FROM SCENTED_DW.dbo.DimAccord)

UNION
SELECT DISTINCT TRIM(mainaccord3) FROM SCENTED.dbo.FragranticaData_temp
WHERE TRIM(mainaccord3) IS NOT NULL
  AND TRIM(mainaccord3) <> ''
  AND TRIM(mainaccord3) NOT IN (SELECT AccordName FROM SCENTED_DW.dbo.DimAccord)

UNION
SELECT DISTINCT TRIM(mainaccord4) FROM SCENTED.dbo.FragranticaData_temp
WHERE TRIM(mainaccord4) IS NOT NULL
  AND TRIM(mainaccord4) <> ''
  AND TRIM(mainaccord4) NOT IN (SELECT AccordName FROM SCENTED_DW.dbo.DimAccord)

UNION
SELECT DISTINCT TRIM(mainaccord5) FROM SCENTED.dbo.FragranticaData_temp
WHERE TRIM(mainaccord5) IS NOT NULL
  AND TRIM(mainaccord5) <> ''
  AND TRIM(mainaccord5) NOT IN (SELECT AccordName FROM SCENTED_DW.dbo.DimAccord);

INSERT INTO SCENTED_DW.dbo.BridgeFragranceAccord (FragranceID, AccordID, AccordOrder)
SELECT DISTINCT
    f.FragranceID,
    a.AccordID,
    1 AS AccordOrder
FROM SCENTED.dbo.FragranticaData_temp t
JOIN SCENTED_DW.dbo.DimBrand b
    ON t.Brand = b.BrandName
JOIN SCENTED_DW.dbo.DimGender g
    ON t.Gender = g.GenderLabel
JOIN SCENTED_DW.dbo.DimFragrance f
    ON f.PerfumeName = t.Perfume
   AND f.BrandID = b.BrandID
   AND f.GenderID = g.GenderID
JOIN SCENTED_DW.dbo.DimAccord a
    ON TRIM(t.mainaccord1) = a.AccordName
WHERE t.mainaccord1 IS NOT NULL AND TRIM(t.mainaccord1) <> '';

SELECT COUNT(*) FROM [dbo].[BridgeFragranceAccord]
SELECT COUNT(*) FROM [dbo].[BridgeFragranceNote]
SELECT COUNT(*) FROM [dbo].[DimAccord]
SELECT COUNT(*) FROM [dbo].[DimBrand]
SELECT COUNT(*) FROM [dbo].[DimFragrance]
SELECT COUNT(*) FROM [dbo].[DimGender]
SELECT COUNT(*) FROM [dbo].[DimNote]
SELECT COUNT(*) FROM [dbo].[FactFragranceRating]

END
GO
