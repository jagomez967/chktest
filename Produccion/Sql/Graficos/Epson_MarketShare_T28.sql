IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_MarketShare_T28'))
   exec('CREATE PROCEDURE [dbo].[Epson_MarketShare_T28] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_MarketShare_T28]
(
	@IdCliente			INT,
	@Filtros			FiltrosReporting READONLY,
	@NumeroDePagina		INT = -1,
	@Lenguaje			VARCHAR(3) = 'es',
	@IdUsuarioConsulta	INT = 0,
	@TamaņoPagina		INT = 0
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

	IF @cCadenas != 0 BEGIN
		INSERT INTO 
			#TipoCadena
		SELECT DISTINCT 
			IdTipoCadena 
		FROM 
			Cadena C
			INNER JOIN #Cadenas TC ON C.idCadena = TC.idCadena

		SET @cTipoCadena = @@ROWCOUNT
	END


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
	
	SET LANGUAGE SPANISH

	SELECT 'MARKET SHARE' SerieName, '' Perc,1 Stack, 1 ShowText

	SELECT DISTINCT 
		MS.Fecha Point,
		S.Nombre SerieName,
		SUM(MS.MarketShare) value,
		S.marcaColor Color,
		0 Line,
		S.idSubmarca
	INTO 
		#DATA
	FROM 
		MarketShareSubMarca MS
		INNER JOIN Familia F ON MS.idFamilia = F.idFamilia
		INNER JOIN SubMarca S ON MS.idSubMarca = S.idSubMarca
			AND F.idMarca = S.idMarca
		INNER JOIN Marca M ON S.idMarca = M.idMarca
		INNER JOIN Cliente C ON M.idEmpresa = C.idEmpresa
	WHERE
		CONVERT(DATE,Fecha) >= DATEADD(YEAR,-1,(SELECT MAX(Fecha) FROM MarketShareSubMarca))
		AND CONVERT(DATE,Fecha) <= (SELECT MAX(Fecha) FROM MarketShareSubMarca)
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = F.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = F.IdMarca))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson = S.idSubmarca))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = MS.IdTipoCadena))
		AND C.idCliente = @idCliente
		--Oculto Consumibles
		AND F.idMarca != 2905
	GROUP BY
		MS.Fecha,
		S.Nombre,
		S.marcaColor,
		S.idSubmarca
	ORDER BY
		MS.Fecha ASC,
		S.idSubmarca DESC

	
	SELECT DATENAME(MONTH,Point) + ' ' + CONVERT(VARCHAR,DATEPART(YEAR,Point)) Point, SerieName, value, Color, Line,CONVERT(VARCHAR,CONVERT(INT,value)) + ' (' + CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),(value * 100)  / (SELECT SUM(value) FROM #DATA WHERE Point = D.Point))) + ' %)' Text, CASE WHEN idSubmarca = 100 THEN CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),(value * 100)  / (SELECT SUM(value) FROM #DATA WHERE Point = D.Point))) + ' %' ELSE '' END ShowPerc INTO #FINAL FROM #DATA D

	INSERT INTO #FINAL
	SELECT DATENAME(MONTH,Point) + ' ' + CONVERT(VARCHAR,DATEPART(YEAR,Point)) Point, 'Total' SerieName, (SELECT SUM(value) FROM #DATA WHERE Point = D.Point) value, '#7FD7F7' Color, 1 Line, CONVERT(VARCHAR,(SELECT SUM(value) FROM #DATA WHERE Point = D.Point)) Text, '' ShowPerc  FROM #DATA D GROUP BY Point 
	

	SELECT * FROM #FINAL
		
	DROP TABLE #DATA
	DROP TABLE #FINAL
	
	
END