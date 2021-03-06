SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Update] AS' 
END
GO
-- =============================================
-- Author:		@Author,,Name>
-- Create date: @Create Date,,>
-- Description:	@Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Update]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int 
   ,@Codigo int
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
   ,@IdCliente INT = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
   UPDATE [dbo].[PuntoDeVenta]
   SET [Nombre] = @Nombre
      ,[Cuit] = @Cuit
      ,[RazonSocial] = @RazonSocial
      ,[Direccion] = @Direccion
      ,[CodigoPostal] = @CodigoPostal
      ,[Telefono] = @Telefono
      ,[Email] = @Email
      ,[Contacto] = @Contacto
      ,[TotalGondolas] = @TotalGondolas
      ,[TotalEstantesGondola] = @TotalEstantesGondola
      ,[TotalEstantesInterior] = @TotalEstantesInterior 
      ,[TotalEstantesExterior] = @TotalEstantesExterior 
      ,[TieneVidriera] = @TieneVidriera 
      ,[IdLocalidad] = @IdLocalidad 
      ,[IdZona] = @IdZona 
      ,[IdCadena] = @IdCadena 
      ,[IdTipo] = @IdTipo 
      ,[IdCategoria] = @IdCategoria 
      ,[IdDimension] = @IdDimension 
      ,[IdPotencial] = @IdPotencial 
      ,[EspacioBacklight] = @EspacioBacklight 
      ,[CodigoSAP] = @CodigoSAP
      ,[CodigoAdicional] = @CodigoAdicional
      ,[Latitud] = @Latitud
      ,[Longitud] = @Longitud
      ,[AuditoriaNoAutorizada] = @AuditoriaNoAutorizada
      ,[IdCliente] = @IdCliente
 WHERE [IdPuntoDeVenta] = @IdPuntoDeVenta

END
GO
