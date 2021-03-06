IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_FitRatioHistorico_T28'))
   exec('CREATE PROCEDURE [dbo].[Epson_FitRatioHistorico_T28] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Epson_FitRatioHistorico_T28]
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

	--Cosas de Epson.
	IF ISNULL(@cFamilia,0) = 0 AND ISNULL(@cProductos,0) = 0 BEGIN
		INSERT INTO #Productos
		SELECT idProducto FROM Producto WHERE idProducto IN (18461,18462,18463,18464)
		SET @cProductos = @@ROWCOUNT

		/*
		INSERT INTO #Cadenas
		SELECT idCadena FROM Cadena WHERE Nombre = 'TOTAL PAIS'
		SET @cCadenas = @@ROWCOUNT
		*/
	END
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	SELECT 'FIT RATIO' SerieName, '' Perc, 0 Stack, 0 ShowText 

	SELECT
		FR.Fecha,
		CL.Nombre SerieName,
		CONVERT(NUMERIC(18,2),ISNULL(SUM(ISNULL(FR.FitRatio,0)),0)) value,
		CASE CL.idCliente 
			WHEN 178 THEN '#B5D2EB' 
			WHEN 173 THEN '#ee8336'
			WHEN 186 THEN '#7635A5'
		END Color,
		1 Line,
		'' Text
	INTO 
		#DATA
	FROM 
		FitRatio FR
		INNER JOIN Producto P ON FR.idProducto = P.idProducto
		INNER JOIN Familia F ON P.idFamilia = F.idFamilia
		INNER JOIN Cadena C  ON FR.idCadena = C.idCadena
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		INNER JOIN Cliente CL ON M.idEmpresa = CL.idEmpresa
	WHERE 
		CONVERT(DATE,FR.Fecha) >= DATEADD(MONTH,-12,@FechaHasta)
		AND CONVERT(DATE,FR.Fecha) <= @FechaHasta
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		AND (ISNULL(@cMarcasEpson,0) = 0 OR EXISTS(SELECT 1 FROM #marcasEpson WHERE idMarcaEpson IN (SELECT idSubMarca FROM SubMarca_Producto WHERE idProducto = P.idProducto)))
		AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = C.IdTipoCadena))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = C.IdCadena))
		AND CL.idCliente IN (178,183,186)
	GROUP BY
		FR.Fecha,
		CL.idCliente,
		CL.Nombre
	ORDER BY 
		FR.Fecha
	


	SELECT Fecha,DATENAME(MONTH,Fecha) + ' ' + CONVERT(VARCHAR,DATEPART(YEAR,Fecha)) Point, SerieName, value, Color, Line, Text, '' ShowPerc INTO #FINAL FROM #DATA 
	UNION
	SELECT Fecha,DATENAME(MONTH,Fecha) + ' ' + CONVERT(VARCHAR,DATEPART(YEAR,Fecha)) Point, 'Avg LATAM' SerieName, AVG(value), '#000000' Color, 1 Line, '' Text, '' ShowPerc FROM #DATA GROUP BY SerieName, DATENAME(MONTH,Fecha) + ' ' + CONVERT(VARCHAR,DATEPART(YEAR,Fecha)), Fecha

	SELECT Point,SerieName,value,Color,Line,Text,ShowPerc FROM #FINAL order by Fecha

	DROP TABLE #FINAL
	DROP TABLE #DATA
	
END