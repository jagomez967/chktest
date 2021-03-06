SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_Update]
    
    @IdProducto int 
   ,@Codigo varchar(50) = NULL
   ,@CodigoEAN varchar(50) = NULL
   ,@CodigoSAP varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@IdMarca int = NULL
   ,@Orden int = NULL
   ,@IdSistema int = NULL
   ,@IdCategoria int = NULL
   ,@Activo bit = NULL
   
   
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [dbo].[CD_Producto]
   SET [Codigo] = @Codigo
      ,[CodigoEAN] = @CodigoEAN
      ,[CodigoSAP] = @CodigoSAP
      ,[Nombre] = @Nombre
      ,[IdMarca] = @IdMarca
      ,[Orden] = @Orden
      ,[IdSistema] = @IdSistema
      ,[IdCategoria] = @IdCategoria
      ,[Activo] = @Activo
 WHERE @IdProducto =[IdProducto]

END
GO
