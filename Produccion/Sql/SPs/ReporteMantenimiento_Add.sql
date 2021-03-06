SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMantenimiento_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMantenimiento_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMantenimiento_Add]
	-- Add the parameters for the stored procedure here
    @IdReporte int
   ,@IdMarca int
   ,@IdEmpresa int
   ,@IdPuntoDeVenta int
   ,@IdMantenimientoMaterial int
   ,@IdMantenimientoEstado int
   ,@IdUsuarioMantenimiento int = NULL
   ,@IdUsuarioCarga int
   ,@FechaCreacion datetime
   ,@FechaActualizacion datetime =  NULL
   ,@FechaUltimoEstado datetime =  NULL
   ,@Observaciones varchar(200) =  NULL
   ,@ObservacionesMantenimiento varchar(max) = NULL
   ,@IdReporteTipo int = NULL 
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ReporteMantenimiento]
           ([IdReporte]
           ,[IdMarca]
           ,[IdEmpresa]
           ,[IdPuntoDeVenta]
           ,[IdMantenimientoMaterial]
           ,[IdMantenimientoEstado]
           ,[IdUsuarioCarga]
           ,[IdUsuarioMantenimiento]
           ,[FechaCreacion]
           ,[FechaActualizacion]
           ,[FechaUltimoEstado]
           ,[Observaciones]
           ,[ObservacionesMantenimiento]
           ,[IdReporteTipo])
     VALUES
           (@IdReporte
           ,@IdMarca
           ,@IdEmpresa
		   ,@IdPuntoDeVenta
           ,@IdMantenimientoMaterial
           ,@IdMantenimientoEstado
           ,@IdUsuarioCarga
           ,@IdUsuarioMantenimiento
           ,@FechaCreacion
           ,@FechaCreacion
           ,@FechaCreacion
           ,@Observaciones
           ,@ObservacionesMantenimiento
           ,@IdReporteTipo)

END
GO
