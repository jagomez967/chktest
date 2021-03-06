SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMantenimiento_GetAllReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMantenimiento_GetAllReporte] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMantenimiento_GetAllReporte]
	-- Add the parameters for the stored procedure here
	 @IdReporte int = NULL
	,@IdEmpresa int = NULL
	,@IdMarca int
	,@IdReporteTipo int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MM.[IdMantenimientoMaterial]
		  ,MM.[Nombre]
		  ,(case when RM.IdReporteMantenimiento is null then 'false' else 'true' end) as Estado	     
		  ,ISNULL(RM.IdMantenimientoEstado,1) AS IdMantenimientoEstado
		  ,RM.Observaciones
		  ,RM.IdReporteMantenimiento 
		  ,ISNULL(ME.Estado,'') AS MantenimientoEstado
	FROM [MantenimientoMaterial] MM	 
	INNER JOIN MantenimientoMaterial_Marca MMM ON (MM.[IdMantenimientoMaterial] = MMM.[IdMantenimientoMaterial] AND MMM.IdMarca=@IdMarca)
	LEFT JOIN [ReporteMantenimiento] RM ON (RM.IdReporte = @IdReporte AND RM.IdMarca = @IdMarca AND RM.[IdMantenimientoMaterial] = MM.[IdMantenimientoMaterial] AND RM.IdReporteTipo=@IdReporteTipo)
	LEFT JOIN MantenimientoEstado ME ON (ME.IdMantenimientoEstado = RM.IdMantenimientoEstado)
	

END
GO
