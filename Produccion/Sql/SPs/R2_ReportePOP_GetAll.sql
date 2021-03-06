SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReportePOP_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReportePOP_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReportePOP_GetAll] 
	
	@IdReporte2 int = NULL
   ,@IdMarca int

AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.[IdPop]
		  ,P.[Nombre]		   
		  ,(case when RP.Cantidad IS NULL then '0' else RP.Cantidad end) as Cantidad
	FROM [Pop] P
	INNER JOIN Pop_Marca PM ON (PM.IdMarca = @IdMarca AND PM.[IdPop] = P.[IdPop])
	LEFT JOIN  R2_ReportePOP RP ON (RP.IdReporte2 = @IdReporte2  AND RP.IdMarca = @IdMarca AND P.[IdPop] = RP.[IdPop])
	ORDER BY P.Nombre
	
END
GO
