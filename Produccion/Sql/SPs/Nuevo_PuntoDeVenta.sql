SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Nuevo_PuntoDeVenta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Nuevo_PuntoDeVenta] AS' 
END
GO
ALTER PROCEDURE [dbo].[Nuevo_PuntoDeVenta]
	-- Add the parameters for the stored procedure here
    @Codigo int
   ,@Nombre varchar(200)
   ,@Cuit bigint = NULL
   ,@RazonSocial varchar(200) = NULL
   ,@Direccion varchar(500) = NULL
   ,@CodigoPostal varchar(8) = NULL
   ,@Telefono varchar(50) = NULL
   ,@Email varchar(50) = NULL
   ,@Contacto varchar(100) = NULL
   ,@TotalGondolas int = NULL
   ,@TotalEstantesGondola int = NULL
   ,@TotalEstantesInterior int = NULL
   ,@TotalEstantesExterior int = NULL
   ,@TieneVidriera bit = NULL
   ,@IdLocalidad int = NULL
   ,@IdZona int = NULL
   ,@IdCadena int = NULL
   ,@IdTipo int = NULL
   ,@IdCategoria int = NULL
   ,@IdDimension int = NULL
   ,@IdPotencial int = NULL
   ,@EspacioBacklight int = NULL
   ,@CodigoSAP varchar(50) = NULL
   ,@CodigoAdicional varchar(50) = NULL
   ,@Latitud decimal(11,8) = NULL
   ,@Longitud decimal(11,8) = NULL
   ,@AuditoriaNoAutorizada bit =  NULL
   ,@New bit = NULL
   ,@DataMigrationId int = NULL
   ,@DataMigrationId2 int = NULL
   ,@IdCliente int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT @Codigo = MAX([Codigo])  FROM [dbo].[PuntoDeVenta]
	
	SET @Codigo = @Codigo + 1
	
    -- Insert statements for procedure here
	INSERT INTO [dbo].[PuntoDeVenta]
           ([Codigo]
           ,[Nombre]
           ,[Cuit]
           ,[RazonSocial]
           ,[Direccion]
           ,[CodigoPostal]
           ,[Telefono]
           ,[Email]
           ,[Contacto]
           ,[TotalGondolas]
           ,[TotalEstantesGondola]
           ,[TotalEstantesInterior]
           ,[TotalEstantesExterior]
           ,[TieneVidriera]
           ,[IdLocalidad]
           ,[IdZona]
           ,[IdCadena]
           ,[IdTipo]
           ,[IdCategoria]
           ,[IdDimension]
           ,[IdPotencial]
           ,[EspacioBacklight]
           ,[CodigoSAP]
           ,[CodigoAdicional]
           ,[Latitud]
           ,[Longitud]
           ,[AuditoriaNoAutorizada]
		   ,[New]
		   ,[DataMigrationId]
		   ,[DataMigrationId2]
		   ,[IdCliente])
     VALUES
           (@Codigo
           ,@Nombre
           ,@Cuit
           ,@RazonSocial
           ,@Direccion
           ,@CodigoPostal
           ,@Telefono
           ,@Email
           ,@Contacto
           ,@TotalGondolas
           ,@TotalEstantesGondola
           ,@TotalEstantesInterior
           ,@TotalEstantesExterior
           ,@TieneVidriera
           ,@IdLocalidad
           ,@IdZona
           ,@IdCadena
           ,@IdTipo
           ,@IdCategoria
           ,@IdDimension
           ,@IdPotencial
           ,@EspacioBacklight
           ,@CodigoSAP
           ,@CodigoAdicional
           ,@Latitud
           ,@Longitud
           ,@AuditoriaNoAutorizada
		   ,@New
		   ,@DataMigrationId
		   ,@DataMigrationId2
		   ,@IdCliente)

END

GO
