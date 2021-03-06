SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosFliaProducto]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosFliaProducto] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosFliaProducto]
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

	SELECT max(f.idFamilia) AS idItem
		,f.Nombre AS Descripcion
	FROM familia f
	INNER JOIN marca m ON m.idMarca = f.idMarca
	INNER JOIN cliente c ON c.idEmpresa = m.idEmpresa
	WHERE c.idCliente in (select idCliente from #Clientes)
	AND  (isnull(@texto,'') = '' or f.Nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	--Oculto Consumibles
	and (f.idMarca != 2905)	
	GROUP BY f.Nombre
	ORDER BY f.Nombre

	SET ROWCOUNT 0
END

GO


