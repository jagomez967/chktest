SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_DeleteMasivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_DeleteMasivo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_DeleteMasivo]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Mosificar los parametros antes de usar. 
DECLARE @IdReporte int

DECLARE	@return_value int

DECLARE reporte_delete_cursor CURSOR FOR
--Esta tabla despues cambiarla 
SELECT  [IdReporte]      
FROM [dbo].[Reporte] R
WHERE (R.IdEmpresa = 1)
--Fin tabla

OPEN reporte_delete_cursor

FETCH NEXT FROM reporte_delete_cursor
INTO  @IdReporte

WHILE @@FETCH_STATUS = 0
BEGIN

    
EXEC	@return_value = [dbo].[ReporteCapacitacion_Delete]
		@IdReporte = @IdReporte

EXEC	@return_value = [dbo].[ReporteExhibicion_Delete]
		@IdReporte = @IdReporte   

EXEC	@return_value = [dbo].[ReporteMarcaPropiedad_Delete]
		@IdReporte = @IdReporte   

EXEC	@return_value = [dbo].[ReportePop_Delete]
		@IdReporte = @IdReporte   

EXEC	@return_value = [dbo].[ReporteProducto_Delete]
		@IdReporte = @IdReporte   

EXEC	@return_value = [dbo].[ReporteProductoCompetencia_Delete]
		@IdReporte = @IdReporte   

EXEC	@return_value = [dbo].[Reporte_Delete]
		@IdReporte = @IdReporte   
		
FETCH NEXT FROM reporte_delete_cursor
INTO  @IdReporte
END 

CLOSE reporte_delete_cursor;
DEALLOCATE reporte_delete_cursor;


END
GO
