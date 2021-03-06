SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosMarcas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosMarcas] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosMarcas]
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

	SELECT MAX(m.idMarca) AS IdItem
		,ltrim(rtrim(m.nombre)) AS Descripcion
	FROM Marca m
	INNER JOIN Empresa e ON e.IdEmpresa = m.IdEmpresa
	INNER JOIN cliente c ON c.IdEmpresa = e.IdEmpresa
	WHERE c.IdCliente in(SELECT idCliente FROM #Clientes)
		AND isnull(m.solocompetencia, 0) = 0
		AND m.Reporte = 1
		AND  (isnull(@texto,'') = '' or m.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
		--Oculto marcas de AGD que no se usan
		and m.idMarca != (CASE WHEN @idCliente = 247 THEN -9999 --Marca inexistente
		else 3665
		END)
	GROUP BY ltrim(rtrim(m.nombre))
	ORDER BY ltrim(rtrim(m.nombre))

	SET ROWCOUNT 0
END
GO

getFiltrosMarcas 252