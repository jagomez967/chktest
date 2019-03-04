IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_CobMesUsuario_T7'))
   EXEC('CREATE PROCEDURE [dbo].[Epson_CobMesUsuario_T7] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_CobMesUsuario_T7]
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

	SET LANGUAGE spanish
	SET NOCOUNT ON

	IF @lenguaje = 'es' BEGIN SET LANGUAGE spanish END
	IF @lenguaje = 'en' BEGIN SET LANGUAGE english END

	DECLARE @fechaDesde DATE
	DECLARE @fechaHasta DATE
	DECLARE @MaxPag		INT
	
	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)

	CREATE TABLE #Clientes
	(
		idCliente INT
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

	CREATE TABLE #tipoRtm
	(
		idTipoRtm INT
	)

	CREATE TABLE #TipoPDV
	(
		idTipo INT
	)

	CREATE TABLE #Categoria
	(
		idCategoria INT
	)
	
	CREATE TABLE #Provincias
	(
		idProvincia INT
	)

	CREATE TABLE #ColumnasDef
	(
		Name	VARCHAR(100),
		Title	VARCHAR(100),
		Width	INT,
		Orden	INT
	)

	DECLARE @cClientes			INT
	DECLARE @cZonas				INT
	DECLARE @cCadenas			INT
	DECLARE @cLocalidades		INT
	DECLARE @cPuntosDeVenta		INT
	DECLARE @cUsuarios			INT
	DECLARE @cTipoRtm			INT
	DECLARE @cTipoPDV			INT
	DECLARE @cCategoria			INT
	DECLARE @cProvincias		INT



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

	INSERT INTO #tipoRtm (idTipoRtm) SELECT clave AS idTipoRtm FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoDeRTM'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoRtm = @@ROWCOUNT

	INSERT INTO #TipoPDV (IdTipo) SELECT clave AS idTipo FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoPDV'),',') WHERE ISNULL(clave,'') <> ''
	set @cTipoPDV = @@ROWCOUNT

	INSERT INTO #clientes (IdCliente) SELECT clave AS idCliente FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltClientes'),',') WHERE ISNULL(clave,'') <> ''
	SET @cClientes = @@ROWCOUNT


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

	
;WITH DateTable
AS
(
    SELECT CAST(@fechaDesde AS DATE) AS [DATE]
    UNION ALL
    SELECT DATEADD(dd, 1, [DATE])
    FROM DateTable
    WHERE DATEADD(dd, 1, [DATE]) < CAST(@fechaHasta AS DATE)
)
SELECT DISTINCT
	CONVERT(VARCHAR,YEAR(dt.DATE)) + RIGHT('00' + CONVERT(VARCHAR,MONTH(dt.DATE)),2) mes,
	DATENAME(MONTH, dt.DATE) + ' ' +CONVERT(VARCHAR,YEAR(dt.DATE)) mesDescr,
	'Objetivo Visitas' descr,
	SUM(ECV.CantidadVisitas) qty
FROM 
	[DateTable] dt,
	tmpEpsonCantidadVisitas ECV
	INNER JOIN Usuario U ON ECV.idUsuario = U.idUsuario
	INNER JOIN PuntoDeVenta PDV ON ECV.idPuntoDeVenta = PDV.idPuntoDeVenta
	INNER JOIN Cliente C ON PDV.idCliente = C.idCliente
WHERE
	EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
	AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
	AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
	AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
	AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
	AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = ECV.idUsuario)) AND ECV.idUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
	AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = ECV.idUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
	AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
	AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = PDV.idCategoria))
	AND	(ISNULL(@cProvincias,0) = 0 OR EXISTS(SELECT 1 FROM #Provincias WHERE idProvincia IN (SELECT idProvincia FROM Localidad WHERE idLocalidad = PDV.idLocalidad)))
GROUP BY 
	dt.DATE
UNION
SELECT
	CONVERT(VARCHAR,A.YEAR) + RIGHT('00' + CONVERT(VARCHAR,A.MONTH),2) mes,
	DATENAME(MONTH, CONVERT(VARCHAR,A.YEAR) + RIGHT('00' + CONVERT(VARCHAR,A.MONTH),2) + '01') + ' ' + CONVERT(VARCHAR,A.YEAR) mesDescr,
	'Visitas' descr,
	SUM(A) qty
	FROM
		(SELECT 
			COUNT(1) A,
			MONTH(R.fechaCreacion) Month,
			YEAR(R.fechaCreacion) Year
		FROM 
			tmpEpsonCantidadVisitas ECV
			INNER JOIN Usuario U ON ECV.idUsuario = U.idUsuario
			INNER JOIN Reporte R ON U.idUsuario = R.idUsuario
				AND ECV.idPuntoDeVenta = R.idPuntoDeVenta
			INNER JOIN PuntoDeVenta PDV ON ECV.idPuntoDeVenta = PDV.idPuntoDeVenta
			INNER JOIN Cliente C ON PDV.idCliente = C.idCliente
		WHERE
			CONVERT(DATE,R.FechaCreacion) >= @fechaDesde
			AND CONVERT(DATE,R.FechaCreacion) <= @fechaHasta
			AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
			AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
			AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
			AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
			AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
			AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
			AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
			AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
			AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = PDV.idCategoria))
			AND	(ISNULL(@cProvincias,0) = 0 OR EXISTS(SELECT 1 FROM #Provincias WHERE idProvincia IN (SELECT idProvincia FROM Localidad WHERE idLocalidad = PDV.idLocalidad)))
		GROUP BY
			ECV.idUsuario,
			ECV.idPuntoDeVenta,
			ECV.CantidadVisitas,
			MONTH(R.fechaCreacion),
			YEAR(R.fechaCreacion)) A
	GROUP BY a.Month,a.Year

	;WITH DateTable
	AS
	(
		SELECT CAST(@fechaDesde AS DATE) AS [DATE]
		UNION ALL
		SELECT DATEADD(dd, 1, [DATE])
		FROM DateTable
		WHERE DATEADD(dd, 1, [DATE]) < CAST(@fechaHasta AS DATE)
	)
	SELECT DISTINCT
		CONVERT(VARCHAR,YEAR(dt.DATE)) + RIGHT('00' + CONVERT(VARCHAR,MONTH(dt.DATE)),2) mes,
		DATENAME(MONTH, dt.DATE) + ' ' +CONVERT(VARCHAR,YEAR(dt.DATE)) mesDescr,				
		ECV.idUsuario,
		ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre COLLATE DATABASE_DEFAULT,'') nombreUsuario,
		'Objetivo Visitas' asignadoRelevado,
		SUM(ECV.CantidadVisitas) qty
	FROM
		[DateTable] dt,
		tmpEpsonCantidadVisitas ECV
		INNER JOIN Usuario U ON ECV.idUsuario = U.idUsuario
		INNER JOIN PuntoDeVenta PDV ON ECV.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN Cliente C ON PDV.idCliente = C.idCliente
	WHERE
		ECV.CantidadVisitas != 0
		AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = ECV.idUsuario)) AND ECV.idUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = ECV.idUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
		AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = PDV.idCategoria))
		AND	(ISNULL(@cProvincias,0) = 0 OR EXISTS(SELECT 1 FROM #Provincias WHERE idProvincia IN (SELECT idProvincia FROM Localidad WHERE idLocalidad = PDV.idLocalidad)))
	GROUP BY
			ECV.idUsuario,
			U.Apellido,
			U.Nombre,
			dt.DATE
	UNION
	SELECT
		CONVERT(VARCHAR,A.YEAR) + RIGHT('00' + CONVERT(VARCHAR,A.MONTH),2) mes,
		DATENAME(MONTH, CONVERT(VARCHAR,A.YEAR) + RIGHT('00' + CONVERT(VARCHAR,A.MONTH),2) + '01') + ' ' + CONVERT(VARCHAR,A.YEAR) mesDescr,
		A.idUsuario,
		A.Nombre nombreUsuario,
		'Visitas' asignadoRelevado,
		SUM(A) qty
	FROM
		(SELECT 
			ECV.idUsuario idUsuario,
			ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre COLLATE DATABASE_DEFAULT,'') Nombre,
			COUNT(1) A,
			MONTH(R.fechaCreacion) Month,
			YEAR(R.fechaCreacion) Year
		FROM 
			tmpEpsonCantidadVisitas ECV
			INNER JOIN Usuario U ON ECV.idUsuario = U.idUsuario
			INNER JOIN Reporte R ON U.idUsuario = R.idUsuario
				AND ECV.idPuntoDeVenta = R.idPuntoDeVenta
			INNER JOIN PuntoDeVenta PDV ON ECV.idPuntoDeVenta = PDV.idPuntoDeVenta
			INNER JOIN Cliente C ON PDV.idCliente = C.idCliente
		WHERE
			CONVERT(DATE,R.FechaCreacion) >= @fechaDesde
			AND CONVERT(DATE,R.FechaCreacion) <= @fechaHasta
			AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
			AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
			AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
			AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
			AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
			AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
			AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
			AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
			AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = PDV.idCategoria))
			AND	(ISNULL(@cProvincias,0) = 0 OR EXISTS(SELECT 1 FROM #Provincias WHERE idProvincia IN (SELECT idProvincia FROM Localidad WHERE idLocalidad = PDV.idLocalidad)))
		GROUP BY
			ECV.idUsuario,
			U.Apellido,
			U.Nombre,
			ECV.idPuntoDeVenta,
			ECV.CantidadVisitas,
			MONTH(R.fechaCreacion),
			YEAR(R.fechaCreacion)) A
	GROUP BY
		A.idUsuario,
		A.Nombre,
		A.Month,
		A.Year

	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #tipoRtm
	DROP TABLE #Clientes

END