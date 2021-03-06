SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosTipoEntrega]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosTipoEntrega] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltrosTipoEntrega]
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
		INSERT #clientes (idcliente)
		VALUES (@idCliente)
	END

	SET ROWCOUNT @Top

	SELECT max(t.id) AS IdItem
		,ltrim(rtrim(t.nombre)) AS Descripcion
	FROM TipoDeEntrega t
	WHERE EXISTS (
			SELECT 1
			FROM #clientes
			WHERE idCliente = t.idCliente
			)
	AND  (isnull(@texto,'') = '' or ltrim(rtrim(t.nombre)) like @texto +'%' COLLATE DATABASE_DEFAULT
	)
	GROUP BY ltrim(rtrim(t.nombre))

	SET ROWCOUNT 0
END
GO
