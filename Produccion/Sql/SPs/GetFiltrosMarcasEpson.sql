SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosMarcasEpson]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosMarcasEpson] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosMarcasEpson]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	create table #clientes(idCliente int)

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
		INSERT #clientes (idcliente)
		VALUES (@idCliente)
	END

	SET ROWCOUNT @Top

	SELECT max(m.IdSubMarca) AS IdItem
		,ltrim(rtrim(m.nombre)) AS Descripcion
	FROM SubMarca m
	INNER JOIN submarca_Producto smp on smp.idSubmarca = m.idSubmarca 
	INNER JOIN Marca mar on mar.idMarca = m.idMarca
	INNER JOIN Empresa e ON e.IdEmpresa = mar.IdEmpresa
	INNER JOIN cliente c ON c.IdEmpresa = e.IdEmpresa
	WHERE EXISTS (
			SELECT 1
			FROM #clientes
			WHERE idCliente = c.idCliente
			)
	AND  (isnull(@texto,'') = '' or m.nombre like '%' +@texto +'%' COLLATE DATABASE_DEFAULT)
	and mar.reporte = 1
	and exists(select 1 from producto where reporte = 1 and idProducto = smp.idProducto)
	GROUP BY ltrim(rtrim(m.nombre))
	order by 1
	SET ROWCOUNT 0
END
GO

[GetFiltrosMarcasEpson] 178
