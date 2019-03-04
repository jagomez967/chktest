SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosSubCategoria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosSubCategoria] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosSubCategoria]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	CREATE TABLE #Clientes (idCliente INT)
	INSERT #clientes (idCliente)
	SELECT fc.idCliente
	FROM familiaClientes fc
	WHERE fc.familia IN (
			SELECT familia
			FROM familiaClientes
			WHERE idCliente = @idCLiente
				AND activo = 1
			) 
	
	IF @@rowcount = 0
	BEGIN
		INSERT #clientes (idCliente)
		values( @IdCliente)
	END

	SET ROWCOUNT @Top

	SELECT MAX(t.idSubcategoria) as idItem,
		   t.Nombre  as Descripcion
	from subCategoria t
	where t.idCliente in (select idCliente from #Clientes) 
	and  (isnull(@texto,'') = '' or t.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY t.Nombre
	ORDER BY t.Nombre
	SET ROWCOUNT 0
END

GO
