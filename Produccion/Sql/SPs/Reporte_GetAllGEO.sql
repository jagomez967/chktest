SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_GetAllGEO]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_GetAllGEO] AS' 
END
GO
ALTER PROCEDURE [dbo].[Reporte_GetAllGEO]	
	 @IdEmpresa int
	,@IdReporte int = NULL
	,@IdUsuario int = NULL
	,@IdPuntoDeVenta int = NULL
	,@FechaDesde datetime = NULL
	,@FechaHasta DateTime = NULL

		  	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT R.[IdUsuario]
		  ,ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'') COLLATE DATABASE_DEFAULT AS UsuarioNombre
	      ,R.[IdReporte]
		  ,R.Latitud
		  ,R.Longitud
		  ,CONVERT(DATETIME,R.[FechaCreacion],120) AS FechaCreacion
		  ,R.[IdPuntoDeVenta]	      
		  ,PDV.Nombre As PDVNombre
		  ,PDV.Direccion
		  ,PDV.Latitud AS PDVLatitud
		  ,PDV.Longitud AS PDVlongitud 		  
		  ,Z.Nombre AS ZonaNombre
		  

	FROM [dbo].[Reporte] R
	INNER JOIN PuntoDeVenta PDV ON (PDV.[IdPuntoDeVenta] = R.[IdPuntoDeVenta])
	INNER JOIN Zona Z ON (PDV.[IdZona] = Z.[IdZona])
	INNER JOIN Usuario U ON (U.[IdUsuario] = R.[IdUsuario])
	WHERE(@IdEmpresa = R.[IdEmpresa]) AND
		 (@IdReporte IS NULL OR @IdReporte = R.[IdReporte]) AND
		 (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = R.[IdPuntoDeVenta]) AND
		 (@IdUsuario IS NULL OR @IdUsuario = R.[IdUsuario])  AND
		 (@FechaDesde IS NULL OR  CONVERT(varchar(8), R.[FechaCreacion], 112)  between CONVERT(varchar(8), @FechaDesde, 112)  AND CONVERT(varchar(8), @FechaHasta, 112))
	ORDER BY UsuarioNombre, R.[FechaCreacion]
			 
END
GO
