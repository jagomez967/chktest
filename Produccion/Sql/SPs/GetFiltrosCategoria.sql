SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosCategoria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosCategoria] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltrosCategoria]
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

	SELECT max(c.idCategoria) AS IdItem
		,c.nombre AS Descripcion
	FROM categoria c
	INNER JOIN empresa e ON e.idNegocio = c.idNegocio
	INNER JOIN cliente cl ON cl.idEmpresa = e.idEmpresa
	WHERE cl.idCliente IN(SELECT idCLiente from #clientes)
	AND  (isnull(@texto,'') = '' or c.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY c.nombre
	ORDER BY c.nombre

	SET ROWCOUNT 0
END
GO
