SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_Eliminar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_Eliminar] AS' 
END
GO
ALTER PROCEDURE [dbo].[Reporte_Eliminar] 
	-- Add the parameters for the stored procedure here
	@IdReporte int
	
AS
BEGIN
	SET NOCOUNT ON;

    -- Reporte eliminar Modulo Item
	DELETE FROM [dbo].[MD_ReporteModuloItem]
	FROM [dbo].[MD_ReporteModuloItem]
    WHERE [IdReporte]= @IdReporte


	-- Reporte Capacitacion
     DELETE FROM .[dbo].[ReporteCapacitacion]
	 FROM [dbo].[ReporteCapacitacion]
	 WHERE [IdReporte] = @IdReporte
	 
	 --ReporteExhibicion
  	 DELETE FROM .[dbo].[ReporteExhibicion]
	 FROM [dbo].[ReporteExhibicion]
	 WHERE [IdReporte] = @IdReporte

	 -- ReporteMarcaPropiedad
	  DELETE FROM .[dbo].[ReporteMarcaPropiedad]
	  FROM [dbo].[ReporteMarcaPropiedad]
	  WHERE [IdReporte] = @IdReporte

	  -- ReportePop
	  DELETE FROM .[dbo].[ReportePop]
	  FROM [dbo].[ReportePop]
	  WHERE [IdReporte] = @IdReporte

	 -- ReporteProducto
      DELETE FROM .[dbo].[ReporteProducto]
	  FROM [dbo].[ReporteProducto]
	  WHERE [IdReporte] = @IdReporte

	 -- ReporteProductoCompetencia	 
      DELETE FROM .[dbo].[ReporteProductoCompetencia]
	  FROM [dbo].[ReporteProductoCompetencia]
	  WHERE [IdReporte] = @IdReporte

    -- Reporte
     DELETE FROM .[dbo].[Reporte]
	 FROM [dbo].[Reporte]
	 WHERE [IdReporte] = @IdReporte	

END
GO
