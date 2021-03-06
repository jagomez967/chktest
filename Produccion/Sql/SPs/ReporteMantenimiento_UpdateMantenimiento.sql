SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMantenimiento_UpdateMantenimiento]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMantenimiento_UpdateMantenimiento] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMantenimiento_UpdateMantenimiento]
	-- Add the parameters for the stored procedure here
	 @IdReporteMantenimiento int
	,@IdUsuarioMantenimiento int
	,@IdMantenimientoEstado  int
	,@FechaUltimoEstado Datetime
	,@ObservacionesMantenimiento varchar(max)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE [dbo].[ReporteMantenimiento]
	   SET [IdUsuarioMantenimiento] = @IdUsuarioMantenimiento
	      ,[IdMantenimientoEstado] = @IdMantenimientoEstado  
		  ,[FechaUltimoEstado] = @FechaUltimoEstado
		  ,[ObservacionesMantenimiento] = @ObservacionesMantenimiento
	 WHERE [IdReporteMantenimiento] = @IdReporteMantenimiento

END
GO
