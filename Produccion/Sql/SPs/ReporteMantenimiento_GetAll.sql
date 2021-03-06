SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMantenimiento_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMantenimiento_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMantenimiento_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int
	,@IdReporteMantenimiento int = NULL	
	,@FechaDesde DateTime = NULL
	,@FechaHasta DateTime = NULL
	,@IdPuntoDeVenta int = NULL
	,@IdMantenimientoEstado int = NULL
	,@IdZona int = NULL
	,@IdMaterial int = NULL
	,@IdUsuario int =  NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT RM.[IdReporteMantenimiento]
	      ,RM.[IdReporte]
		  ,RM.[IdPuntoDeVenta]
		  ,RM.[IdMarca]
		  ,RM.[IdMantenimientoMaterial]
		  ,RM.[IdMantenimientoEstado]
		  ,RM.[FechaCreacion]
		  ,RM.[FechaUltimoEstado]
		  ,RM.[Observaciones]
		  ,RM.[ObservacionesMantenimiento]
		  ,PDV.Nombre AS PDVNombre
		  ,PDV.Direccion
		  ,PDV.[IdLocalidad]
		  ,L.Nombre AS LocallidadNombre
		  ,Z.Nombre As ZonaNombre
		  ,M.Nombre AS MarcaNombre
		  ,MM.Nombre AS MaterialNombre
		  ,ME.Estado
		  ,U.IdUsuario AS UsuarioCargaId
		  ,ISNULL(U.Nombre,'') AS UsuarioCargaNombre
		  ,ISNULL(U.Apellido,'') AS UsuarioCargaApellido
	  FROM [dbo].[ReporteMantenimiento] RM
	  INNER JOIN [Empresa] E ON (E.[IdEmpresa] = RM.[IdEmpresa] AND RM.[IdEmpresa]=@IdEmpresa)
	  INNER JOIN [PuntoDeVenta] PDV ON (PDV.[IdPuntoDeVenta]=RM.[IdPuntoDeVenta])
	  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
	  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
	  LEFT JOIN [dbo].[Usuario] U ON (RM.IdUsuarioCarga = U.IdUsuario)
	  INNER JOIN [MantenimientoMaterial] MM	 ON (MM.[IdMantenimientoMaterial] = RM.[IdMantenimientoMaterial])
	  INNER JOIN [Marca] M	ON (RM.[IdMarca] = M.[IdMarca])
	  INNER JOIN [MantenimientoEstado] ME ON (ME.[IdMantenimientoEstado] = RM.[IdMantenimientoEstado])
	  WHERE (RM.[IdEmpresa]=@IdEmpresa) AND
	        (@IdReporteMantenimiento IS NULL OR @IdReporteMantenimiento = RM.[IdReporteMantenimiento]) AND
	        (@IdPuntoDeVenta IS NULL OR RM.[IdPuntoDeVenta] = @IdPuntoDeVenta) AND
	        (@FechaDesde IS NULL OR (RM.[FechaCreacion] between @FechaDesde AND @FechaHasta)) AND
	        (@IdMantenimientoEstado IS NULL OR RM.[IdMantenimientoEstado] = @IdMantenimientoEstado) AND
	        (@IdZona IS NULL OR  @IdZona = PDV.[IdZona]) AND
	        (@IdMaterial IS NULL OR @IdMaterial = MM.[IdMantenimientoMaterial]) AND
	        (@IdUsuario IS NULL OR @IdUsuario = RM.IdUsuarioCarga)
	  ORDER BY ME.Orden, RM.[FechaCreacion]
	  
END
GO
