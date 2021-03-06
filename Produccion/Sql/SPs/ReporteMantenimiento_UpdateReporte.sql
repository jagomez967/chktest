SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMantenimiento_UpdateReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMantenimiento_UpdateReporte] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMantenimiento_UpdateReporte]
	-- Add the parameters for the stored procedure here
	 @IdReporteMantenimiento int	
	,@IdMantenimientoEstado  int
	,@FechaUltimoEstado Datetime = NULL
	,@IdReporteTipo int = NULL
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE [dbo].[ReporteMantenimiento]
	   SET [IdMantenimientoEstado] = @IdMantenimientoEstado  
		  ,[FechaUltimoEstado] = GETDATE()		  
	 WHERE [IdReporteMantenimiento] = @IdReporteMantenimiento AND 
	        @IdReporteTipo = [IdReporteTipo]

END
GO
