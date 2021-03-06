SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_GetAll]
	
	 @IdProducto int = NULL
	,@Nombre varchar(255) = NULL
	,@IdSistema int =  NULL
	,@IdMarca int =  NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.[IdProducto]
		  ,P.[Codigo]
		  ,P.[CodigoEAN]
		  ,P.[CodigoSAP]
		  ,P.[Nombre]
		  ,P.[IdMarca]
		  ,M.Nombre AS MarcaNombre
		  ,P.[Orden]
		  ,P.[IdSistema]
		  ,S.Nombre SistemaNombre
		  ,P.[IdCategoria]
		  ,C.Nombre AS CategoriaNombre
		  ,P.[Activo]
  FROM [dbo].[CD_Producto] P
  LEFT JOIN Sistema S ON (S.IdSistema = P.IdSistema)  
  LEFT JOIN CD_Categoria C ON (C.IdCategoria = P.IdCategoria)  
  LEFT JOIN CD_Marca M ON (M.IdMarca = P.IdMarca)  
  WHERE (@IdProducto  IS NULL OR @IdProducto = P.IdProducto) AND
        (@Nombre IS NULL OR P.[Nombre] like '%' + @Nombre + '%') AND
	    (@IdSistema  IS NULL OR @IdSistema = P.IdSistema) AND
	    (@IdMarca  IS NULL OR @IdMarca = P.IdMarca)
  ORDER BY M.Nombre, P.[Nombre]
	    
END
GO
