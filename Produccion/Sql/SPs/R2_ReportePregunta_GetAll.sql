SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReportePregunta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReportePregunta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReportePregunta_GetAll]
	@IdReporte2 int = NULL
   ,@IdMarca int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.[IdPregunta]
		  ,P.[Descripcion]
		  ,P.[IdTipoPregunta]
		  ,P.[IdModulo]
		  ,P.[Orden]	
		  ,(case when RP.[Si] IS NULL then 0 else RP.[Si] end) as [Si]
		  ,(case when RP.[No] IS NULL then 0 else RP.[No] end) as [No]
		  ,RP.[Observaciones]		  
		  ,TP.SI AS TPSI
		  ,TP.[NO] AS TPNO
		  ,TP.Observaciones AS TPObservaciones
	FROM [R2_Pregunta] P
	INNER JOIN R2_TipoPregunta TP ON (P.[IdTipoPregunta] = TP.[IdTipoPregunta])
	INNER JOIN R2_PreguntaMarca PM ON (PM.IdMarca = @IdMarca AND PM.[IdPregunta] = P.[IdPregunta])	
	LEFT JOIN R2_ReportePregunta RP ON (RP.IdReporte2 = @IdReporte2 AND RP.[IdMarca]=@IdMarca AND RP.[IdPregunta] = P.[IdPregunta])
	
	ORDER BY P.[Orden]			
	
END
GO
