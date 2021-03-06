SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_Add]
	
    @Codigo varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@Direccion varchar(255) = NULL
   ,@IdCadena int = NULL  
   ,@IdRegion int = NULL
   ,@Activo bit = NULL
   ,@IdPuntoDeVenta int output
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_PuntoDeVenta]
           ([Codigo]
           ,[Nombre]
           ,[Direccion]
           ,[IdCadena]           
           ,[IdRegion]           
           ,[Activo])
     VALUES
           (@Codigo
           ,@Nombre
           ,@Direccion
           ,@IdCadena           
           ,@IdRegion
           ,@Activo)
           
     SET @IdPuntoDeVenta = @@IDENTITY
END
GO
