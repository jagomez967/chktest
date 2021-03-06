SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosProductos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosProductos] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosProductos]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	DECLARE @clientesQty int

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
		INSERT #clientes (idcliente)
		VALUES (@idCliente)
		set @clientesQty = @@ROWCOUNT
	END

	SET ROWCOUNT @Top

	SELECT max(p.IdProducto) AS IdItem
		,ltrim(rtrim(p.nombre)) AS Descripcion
	FROM Marca m
	INNER JOIN Empresa e ON e.IdEmpresa = m.IdEmpresa
	INNER JOIN cliente c ON c.IdEmpresa = e.IdEmpresa
	INNER JOIN Producto p ON p.IdMarca = m.IdMarca
	WHERE EXISTS (
			SELECT 1
			FROM #clientes
			WHERE idCliente = c.idCliente
			)
	AND  (isnull(@texto,'') = '' or p.nombre like '%' +@texto +'%' COLLATE DATABASE_DEFAULT)
	--Estos id son productos "virtuales" usados para FitRatio de Epson Consumibles, no deben aparecer en Mobile (Reporte=0) pero si en el filtro de Reporting.
	and (p.reporte = 1 or p.idProducto IN (18461,18462,18463,18464)) 
	--Oculto Consumibles
	and (p.idMarca != 2905)	
	--Oculto productos de AGD que no se usan
	and p.idMarca != (CASE WHEN @idCliente = 247 THEN -9999 --Marca inexistente
		else 3665
		END)
	GROUP BY ltrim(rtrim(p.nombre))

	SET ROWCOUNT 0
END
GO

GetFiltrosProductos 252


