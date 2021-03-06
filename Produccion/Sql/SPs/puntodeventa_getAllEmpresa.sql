SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAllEmpresa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAllEmpresa] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAllEmpresa] 
	
	 @IdUsuario int =  NULL
	,@IdEmpresa int
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @IdCliente INT = NULL
	
	SET @IdCliente = (SELECT IdCliente from Cliente Where IdEmpresa = @IdEmpresa)

    -- Insert statements for procedure here
    CREATE TABLE #Table1 (IdUsuario int
						 ,Apellido varchar(200)
						 ,Nombre varchar(200)
						 ,IdPuntoDeVenta int
						 ,CodigoPDV int
						 ,NombrePDV varchar(200)
						 ,Cuit bigint
						 ,RazonSocial varchar(200)
						 ,Direccion varchar(500)
						 ,CodigoPostal varchar(8)
						 ,Telefono varchar(50)
						 ,Email  varchar(50)
  					     ,Contacto varchar(100)
 					     ,TotalGondolas int
					     ,TotalEstantesGondola int
					     ,TotalEstantesInterior int
					     ,TotalEstantesExterior int
					     ,TieneVidriera varchar(50)
    					 ,IdProvincia int
					     ,NombreProvincia varchar(200)
					     ,IdLocalidad int
					     ,NombreLocalidad  varchar(200)
					     ,IdZona int
					     ,NombreZona varchar(200)
					     ,IdCadena int
					     ,NombreCadena varchar(200)
					     ,IdTipo int
					     ,NombreTipo varchar(200)
					     ,IdCategoria int
					     ,NombreCategoria varchar(200)
					     ,IdDimension int
					     ,NombreDimension varchar(200)
					     ,IdPotencial int
					     ,NombrePotencial varchar(200)
					     ,EspacioBacklight int
					     ,CodigoSAP varchar(50)
					     ,CodigoAdicional varchar(50)
						 ,Activo bit
						 ,AuditoriaNoAutorizada bit
						 ,latitud decimal(11,8)
						 ,longitud decimal(11,8)
						 ,idvendedor int
						 ,NombreVendedor varchar(200)
						 ,idequipo int
						 ,NombreEquipo varchar(200))
	INSERT INTO #Table1     
	SELECT 
	   U.IdUsuario AS IdUsuario      
      ,ISNULL(U.[Apellido],'') as Apellido
	  ,ISNULL(U.[Nombre],'') as Nombre
	  ,UPDV.[IdPuntoDeVenta]            
      ,PDV.[Codigo] CodigoPDV
      ,PDV.Nombre NombrePDV
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
       ,CASE PDV.[TieneVidriera]
		WHEN 1 THEN 'SI'
		WHEN 0 THEN 'NO'
		ELSE '' 
		END TieneVidriera
      ,P.IdProvincia
      ,P.Nombre NombreProvincia
      ,PDV.[IdLocalidad]
      ,L.Nombre NombreLocalidad
      ,PDV.[IdZona]
      ,Z.Nombre NombreZona
      ,PDV.[IdCadena]
      ,CAD.Nombre NombreCadena
      ,PDV.[IdTipo]
      ,TIPO.Nombre NombreTipo
      ,PDV.[IdCategoria]
      ,CA.Nombre NombreCategoria
      ,PDV.[IdDimension]
      ,DIM.Nombre NombreDimension
      ,PDV.[IdPotencial]
      ,POT.Nombre NombrePotencial
      ,PDV.[EspacioBacklight]
      ,PDV.[CodigoSAP]
      ,PDV.[CodigoAdicional]                  
      ,UPDV.Activo
      ,PDV.[AuditoriaNoAutorizada]
	  ,PDV.[Latitud]
	  ,PDV.[Longitud]
      --,C.Nombre NombreCliente
	  ,ven.idVendedor
	  ,ven.nombre COLLATE DATABASE_DEFAULT as [NombreVendedor] 
	  ,equi.idEquipo 
	  ,equi.nombre COLLATE DATABASE_DEFAULT  as [NombreEquipo]
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario)
  INNER JOIN UsuarioGrupo UG ON (U.IdUsuario = UG.IdUsuario AND UG.IdGrupo=2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Cliente  C ON (PDV.IdCliente = C.IdCliente)
  LEFT JOIN Localidad L ON (L.IdLocalidad = PDV.IdLocalidad)
  LEFT JOIN Provincia P ON (P.IdProvincia = L.IdProvincia)
  LEFT JOIN Zona Z ON (PDV.IdZona = Z.IdZona)
  LEFT JOIN Categoria CA ON (CA.IdCategoria = PDV.IdCategoria)
  LEFT JOIN Cadena CAD ON (CAD.IdCadena = PDV.[IdCadena])
  LEFT JOIN Tipo TIPO ON (TIPO.IdTipo = PDV.[IdTipo])
  LEFT JOIN Dimension DIM ON (DIM.IdDimension= PDV.[IdDimension])
  LEFT JOIN Potencial POT ON (POT.[IdPotencial] = PDV.[IdPotencial])
  left join puntodeventa_vendedor pdv_v on pdv_v.idPuntodeventa = pdv.idPuntodeventa
  left join vendedor ven on ven.idVendedor = pdv_v.idVendedor
  left join equipo equi on equi.idEquipo = ven.idEquipo
  --INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
  
  --INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = C.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  WHERE (@IdUsuario IS NULL OR  UPDV.IdUsuario = @IdUsuario) AND
		(@IdCliente IS NULL OR C.IdCliente = @IdCliente) 
  ORDER BY ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT, PDV.Nombre
  
  SELECT *
  FROM #Table1     
  WHERE Activo=1
  ORDER BY NombrePDV
  
  
END

GO
