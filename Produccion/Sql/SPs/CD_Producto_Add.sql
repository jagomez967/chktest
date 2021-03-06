SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_Add]
	
    @Codigo varchar(50) = NULL
   ,@CodigoEAN varchar(50) = NULL
   ,@CodigoSAP varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@IdMarca int = NULL
   ,@Orden int = NULL
   ,@IdSistema int = NULL
   ,@IdCategoria int = NULL
   ,@Activo bit = NULL
   ,@IdProducto int output
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_Producto]
           ([Codigo]
           ,[CodigoEAN]
           ,[CodigoSAP]
           ,[Nombre]
           ,[IdMarca]
           ,[Orden]
           ,[IdSistema]
           ,[IdCategoria]
           ,[Activo])
     VALUES
           (@Codigo
           ,@CodigoEAN
           ,@CodigoSAP
           ,@Nombre
           ,@IdMarca
           ,@Orden
           ,@IdSistema
           ,@IdCategoria
           ,@Activo)

	SET @IdProducto=@@IDENTITY 

END
GO
