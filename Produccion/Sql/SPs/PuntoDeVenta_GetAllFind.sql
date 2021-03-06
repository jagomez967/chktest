SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAllFind]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAllFind] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAllFind]
	-- Add the parameters for the stored procedure here
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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PDV.[IdPuntoDeVenta]
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
  FROM [dbo].[PuntoDeVenta] PDV
  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
  LEFT JOIN [dbo].[Provincia] P ON (P.[IdProvincia] = L.[IdProvincia])
  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
  WHERE (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.[IdPuntoDeVenta]) AND
		(@Codigo IS NULL OR @Codigo = PDV.[Codigo]) AND
	    (@Nombre IS NULL OR PDV.[Nombre] like '%'+ @Nombre +'%') AND
	    (@Direccion IS NULL OR PDV.[Direccion] like '%'+ @Direccion +'%') AND
	    (@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
	    (@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
	    (@IdCliente IS NULL OR (EXISTS (SELECT CPDV.[Id] FROM [Cliente_PuntoDeVenta] CPDV WHERE PDV.[IdPuntoDeVenta] = CPDV.[IdPuntoDeVenta]  AND CPDV.[IdCliente] = @IdCliente))) AND
	    (@IdUsuario IS NULL OR (EXISTS (SELECT UPDV.[Id] FROM [Usuario_PuntoDeVenta] UPDV WHERE PDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta]  AND UPDV.[IdUsuario] = @IdUsuario)))
	    --Falta Cliente y Usuario
END
GO
