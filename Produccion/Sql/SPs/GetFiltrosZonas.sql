SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosZonas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosZonas] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosZonas]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
begin
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

	SELECT max(Z.[IdZona]) AS IdItem
		,Z.[Nombre] AS Descripcion
	FROM [dbo].[Zona] Z
	INNER JOIN PuntoDeVenta PDV ON (PDV.[IdZona] = Z.[IdZona])
	WHERE EXISTS (
			SELECT 1
			FROM #clientes
			WHERE idCliente = z.idCliente
			)
	AND  (isnull(@texto,'') = '' or z.[Nombre] like @texto +'%')
	GROUP BY Z.[Nombre]
	ORDER BY Z.[Nombre]

	SET ROWCOUNT 0
END
GO
