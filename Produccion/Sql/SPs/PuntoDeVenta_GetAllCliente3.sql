SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAllCliente3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente3] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente3] 
	 
	 @IdPuntoDeVenta int = NULL
	,@Codigo int = NULL
	,@Nombre varchar(200) = NULL
	,@Direccion varchar(500) = NULL
	,@IdLocalidad int = NULL
	,@IdZona int = NULL
	,@IdCliente int = NULL
	,@IdUsuario int = NULL
	
AS
BEGIN
	
  SET NOCOUNT ON;

  --SELECT UPDV.[IdPuntoDeVenta]                    
  --      ,CAST(PDV.[IdPuntoDeVenta] AS nvarchar(10)) + ' - ' + ISNULL(PDV.[Nombre],'') + ' - ' + ISNULL(PDV.[Direccion],'') COLLATE DATABASE_DEFAULT  As CodigoNombreDireccion
  --FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  --INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario)
  --INNER JOIN UsuarioGrupo UG ON (U.IdUsuario = UG.IdUsuario AND UG.IdGrupo=2)
  --INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  --INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario AND UC.IdCliente=@IdCliente)  
  --INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = UC.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  --WHERE  dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(UC.IdCliente,UPDV.[IdPuntoDeVenta],U.IdUsuario)=1
  --GROUP BY UPDV.[IdPuntoDeVenta],PDV.[IdPuntoDeVenta],PDV.Nombre,PDV.[Direccion]
  --ORDER BY UPDV.[IdPuntoDeVenta]
  
  SELECT distinct PDV.[IdPuntoDeVenta]
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
  FROM dbo.PuntoDeVenta PDV
  --LEFT JOIN Usuario_PuntoDeVenta UPDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
  LEFT JOIN [dbo].[Provincia] P ON (P.[IdProvincia] = L.[IdProvincia])
  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
  WHERE		(@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.[IdPuntoDeVenta]) AND
			(@Codigo IS NULL OR @Codigo = PDV.[Codigo]) AND
			(@Nombre IS NULL OR PDV.[Nombre] like '%'+ @Nombre +'%') AND
			(@Direccion IS NULL OR PDV.[Direccion] like '%'+ @Direccion +'%') AND
			(@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
			(@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
			(@IdUsuario IS NULL OR (EXISTS (SELECT UPDV.[Id] FROM [Usuario_PuntoDeVenta] UPDV WHERE PDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta]  AND UPDV.[IdUsuario] = @IdUsuario))) AND
			(PDV.IdCliente = @IdCliente) --AND
		--(@IdUsuario IS NULL OR  UPDV.IdUsuario = @IdUsuario) 
  
END
GO
