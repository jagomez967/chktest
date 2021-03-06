SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdPuntoDeVenta int = NULL
	,@Nombre varchar(200) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
		  ,PDV.[IdCliente]
		  ,L.Nombre AS Localidad
		  ,P.Nombre As Provincia
		  ,Z.Nombre As Zona
		  ,ISNULL(CONVERT(varchar(50),PDV.[IdPuntoDeVenta]),'') + ' - ' + ISNULL(PDV.[Nombre],'') + ' - ' + ISNULL(PDV.[Direccion],'') COLLATE DATABASE_DEFAULT  As IdNombreDireccion
  FROM [dbo].[PuntoDeVenta] PDV
  LEFT JOIN [dbo].[Localidad] L ON (L.[IdLocalidad] = PDV.[IdLocalidad])
  LEFT JOIN [dbo].[Provincia] P ON (P.[IdProvincia] = L.[IdProvincia])
  LEFT JOIN [dbo].[Zona] Z ON (Z.[IdZona] = PDV.[IdZona])
  WHERE (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.[IdPuntoDeVenta]) AND
	    (@Nombre IS NULL OR PDV.[Nombre] like '%'+ @Nombre +'%')

END
GO
