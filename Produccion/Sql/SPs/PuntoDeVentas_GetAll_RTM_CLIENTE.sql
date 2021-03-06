SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentas_GetAll_RTM_CLIENTE]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentas_GetAll_RTM_CLIENTE] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentas_GetAll_RTM_CLIENTE] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM
	(SELECT 
	    U.IdUsuario AS IdUsuario      
      ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As UsuarioApellidoNombre
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
      ,dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(C.IdCliente,UPDV.[IdPuntoDeVenta],U.IdUsuario) AS Activo
      ,PDV.[AuditoriaNoAutorizada]
      ,PDV.[Latitud]
      ,PDV.[Longitud]
      ,C.IdCliente 
      ,C.Nombre AS NombreCliente
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario)
  INNER JOIN UsuarioGrupo UG ON (U.IdUsuario = UG.IdUsuario AND UG.IdGrupo=2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  LEFT JOIN Localidad L ON (L.IdLocalidad = PDV.IdLocalidad)
  LEFT JOIN Provincia P ON (P.IdProvincia = L.IdProvincia)
  LEFT JOIN Zona Z ON (PDV.IdZona = Z.IdZona)
  LEFT JOIN Categoria CA ON (CA.IdCategoria = PDV.IdCategoria)
  LEFT JOIN Cadena CAD ON (CAD.IdCadena = PDV.[IdCadena])
  LEFT JOIN Tipo TIPO ON (TIPO.IdTipo = PDV.[IdTipo])
  LEFT JOIN Dimension DIM ON (DIM.IdDimension= PDV.[IdDimension])
  LEFT JOIN Potencial POT ON (POT.[IdPotencial] = PDV.[IdPotencial])
  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
  INNER JOIN Cliente  C ON (UC.IdCliente = C.IdCliente)
  INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = C.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)) X
  WHERE X.Activo = 1
    
END
GO
