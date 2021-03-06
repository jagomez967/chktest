SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransferCabecera_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransferCabecera_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteTransferCabecera_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int
	,@IdReporteTransferCabecera int = NULL
	,@IdUsuario int = NULL
	,@IdPuntoDeVenta int = NULL
	,@FechaDesde datetime = NULL
	,@FechaHasta DateTime = NULL
	  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
	SELECT R.[IdReporteTransferCabecera]
		  ,R.[IdPuntoDeVenta]
	      ,R.[IdUsuario]
		  ,R.[FechaCreacion]
		  ,R.[IdEmpresa]
		  ,PDV.Nombre As PDVNombre
		  ,PDV.Direccion 
		  ,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT AS UsuarioNombre
		  ,Z.Nombre AS ZonaNombre
	FROM [dbo].[ReporteTransferCabecera] R
	INNER JOIN PuntoDeVenta PDV ON (PDV.[IdPuntoDeVenta] = R.[IdPuntoDeVenta])
	INNER JOIN Zona Z ON (PDV.[IdZona] = Z.[IdZona])
	INNER JOIN Usuario U ON (U.[IdUsuario] = R.[IdUsuario])
	WHERE(@IdEmpresa = R.[IdEmpresa]) AND
		 (@IdReporteTransferCabecera IS NULL OR @IdReporteTransferCabecera = R.[IdReporteTransferCabecera]) AND
		 (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = R.[IdPuntoDeVenta]) AND
		 (@IdUsuario IS NULL OR @IdUsuario = R.[IdUsuario])  AND
		 (@FechaDesde IS NULL OR  CONVERT(varchar(8), R.[FechaCreacion], 112)  between CONVERT(varchar(8), @FechaDesde, 112)   AND CONVERT(varchar(8), @FechaHasta, 112)) 
	ORDER BY R.[IdReporteTransferCabecera] DESC
	 
END
GO
