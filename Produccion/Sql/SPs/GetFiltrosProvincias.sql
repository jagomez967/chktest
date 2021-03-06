SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosProvincias]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosProvincias] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosProvincias]
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

	SELECT max(P.[IdProvincia]) AS IdItem
		,P.[Nombre] AS Descripcion
	FROM [dbo].[Provincia] P
	INNER JOIN Localidad L ON (L.IdProvincia = P.[IdProvincia])
	INNER JOIN PuntoDeVenta PDV ON (PDV.IdLocalidad = L.IdLocalidad)
	WHERE EXISTS (
			SELECT 1
			FROM #clientes
			WHERE idCliente = pdv.idCliente
			)
	AND  (isnull(@texto,'') = '' or P.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY P.[Nombre]
	ORDER BY P.[Nombre]

	SET ROWCOUNT 0
END


GO
