CREATE PROCEDURE GetFiltrosCategoriaProducto
(  
 @IdCliente int,
 @Top int = 0,
 @texto varchar(max)=''
)  
AS
BEGIN  
	
	SET ROWCOUNT @Top
	
	SELECT PC.[Id] AS IdItem
	,PC.[Nombre] AS Descripcion
	FROM [dbo].[ProductoCategoria] PC
	INNER JOIN Producto P ON (P.IdCategoria = PC.[Id])
	INNER JOIN Marca M ON (M.IdMarca = P.IdMarca)
	INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
	INNER JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa)
	WHERE C.IdCliente = @IdCliente
	AND  (isnull(@texto,'') = '' or PC.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY PC.[Id]
		,PC.[Nombre]
	ORDER BY PC.[Nombre]

   SET ROWCOUNT 0

END