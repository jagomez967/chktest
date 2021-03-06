SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPuntosDeVentaAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPuntosDeVentaAlerta] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetPuntosDeVentaAlerta]
(
	@IdCliente	int
)
as
begin
	/*
	SELECT	distinct
			z.IdZona as idZona
			,ltrim(rtrim(isnull(z.Nombre,''))) as ZonaDescr
			,c.IdCadena as idCadena
			,ltrim(rtrim(isnull(c.Nombre,''))) as CadenaDescr
			,pdv.IdPuntoDeVenta as idPuntoDeVenta
			,ltrim(rtrim(isnull(pdv.Nombre,''))) as PuntoDeVentaDescr
	FROM [dbo].[Usuario_PuntoDeVenta] UPDV
	INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
	inner join Zona z on z.IdZona=pdv.IdZona
	left join cadena c on c.IdCadena=pdv.IdCadena
	WHERE  dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(4,UPDV.[IdPuntoDeVenta],updv.IdUsuario)=1
	ORDER BY z.IdZona, c.IdCadena, pdv.IdPuntoDeVenta
	*/
	--Te la mejoré
	--que salame


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



	SELECT DISTINCT 
		z.idZona AS idZona
		,z.nombre AS ZonaDescr
		,c.idCadena AS idCadena
		,c.nombre AS CadenaDescr
		,pdv.idPuntodeventa AS idPuntoDeVenta
		,pdv.nombre AS PuntoDeVentaDescr
		,pdv.RazonSocial as RazonSocial
	FROM dbo.Usuario_PuntoDeVenta updv
	INNER JOIN (
		SELECT max(pcu.idPuntodeventa_cliente_usuario) idPCU
			,pcu.IdPuntoDeVenta
			,pcu.idUsuario
		FROM puntodeventa_cliente_Usuario pcu
		WHERE pcu.idCliente  in( select idCLiente from #clientes)
		GROUP BY pcu.idPuntoDeVenta
			,pcu.idUsuario
		) IDP 
		ON IDP.idUsuario = updv.idUsuario
		AND IDP.idPuntodeventa = updv.IdPuntoDeVenta
	INNER JOIN puntodeventa pdv 
		ON pdv.idPuntodeventa = updv.idPuntodeventa
	INNER JOIN zona z 
		ON z.idZona = pdv.idZona
	LEFT JOIN cadena c 
		ON c.idCadena = pdv.idCadena
	WHERE EXISTS (
		SELECT 1
		FROM puntodeventa_cliente_usuario
		WHERE idPuntodeventa_cliente_usuario = IDP.idPCU
			AND activo = 1
		)
	AND pdv.idCliente in( select idCLiente from #clientes)
	--union
	--	select z.idZona, z.nombre as ZonaDescr, c.idCadena, c.nombre as CadenaDescr,p.idPuntoDeVenta ,isnull(p.nombre,'') + ' ' + isnull(p.direccion,'') collate database_default as PuntoDeVentaDescr
	--	from puntodeventa p
	--	left join zona z on z.idZona = p.idZona
	--	left join cadena c on c.idCadena = p.idCadena
	--	where p.idCliente in (select idCliente from #clientes)
	
end

GO
--[GetPuntosDeVentaAlerta] 175