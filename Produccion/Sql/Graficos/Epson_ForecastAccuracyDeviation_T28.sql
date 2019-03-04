IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_ForecastAccuracyDeviation_T28'))
   exec('CREATE PROCEDURE [dbo].[Epson_ForecastAccuracyDeviation_T28] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_ForecastAccuracyDeviation_T28]
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

	SET @FechaDesde = CASE WHEN MONTH(GETDATE()) >= 4 THEN
	CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401'
	ELSE
	CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0401'
	END

	SET @FechaHasta = CASE WHEN MONTH(GETDATE()) >= 4 THEN
	CONVERT(VARCHAR,DATEPART(YEAR,GETDATE() + 1)) + '0331'
	ELSE
	CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331'
	END

	
	SET LANGUAGE SPANISH

	SELECT
		YEAR(F.Fecha) Año, 
		MONTH(F.Fecha) Mes,
		DATENAME(MONTH,F.Fecha) Point,
		UPPER(TC.Nombre) SerieName,
		CASE WHEN SUM(F.PlanOriginalSellIn) > 0 then ((CONVERT(NUMERIC(18,2),SUM(F.SalesIn))/SUM(F.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END value,
		CASE TC.Identificador WHEN 'DIST' THEN '#FF3193' 
		WHEN 'RET' THEN '#00B2EC' 
		ELSE '' END Color,
		1 Line,
		CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),CASE WHEN SUM(F.PlanOriginalSellIn) > 0 then ((CONVERT(NUMERIC(18,2),SUM(F.SalesIn))/SUM(F.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END)) + '%' Text,
		'' ShowPerc
 	INTO 
		#DATA
	FROM 
		Forecasting F
		INNER JOIN  Cadena C ON F.idCadena = C.idCadena
		INNER JOIN TipoCadena TC ON C.idTipoCadena = TC.idTipoCadena
		INNER JOIN Producto P ON F.idProducto = P.idProducto
	WHERE 
		CONVERT(DATE,Fecha) >= @FechaDesde
		AND CONVERT(DATE,Fecha) <= @FechaHasta
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #productos WHERE idProducto = P.idProducto))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = TC.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #Cadenas WHERE idCadena = F.idCadena))
		AND F.idCliente = @idCliente
		--Oculto Consumibles
		AND P.idMarca != 2905
	GROUP BY
		YEAR(F.Fecha),
		MONTH(F.Fecha),
		DATENAME(MONTH,F.Fecha),
		TC.Nombre,
		TC.Identificador
	UNION
	SELECT
		YEAR(F.Fecha) Año, 
		MONTH(F.Fecha) Mes,
		DATENAME(MONTH,F.Fecha) Point,
		'Deviation' SerieName,
		CASE WHEN SUM(F.PlanOriginalSellIn) > 0 then ((CONVERT(NUMERIC(18,2),SUM(F.SalesIn))/SUM(F.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END value,
		'#F57B3C' Color,
		1 Line,
		CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),CASE WHEN SUM(F.PlanOriginalSellIn) > 0 then ((CONVERT(NUMERIC(18,2),SUM(F.SalesIn))/SUM(F.PlanOriginalSellIn)) - 1 ) * 100 ELSE 0 END)) + '%' Text,
		'' ShowPerc
	FROM 
		Forecasting F
		INNER JOIN  Cadena C ON F.idCadena = C.idCadena
		INNER JOIN TipoCadena TC ON C.idTipoCadena = TC.idTipoCadena
		INNER JOIN Producto P ON F.idProducto = P.idProducto
	WHERE 
		CONVERT(DATE,Fecha) >= @FechaDesde
		AND CONVERT(DATE,Fecha) <= @FechaHasta
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #productos WHERE idProducto = P.idProducto))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = TC.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #Cadenas WHERE idCadena = F.idCadena))
		AND F.idCliente = @idCliente
		--Oculto Consumibles
		AND P.idMarca != 2905
	GROUP BY
		YEAR(F.Fecha),
		MONTH(F.Fecha),
		DATENAME(MONTH,F.Fecha)
	ORDER BY
		YEAR(F.Fecha),
		MONTH(F.Fecha)
	
	SELECT 'FORECAST ACCURACY - DEVIATION' SerieName, '' Perc, 0 Stack, 1 ShowText, CONVERT(INT,MAX(value)) + 5 maxY, CONVERT(INT,MIN(value)) -5  minY, 1 ShowYAxisLabels FROM #DATA

	SELECT LEFT(Point,3) Point,SerieName,value,Color,Line,Text,ShowPerc FROM #DATA ORDER BY Año,Mes
		
	SELECT '#C70013' Color, 'shortdot' DashStyle, 5 value, 2 width, 'Upper Boundary' label
	UNION
	SELECT '#C70013' Color, 'shortdot' DashStyle, -5 value, 2 width, 'Lower Boundary' label

	SELECT '#E2F0DA' Color, -5 as 'From', 5 as 'To'

	DROP TABLE #DATA
	
	
END