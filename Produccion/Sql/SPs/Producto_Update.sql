SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[Producto_Update]
	@IdMarca int
	,@Nombre varchar(100)
	,@Reporte bit
	,@GenericoPorMarca bit
	,@IdProducto int 
	,@IdFamilia int=null
	,@CodigoBarras varchar(100)=null
	,@Orden int = null
AS
BEGIN

	SET NOCOUNT ON;
    
    UPDATE [dbo].[Producto]
    SET [IdMarca] = @IdMarca
       ,[Nombre] = @Nombre
       ,[Reporte] = @Reporte
       ,[GenericoPorMarca] = @GenericoPorMarca
	   ,[IdFamilia] = @IdFamilia
	   ,[CodigoBarras] = @CodigoBarras
	   ,[Orden] = @Orden 
	 WHERE @IdProducto = [IdProducto]
	
END


GO
