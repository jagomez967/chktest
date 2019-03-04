IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_SellInIjpYoY_T28'))
   exec('CREATE PROCEDURE [dbo].[Epson_SellInIjpYoY_T28] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_SellInIjpYoY_T28]
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

	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)
	
	CREATE TABLE #Marcas
	(
		idMarca INT
	)

	CREATE TABLE #Productos
	(
		idProducto INT
	)

	CREATE TABLE #Familia
	(
		idFamilia int
	)

	CREATE TABLE #marcasEpson
	(
		idMarcaEpson int
	)

	CREATE TABLE #TipoCadena
	(
		idTipoCadena INT
	)

	CREATE TABLE #cadenas
	(
		idCadena INT
	)
	
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT
	DECLARE @cFamilia				INT
	DECLARE @cMarcasEpson			INT
	DECLARE @cTipoCadena			INT
	DECLARE @cCadenas				INT


	INSERT INTO #fechaCreacionReporte (fecha) 
	SELECT 
		CONVERT(DATE,clave) AS fecha 
	FROM 
		dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFechaReporte'),',') 
	WHERE 
		ISNULL(clave,'') <> ''
		AND ISDATE(clave) <> 0

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT
		
	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT

	INSERT INTO #marcasEpson (idmarcaEpson) SELECT clave AS idmarcaEpson FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltMarcasEpson'),',') WHERE ISNULL(clave,'')<>''
	SET @cMarcasEpson = @@ROWCOUNT

	INSERT INTO #Familia (IdFamilia) SELECT clave AS idFamilia FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFamilia'),',') WHERE ISNULL(clave,'')<>''
	SET @cFamilia = @@ROWCOUNT

	INSERT INTO #TipoCadena (idTipoCadena) SELECT clave AS idTipoCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoCadena'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoCadena = @@ROWCOUNT

	INSERT INTO #cadenas (idCadena) SELECT clave AS idCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCadenas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cCadenas = @@ROWCOUNT


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
		0 Year,
		'' Point,
		LEFT(DATENAME(MONTH,DATEADD(YEAR,-1,@fechaDesde)),3) + ' ' + CONVERT(VARCHAR,YEAR(DATEADD(YEAR,-1,@fechaDesde))) SerieName,
		SUM(ISNULL(FC.SalesIn,0)) value,
		'#0071BC' Color,
		0 Line
	INTO
		#DATA
	FROM 
		Forecasting FC
		INNER JOIN Producto P ON FC.idProducto = P.idProducto
		INNER JOIN Familia F ON P.idFamilia = F.idFamilia
		INNER JOIN Cadena C ON FC.idCadena = C.idCadena
	WHERE 
		CONVERT(DATE,Fecha) >= DATEADD(YEAR,-1,@fechaDesde)
		AND CONVERT(DATE,Fecha) <= DATEADD(YEAR,-1,@fechaHasta)
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson IN (SELECT idSubMarca FROM SubMarca_Producto WHERE idProducto = P.idProducto)))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = C.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = C.IdCadena))
		AND F.Nombre LIKE '%HW%'
		AND FC.idCliente = @idCliente
		--Oculto Consumibles
		AND P.idMarca != 2905
	UNION
	SELECT 
		1 Year,
		'' Point,
		LEFT(DATENAME(MONTH,@fechaDesde),3) + ' ' + CONVERT(VARCHAR,YEAR(@fechaDesde)) SerieName,
		SUM(ISNULL(FC.SalesIn,0)) value,
		'#F7931E' Color,
		0 Line
	FROM 
		Forecasting FC
		INNER JOIN Producto P ON FC.idProducto = P.idProducto
		INNER JOIN Familia F ON P.idFamilia = F.idFamilia
		INNER JOIN Cadena C ON FC.idCadena = C.idCadena
	WHERE 
		CONVERT(DATE,Fecha) >= @fechaDesde
		AND CONVERT(DATE,Fecha) <= @fechaHasta
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson IN (SELECT idSubMarca FROM SubMarca_Producto WHERE idProducto = P.idProducto)))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = C.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = C.IdCadena))
		AND F.Nombre LIKE '%HW%'
		AND FC.idCliente = @idCliente
		--Oculto Consumibles
		AND P.idMarca != 2905
	ORDER BY 1,2 ASC

	SELECT 
		'Sell-In | YoY (IJP)' SerieName, 
		 CONVERT(NUMERIC(18,2),(((CONVERT(NUMERIC(18,2),(SELECT Value FROM #DATA WHERE Year = 1))/(SELECT Value FROM #DATA WHERE Year = 0))*100)-100)) Perc,
		 0 Stack,
		 0 ShowText, 
		 0 PersistTooltip,
		 (SELECT MAX(value) FROM #DATA) * 2 maxY

	SELECT Point, SerieName, value, Color, Line, '' Text, value ShowPerc FROM #DATA ORDER BY Point DESC

	DROP TABLE #DATA

END