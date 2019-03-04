IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_VentasUsuario_T12'))
   exec('CREATE PROCEDURE [dbo].[Lanix_VentasUsuario_T12] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Lanix_VentasUsuario_T12]
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

	CREATE TABLE #Clientes
	(
		idCliente INT
	)

	CREATE TABLE #ColumnasDef
	(
		Name	VARCHAR(100),
		Title	VARCHAR(100),
		Width	INT,
		Orden	INT
	)

	DECLARE @cZonas					INT
	DECLARE @cCadenas				INT
	DECLARE @cLocalidades			INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cUsuarios				INT
	DECLARE @cTipoRtm				INT
	DECLARE @cTipoPDV				INT
	DECLARE @cClientes				INT


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

	IF MONTH(@fechaDesde) != MONTH(@fechaHasta) BEGIN
		SELECT @fechaDesde = CASE WHEN MONTH(@fechaDesde) > MONTH(@fechaHasta) THEN
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + '01'
		ELSE
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + '01'
		END
		, @fechaHasta = CASE WHEN MONTH(@fechaDesde) > MONTH(@fechaHasta) THEN
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaDesde), @fechaDesde))))),2)
		ELSE
			CONVERT(VARCHAR,YEAR(@fechaHasta)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaHasta), @fechaHasta))))),2)
		END
	END
	ELSE BEGIN
		SELECT 
			@fechaDesde = CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + '01',
			@fechaHasta = CONVERT(VARCHAR,YEAR(@fechaHasta)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaHasta), @fechaHasta))))),2)
	END
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	SELECT
		ROW_NUMBER() OVER (ORDER BY U.IdUsuario DESC) id,
		CASE WHEN SUM(Cantidad) <= 14 THEN 'FF0000' ELSE (CASE WHEN SUM(Cantidad) < 21 THEN 'FFFF00' ELSE '00FF00' END) END color,
		'' logo,
		0 nivel,
		SUM(Cantidad) valor,
		0 varianza,
		0 parentId,
		ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'') COLLATE DATABASE_DEFAULT AS nombre,
		21 Max
	FROM 
		Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
		INNER JOIN Cliente C ON	C.idEmpresa = R.idEmpresa
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE
		ISNULL(RP.Cantidad,0) != 0 
		AND CONVERT(DATE,R.FechaCreacion) >= @fechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @fechaHasta
		AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
		AND c.IdCliente = CASE @idCliente WHEN 147 THEN 144 ELSE @idCliente END
	GROUP BY
		U.IdUsuario,
		U.Nombre,
		U.Apellido

	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #tipoRtm
	DROP TABLE #TipoPdv
	DROP TABLE #Clientes
	DROP TABLE #ColumnasDef

END