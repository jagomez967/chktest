SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubMarcaProducto_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SubMarcaProducto_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[SubMarcaProducto_GetAll]
	@IdSubMarca int = NULL
   ,@IdMarca int = NULL
   ,@IdProducto int = NULL 
AS
BEGIN
	SET NOCOUNT ON;
	
SELECT DISTINCT 
		   M.[IdSubMarca],
		   M.[IdProducto],
		   P.[IdMarca]
	 FROM [dbo].[SubMarca_Producto] M
	 INNER JOIN Producto P on P.IdProducto = M.IdProducto
	 WHERE (@IdSubMarca IS NULL OR M.[IdSubMarca] = @IdSubMarca) AND
		   (@IdMarca IS NULL OR P.[IdMarca] = @IdMarca) AND
		   (@IdProducto IS NULL OR M.IdProducto = @IdProducto)	 
END
GO
