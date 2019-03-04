IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_MarketShareConversion_T27'))
   exec('CREATE PROCEDURE [dbo].[Epson_MarketShareConversion_T27] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_MarketShareConversion_T27]
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

	DECLARE @Fecha	VARCHAR(MAX)

	SELECT 
		@Fecha= ISNULL(RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,MAX(Fecha))),2) + '/' + CONVERT(VARCHAR,DATEPART(YEAR,MAX(Fecha))),'')
	FROM 
		MarketShareSubMarca
	WHERE 
		idFamilia = CASE WHEN @idCliente = 178 THEN 871
					WHEN @idCliente = 183 THEN 907
					WHEN @idCliente = 186 THEN 911 END
		OR idFamilia = CASE WHEN @idCliente = 178 THEN 872
						WHEN @idCliente = 183 THEN 908
						WHEN @idCliente = 186 THEN 1288 END
		OR idFamilia = CASE WHEN @idCliente = 178 THEN 873
						WHEN @idCliente = 183 THEN 909 END

	SELECT 'CONVERSION' SerieName, '' Total, 1 FullPie, 1 ShowText,@Fecha SubTitle
		
	SELECT DISTINCT 
		F.Nombre Point,
		SUM(MS.MarketShare) value,
		CASE WHEN F.Nombre LIKE '%CISS%' THEN '#3EA9F5' WHEN F.Nombre LIKE '%IC%' THEN '#0000FF' END Color
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
		CONVERT(DATE,Fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
		AND CONVERT(DATE,Fecha) <= GETDATE()
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = F.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = F.IdMarca))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson = S.idSubmarca))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = MS.IdTipoCadena))
		AND C.idCliente = @idCliente
		--Oculto Consumibles
		AND F.idMarca != 2905
	GROUP BY
		F.Nombre

	SELECT 
		*,
		CONVERT(VARCHAR,CONVERT(INT,value)) + ' (' + CONVERT(VARCHAR,CONVERT(NUMERIC(18,2),(value * 100)  / (SELECT SUM(value) FROM #DATA))) + ' %)' Texto
	FROM 
		#DATA D 
	
	DROP TABLE #DATA
	
END