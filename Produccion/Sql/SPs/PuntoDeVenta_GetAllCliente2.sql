SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAllCliente2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente2] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente2] 
	 
	@IdCliente int
   ,@IdUsuario INT = NULL
	
AS
BEGIN
	
  SET NOCOUNT ON;



  IF (@IdUsuario IS NOT NULL)
  BEGIN
  SELECT DISTINCT PDV.[IdPuntoDeVenta]
		  ,PDV.[Codigo]
		  ,PDV.[Nombre]
		  ,PDV.[Cuit]
		  ,PDV.[RazonSocial]
		  ,PDV.[Direccion]
		  ,PDV.[CodigoPostal]
		  ,PDV.[Telefono]
		  ,PDV.[Email]
		  ,PDV.[Contacto]
		  ,PDV.[TotalGondolas]
		  ,PDV.[TotalEstantesGondola]
		  ,PDV.[TotalEstantesInterior]
		  ,PDV.[TotalEstantesExterior]
		  ,PDV.[TieneVidriera]
		  ,PDV.[IdLocalidad]
		  ,PDV.[IdZona]
		  ,PDV.[IdCadena]
		  ,PDV.[IdTipo]
		  ,PDV.[IdCategoria]
		  ,PDV.[IdDimension]
		  ,PDV.[IdPotencial]
		  ,PDV.[EspacioBacklight]
		  ,PDV.[CodigoSAP]
		  ,PDV.[CodigoAdicional]
		  ,PDV.[Latitud]
		  ,PDV.[Longitud]
		  ,PDV.[AuditoriaNoAutorizada]
		  ,L.Nombre AS Localidad
		  ,P.Nombre As Provincia
		  ,Z.Nombre As Zona
		  ,	stuff((	select ',' + cast(pP.idProducto as varchar)
			from producto_Puntodeventa pp			---cuando se vuelva grande ponele un indice 
			where pp.idPuntodeventa = pdv.idPuntoDeVenta 
				For XML PATH('')
			),1,1,'') [Productos]
  FROM dbo.PuntoDeVenta PDV
  INNER JOIN Usuario_PuntoDeVenta UPDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
  LEFT JOIN [dbo].[Provincia] P ON (P.[IdProvincia] = L.[IdProvincia])
  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
  WHERE (PDV.IdCliente = @IdCliente) AND
		(@IdUsuario IS NULL OR  UPDV.IdUsuario = @IdUsuario) AND
		UPDV.Activo = 1
		order by PDV.Nombre desc
  
END
ELSE
BEGIN
	SELECT DISTINCT PDV.[IdPuntoDeVenta]
		  ,PDV.[Codigo]
		  ,C.Nombre + '-' + PDV.[Nombre] AS Nombre
		  ,PDV.[Cuit]
		  ,PDV.[RazonSocial]
		  ,PDV.[Direccion]
		  ,PDV.[CodigoPostal]
		  ,PDV.[Telefono]
		  ,PDV.[Email]
		  ,PDV.[Contacto]
		  ,PDV.[TotalGondolas]
		  ,PDV.[TotalEstantesGondola]
		  ,PDV.[TotalEstantesInterior]
		  ,PDV.[TotalEstantesExterior]
		  ,PDV.[TieneVidriera]
		  ,PDV.[IdLocalidad]
		  ,PDV.[IdZona]
		  ,PDV.[IdCadena]
		  ,PDV.[IdTipo]
		  ,PDV.[IdCategoria]
		  ,PDV.[IdDimension]
		  ,PDV.[IdPotencial]
		  ,PDV.[EspacioBacklight]
		  ,PDV.[CodigoSAP]
		  ,PDV.[CodigoAdicional]
		  ,PDV.[Latitud]
		  ,PDV.[Longitud]
		  ,PDV.[AuditoriaNoAutorizada]
		  ,L.Nombre AS Localidad
		  ,P.Nombre As Provincia
		  ,Z.Nombre As Zona
		  ,
			stuff((	select ',' + cast(pP.idProducto as varchar)
			from producto_Puntodeventa pp			---cuando se vuelva grande ponele un indice 
			where pp.idPuntodeventa = pdv.idPuntoDeVenta 
				For XML PATH('')
			),1,1,'') [Productos]
  FROM dbo.PuntoDeVenta PDV
  INNER JOIN Usuario_PuntoDeVenta UPDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Cliente C ON C.IdCliente = @IdCliente
  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
  LEFT JOIN [dbo].[Provincia] P ON (P.[IdProvincia] = L.[IdProvincia])
  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
  WHERE (PDV.IdCliente = @IdCliente) AND
		(@IdUsuario IS NULL OR  UPDV.IdUsuario = @IdUsuario) AND
		UPDV.Activo = 1
	order by C.Nombre + '-' + PDV.[Nombre] desc
END
END

GO
