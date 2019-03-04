IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_QuiebreEquipoMarca_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Savant_QuiebreEquipoMarca_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].Savant_QuiebreEquipoMarca_T20
(
	@IdCliente			INT,
	@Filtros			FiltrosReporting READONLY,
	@NumeroDePagina		INT = -1,
	@Lenguaje			VARCHAR(3) = 'es',
	@IdUsuarioConsulta	INT = 0,
	@TamañoPagina		INT = 0
)
AS
BEGIN

/*
	Para filtrar en un query hacer:
	===============================
	*	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	*	(isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
*/		

	SET LANGUAGE SPANISH
	SET NOCOUNT ON

	IF @lenguaje = 'es' BEGIN SET LANGUAGE spanish END
	IF @lenguaje = 'en' BEGIN SET LANGUAGE english END

	DECLARE @fechaDesde DATE
	DECLARE @fechaHasta DATE
	DECLARE @MaxPag		INT

	DECLARE @Query			NVARCHAR(MAX)
	DECLARE @Equipos		VARCHAR(MAX)
	DECLARE @SelectEquipos	VARCHAR(MAX)
	
	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)

	CREATE TABLE #zonas
	(
		idZona INT
	)

	CREATE TABLE #cadenas
	(
		idCadena INT
	)

	CREATE TABLE #localidades
	(
		idLocalidad INT
	)

	CREATE TABLE #puntosdeventa
	(
		idPuntoDeVenta INT
	)

	CREATE TABLE #usuarios
	(
		idUsuario INT
	)

	CREATE TABLE #vendedores
	(
		idVendedor INT
	)

	CREATE TABLE #tipoRtm
	(
		idTipoRtm INT
	)

	CREATE TABLE #Clientes
	(
		idCliente INT
	)

	CREATE TABLE #Marcas
	(
		idMarca	INT
	)

	CREATE TABLE #Productos
	(
		idProducto INT
	)


	DECLARE @cZonas					INT
	DECLARE @cCadenas				INT
	DECLARE @cLocalidades			INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cUsuarios				INT
	DECLARE @cVendedores			INT
	DECLARE @cTipoRtm				INT
	DECLARE @cClientes				INT
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT


	INSERT #fechaCreacionReporte (fecha) 
	SELECT 
		CONVERT(DATE,clave) AS fecha 
	FROM 
		dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFechaReporte'),',') 
	WHERE 
		ISNULL(clave,'') <> ''
		AND ISDATE(clave) <> 0

	INSERT INTO #cadenas (idCadena) SELECT clave AS idCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCadenas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cCadenas = @@ROWCOUNT

	INSERT INTO #zonas (idZona) SELECT clave AS idZona FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltZonas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cZonas = @@ROWCOUNT

	INSERT INTO #localidades (idLocalidad) SELECT clave AS idLocalidad FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltLocalidades'),',') WHERE ISNULL(clave,'') <> ''
	SET @cLocalidades = @@ROWCOUNT

	INSERT INTO #usuarios (idUsuario) SELECT clave AS idUsuario FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltUsuarios'),',') WHERE ISNULL(clave,'') <> ''
	SET @cUsuarios = @@ROWCOUNT

	INSERT INTO #puntosdeventa (idPuntoDeVenta) SELECT clave AS idPuntoDeVenta FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltPuntosDeVenta'),',') WHERE ISNULL(clave,'') <> ''
	SET @cPuntosDeVenta = @@ROWCOUNT

	INSERT INTO #vendedores (idVendedor) SELECT clave AS idVendedor FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltVendedores'),',') WHERE ISNULL(clave,'') <> ''
	SET @cVendedores = @@ROWCOUNT

	INSERT INTO #tipoRtm (idTipoRtm) SELECT clave AS idTipoRtm FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoDeRTM'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoRtm = @@ROWCOUNT

	INSERT INTO #clientes (IdCliente) SELECT clave AS idCliente FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltClientes'),',') WHERE ISNULL(clave,'') <> ''
	SET @cClientes = @@ROWCOUNT

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT

	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT


	IF @cClientes = 0 BEGIN
		INSERT INTO #clientes(idCliente) 
		SELECT 
			fc.idCliente 
		FROM 
			familiaClientes fc
		WHERE 
			fc.familia in (SELECT familia FROM familiaClientes WHERE idCliente = @idCliente
									and activo = 1)
		IF @@ROWCOUNT = 0 BEGIN
			INSERT INTO #clientes (idcliente)
			VALUES (@idCliente) 
		END

	END

	INSERT INTO #puntosdeventa(idPuntodeventa)
	SELECT 
		pdv.idPuntodeventa 
	FROM
		puntodeventa pdv
		INNER JOIN (SELECT nombre FROM puntodeventa WHERE idPuntodeventa IN (SELECT idPuntodeventa FROM #puntosdeventa)) pdx ON pdx.nombre = pdv.nombre
	WHERE 
		pdv.idCliente IN (SELECT idCliente FROM #clientes)
		AND NOT EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntodeventa = pdv.idPuntodeventa)

	INSERT INTO #Zonas(idZona)
	SELECT 
		z.idZona 
	FROM 
		Zona z
	INNER JOIN (SELECT nombre FROM Zona WHERE idZona IN (SELECT idZona FROM #Zonas)) pdx ON pdx.nombre = z.nombre
	WHERE 
		z.idCliente IN (SELECT idCliente FROM #clientes)
		AND NOT EXISTS (SELECT 1 FROM #Zonas WHERE idZona = z.idZona)

	INSERT INTO #Localidades(idLocalidad)
	SELECT 
		l.idLocalidad
	FROM 
		Localidad l
		INNER JOIN (SELECT nombre FROM Localidad WHERE idLocalidad IN (SELECT idLocalidad FROM #Localidades)) pdx ON pdx.nombre = l.nombre
		INNER JOIN Provincia p ON p.idProvincia = l.idProvincia
	WHERE 
		p.idCliente IN (SELECT idCliente FROM #clientes)
		AND NOT EXISTS (SELECT 1 FROM #Localidades WHERE idLocalidad = l.idLocalidad)

	IF (ISNULL((SELECT fecha FROM #fechaCreacionReporte WHERE id = 1),'00010101') = '00010101' ) BEGIN
		SET @fechaDesde = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	END
	ELSE BEGIN
		SELECT @fechaDesde = fecha FROM #fechaCreacionReporte WHERE id = 1
	END

	IF (ISNULL((SELECT fecha FROM #fechaCreacionReporte WHERE id = 2),'00010101') = '00010101' ) BEGIN
		SET @fechaHasta = GETDATE()
	END
	ELSE BEGIN
		SELECT @fechaHasta =  fecha FROM #fechaCreacionReporte WHERE id = 2
	END

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	SELECT 
		ISNULL(E.Nombre,'N/C') Equipo,
		M.Nombre Marca,
		COUNT(DISTINCT PDV.idPuntoDeVenta) Qty
	INTO
		#TMP
	FROM 
		Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN PuntoDeVenta_Cliente_Usuario PCU ON PDV.idPuntoDeVenta = PCU.idPuntoDeVenta
			AND C.idCliente = PCU.idCliente
		LEFT JOIN PuntoDeVenta_Vendedor PDVV ON PDV.idPuntoDeVenta = PDVV.idPuntoDeVenta
		LEFT JOIN Vendedor V ON PDVV.idVendedor = V.idVendedor
		LEFT JOIN Equipo E ON V.idEquipo = E.idEquipo
	WHERE 
		C.IdCliente = @IdCliente
		AND CONVERT(DATE,R.FechaCreacion) >= @fechaDesde 
		AND CONVERT(DATE,R.FechaCreacion)<= @fechaHasta
		AND RP.Stock & P.Reporte = 1
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = PCU.IdUsuario)) AND PCU.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = PCU.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = PCU.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
	GROUP BY
		E.Nombre,
		M.Nombre


	SET @Query = 
	'
	SELECT
		1 Id,
		Marca COLLATE DATABASE_DEFAULT Marca,
		{SelectEquipos}
		,NULL Totales
	INTO
		##TMPRESULT
	FROM 
		(SELECT DISTINCT Marca, Equipo, 
		Qty FROM #TMP) A
	PIVOT 
		(MIN(Qty) 
	FOR 
		Equipo
	IN (
		{Equipos}
		)) AS Piv
	'
	
	SELECT DISTINCT  
		--Id,
		Equipo
	INTO 
		#SelectEquipos
	FROM 
		#TMP 
	--ORDER BY 
		--Id ASC

	SELECT COUNT(DISTINCT Equipo) FROM #TMP
	
	
	SELECT DISTINCT 1 Id, Equipo name, Equipo title,10 width FROM #TMP 
	UNION
	SELECT  0 Id, 'Marca' name,'Marca' title ,10 width
	UNION
	SELECT 2 Id, 'Totales' name, 'Totales' title, 10 width
	ORDER BY Id ASC
	
	
	SELECT 
		@SelectEquipos = COALESCE(@SelectEquipos + ',', '') + 'ISNULL(['+CONVERT(VARCHAR,Equipo)+'],'''') ' + '''' +  Equipo  + ''''
	FROM 
		#SelectEquipos
	SET @Query = REPLACE(@Query,'{SelectEquipos}',@SelectEquipos)

	SELECT 
		@Equipos = COALESCE(@Equipos + ',', '') + '['+CONVERT(VARCHAR,Equipo)+']' 
	FROM 
		#SelectEquipos
	SET @Query = REPLACE(@Query,'{Equipos}',@Equipos)

	--SELECT @Query
	EXEC sp_executesql @Query 
	
	SELECT @SelectEquipos = NULL, @Query = NULL
	
	SELECT @Query = 
	'
	UPDATE 
		T 
	SET 
		Totales = {SelectEquipos}
	FROM
		##TMPRESULT T
	'

	SELECT 
		@SelectEquipos = COALESCE(@SelectEquipos + '+', '') + 'ISNULL(['+CONVERT(VARCHAR,Equipo)+'],'''') '
	FROM 
		#SelectEquipos
	SET @Query = REPLACE(@Query,'{SelectEquipos}',@SelectEquipos)
	
	--SELECT @Query
	EXEC sp_executesql @Query 

	SELECT @Query = '', @SelectEquipos = '', @Equipos = ''

	SET @Query = 
	'
	SELECT Marca {SelectEquipos}, Totales FROM ##TMPRESULT
	UNION
	SELECT ''Total Resultado'' {Equipos}, SUM(Totales) FROM ##TMPRESULT
	'

	SELECT 
		@SelectEquipos = COALESCE(@SelectEquipos + ',', '') + 'ISNULL(['+CONVERT(VARCHAR,Equipo)+'],'''') ' + '''' +  Equipo  + ''''
	FROM 
		#SelectEquipos
	SET @Query = REPLACE(@Query,'{SelectEquipos}',@SelectEquipos)

	SELECT 
		@Equipos = COALESCE(@Equipos + ',', '') + 'SUM(['+CONVERT(VARCHAR,Equipo)+'])' 
	FROM 
		#SelectEquipos
	SET @Query = REPLACE(@Query,'{Equipos}',@Equipos)

	--SELECT @Query
	EXEC sp_executesql @Query 

	--SELECT * FROM ##TMPRESULT

	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #vendedores
	DROP TABLE #tipoRtm
	DROP TABLE #Clientes
	DROP TABLE #TMP
	DROP TABLE ##TMPRESULT
	DROP TABLE #SelectEquipos

END
