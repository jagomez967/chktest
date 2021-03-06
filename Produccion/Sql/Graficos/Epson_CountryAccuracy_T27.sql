IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_CountryAccuracy_T27'))
   exec('CREATE PROCEDURE [dbo].[Epson_CountryAccuracy_T27] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_CountryAccuracy_T27]
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
		CL.Nombre Point,
		100 VALUE,
		CASE WHEN 
			CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) >= 95
			AND CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) <= 105
			THEN '#00FF00'
		WHEN 
			CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) >= 90
			AND CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) < 95
			THEN '#FFFF00'
		WHEN
			CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) < 90
			OR CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) > 110
			THEN '#FF0000'
		END Color,
		CONVERT(INT,CASE WHEN SUM(FC.PlanOriginalSellIn) > 0 THEN ((CONVERT(NUMERIC(18,2),SUM(FC.SalesIn))/SUM(FC.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END) V
	INTO 
		#DATA
	FROM 
		Forecasting FC
		INNER JOIN Producto P ON FC.idProducto = P.idProducto
		INNER JOIN Familia F ON P.idFamilia = F.idFamilia
		INNER JOIN Cadena C ON FC.idCadena = C.idCadena
		INNER JOIN TipoCadena TC ON TC.IdTipoCadena = C.IdTipoCadena
		INNER JOIN Cliente CL ON FC.idCliente = CL.idCliente
	WHERE 
		CONVERT(DATE,Fecha) >= @FechaDesde
		AND CONVERT(DATE,Fecha) <= @FechaHasta
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson IN (SELECT idSubMarca FROM SubMarca_Producto WHERE idProducto = P.idProducto)))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = TC.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = C.IdCadena))
		AND F.Nombre LIKE '%HW%'
		AND FC.idCliente = @idCliente
		--Oculto Consumibles
		AND P.idMarca != 2905
	GROUP BY
		CL.Nombre
	

	SELECT
		'Country Sell-In Accuracy' SerieName, 
		CONVERT(VARCHAR,(SELECT V FROM #DATA)) + '%' Total,
		'' Target,
		1 ShowText

	SELECT Point,Value,Color, '' Texto FROM #DATA ORDER BY Point DESC

	DROP TABLE #DATA	

END