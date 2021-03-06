SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Padron]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Padron] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Padron]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;
	SELECT M.[IdMedico]
      ,ISNULL(M.[NroMatriculaNacional],'') AS NroMatriculaNacional
      ,ISNULL(M.[NroMatriculaProvincial],'') AS ASNroMatriculaProvincial
      ,M.[Nombre]
      ,CASE M.[Activo]
		WHEN 1 THEN 'SI'
		ELSE 'NO' 
		END AS [Activo]
      ,MLRP.IdVisitador1 AS [IdVisitador1LRP]
      ,MLRP.Visitador1Nombre  AS [Visitador1LRPNombre]
      ,MLRP.IdVisitador2 AS [IdVisitador2LRP]
      ,MLRP.Visitador2Nombre  AS [Visitador2LRPNombre]
      ,MLRP2.IdVisitador1 AS [IdVisitador1VICHY]
      ,MLRP2.Visitador1Nombre  AS [Visitador1VICHYNombre]
      ,MLRP2.IdVisitador2 AS [IdVisitador2VICHY]
      ,MLRP2.Visitador2Nombre  AS [Visitador2VICHYNombre]
  FROM [dbo].[CD_Medico] M
  LEFT JOIN [dbo].[CD_Medico_UltimoVisitadores](3) MLRP ON (M.IdMedico = MLRP.IdMedico)
  LEFT JOIN [dbo].[CD_Medico_UltimoVisitadores](4) MLRP2 ON (M.IdMedico = MLRP2.IdMedico)
  ORDER BY M.[Nombre]
  
END
GO
