SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Sistema_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Sistema_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Sistema_GetAll]
	 @IdMedico_Sistemar int = NULL
	,@IdMedico int = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MS.[IdMedico_Sistemar] 
		  ,MS.[IdMedico]
		  ,MS.[IdSistema]
		  ,S.Nombre AS SistemaNombre
		  ,MS.[IdVisitador1]
		  ,ISNULL(V.Nombre,'') AS VisitadorNombre
		  ,MS.[IdVisitador2]
		  ,ISNULL(V2.Nombre,'') AS VisitadorNombre2
		  ,MS.[Activo]
		  ,MS.[FechaDesde]
	  FROM [dbo].[CD_Medico_Sistema] MS
	  LEFT JOIN [dbo].[Sistema]  S ON (S.IdSistema = MS.IdSistema) 
	  LEFT JOIN [dbo].[CD_Visitador] V ON (MS.IdVisitador1 = V.IdVisitador) 
	  LEFT JOIN [dbo].[CD_Visitador] V2 ON (MS.IdVisitador2 = V2.IdVisitador) 	
	  WHERE  (@IdMedico IS NULL OR @IdMedico = MS.[IdMedico]) AND
	         (@IdMedico_Sistemar IS NULL OR @IdMedico_Sistemar = [IdMedico_Sistemar]) 
	          

END
GO
