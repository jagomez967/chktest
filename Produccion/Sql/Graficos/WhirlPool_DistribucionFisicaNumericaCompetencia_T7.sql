IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.WhirlPool_DistribucionFisicaNumericaCompetencia_T7'))
   exec('CREATE PROCEDURE [dbo].[WhirlPool_DistribucionFisicaNumericaCompetencia_T7] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].WhirlPool_DistribucionFisicaNumericaCompetencia_T7
(
	@IdCliente			INT
	,@Filtros			FiltrosReporting READONLY
	,@NumeroDePagina	INT = -1
	,@Lenguaje			VARCHAR(10) = 'es'
	,@IdUsuarioConsulta INT = 0
	,@TamañoPagina		INT = 0
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
	
	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)

	CREATE TABLE #cadenas
	(
		idCadena INT
	)

	CREATE TABLE #zonas
	(
		idZona INT
	)

	CREATE TABLE #localidades
	(
		idLocalidad INT
	)

	CREATE TABLE #usuarios
	(
		idUsuario INT
	)

	CREATE TABLE #puntosdeventa
	(
		idPuntoDeVenta INT
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
		idFamilia INT
	)

	CREATE TABLE #Categoria
	(
		idCategoria INT
	)

	CREATE TABLE #TipoPDV
	(
		idTipo INT
	)

	DECLARE @cCadenas				INT
	DECLARE @cZonas					INT
	DECLARE @cLocalidades			INT
	DECLARE @cUsuarios				INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT
	DECLARE @cFamilia				INT
	DECLARE @cCategoria				INT
	DECLARE @cTipoPDV				INT


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

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT

	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT

	INSERT INTO #Familia (IdFamilia) SELECT clave AS idFamilia FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFamilia'),',') WHERE ISNULL(clave,'')<>''
	SET @cFamilia = @@ROWCOUNT

	INSERT INTO #Categoria (IdCategoria) SELECT clave AS Categoria FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCategoria'),',') WHERE ISNULL(clave,'')<>''
	SET @cCategoria = @@ROWCOUNT

	INSERT INTO #TipoPDV (IdTipo) SELECT clave AS idTipo FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoPDV'),',') WHERE ISNULL(clave,'')<>''
	SET @cTipoPDV = @@ROWCOUNT

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
	
	;WITH A AS
	(
		SELECT	
			PCU.idPuntoDeVenta,
			MAX(PCU.IdPuntoDeVenta_Cliente_Usuario) Id
		FROM 
			PuntoDeVenta_Cliente_Usuario PCU
			INNER JOIN PuntoDeVenta PDV ON PCU.idPuntoDeVenta = PDV.idPuntoDeVenta
		WHERE 
			CONVERT(DATE, Fecha) <= @FechaHasta
			AND PCU.idCliente = @idCliente
			AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = pdv.IdCadena))
			AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = pdv.IdZona))
			AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = pdv.IdLocalidad))
			AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = pcu.IdUsuario)) AND pcu.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
			AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = pdv.IdPuntoDeVenta))
			AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = pdv.idCategoria))
			AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
		GROUP BY 
			PCU.idUsuario, 
			PCU.idPuntoDeVenta
	) SELECT DISTINCT
		A.idPuntoDeVenta,
		RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,R.FechaCreacion),'')))),2) + '-' + DATENAME(YEAR,ISNULL(CONVERT(VARCHAR,R.FechaCreacion),''))  Mes,
		RP.idProducto,
		CASE WHEN SUM(ISNULL(RP.Cantidad,0) + ISNULL(RP.Cantidad2,0)) != 0 THEN 1 ELSE 0 END TieneFrente
	INTO 
		#TmpDistrPdv
	FROM 
		A 
		LEFT JOIN Reporte R ON A.idPuntoDeVenta = R.idPuntoDeVenta
		LEFT JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
	WHERE 
		(SELECT COUNT(1) FROM PuntoDeVenta_Cliente_Usuario PCU2 WHERE PCU2.IdPuntoDeVenta_Cliente_Usuario=A.Id and PCU2.Activo=0) = 0
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde
		AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
	GROUP BY
		A.idPuntoDeVenta,
		RP.idProducto,
		R.FechaCreacion
	
	;WITH A AS
	(
		SELECT	
			PCU.idPuntoDeVenta,
			MAX(PCU.IdPuntoDeVenta_Cliente_Usuario) Id
		FROM 
			PuntoDeVenta_Cliente_Usuario PCU
			INNER JOIN PuntoDeVenta PDV ON PCU.idPuntoDeVenta = PDV.idPuntoDeVenta
		WHERE 
			CONVERT(DATE, Fecha) <= @FechaHasta
			AND PCU.idCliente = @idCliente
			AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = pdv.IdCadena))
			AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = pdv.IdZona))
			AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = pdv.IdLocalidad))
			AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = pcu.IdUsuario)) AND pcu.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
			AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = pdv.IdPuntoDeVenta))
			AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = pdv.idCategoria))
			AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
		GROUP BY 
			PCU.idUsuario, 
			PCU.idPuntoDeVenta
	) SELECT DISTINCT
		A.idPuntoDeVenta,
		RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,R.FechaCreacion),'')))),2) + '-' + DATENAME(YEAR,ISNULL(CONVERT(VARCHAR,R.FechaCreacion),''))  Mes,
		RP.idProducto,
		CASE WHEN SUM(ISNULL(RP.Cantidad,0) + ISNULL(RP.Cantidad2,0)) != 0 THEN 1 ELSE 0 END TieneFrente
	INTO 
		#TmpDistrPdvComp
	FROM 
		A 
		LEFT JOIN Reporte R ON A.idPuntoDeVenta = R.idPuntoDeVenta
		LEFT JOIN ReporteProductoCompetencia RP ON R.idReporte = RP.idReporte
	WHERE 
		(SELECT COUNT(1) FROM PuntoDeVenta_Cliente_Usuario PCU2 WHERE PCU2.IdPuntoDeVenta_Cliente_Usuario=A.Id and PCU2.Activo=0) = 0
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde
		AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
	GROUP BY
		A.idPuntoDeVenta,
		RP.idProducto,
		R.FechaCreacion

	
	SELECT 
		T.Mes,
		COUNT(DISTINCT idPuntoDeVenta) Cant 
	INTO
		#TmpCant
	FROM 
		#TmpDistrPdv T 
	WHERE 
	idPuntoDeVenta IN (
		SELECT DISTINCT idPuntoDeVenta 
		FROM Reporte R 
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte 
		WHERE idEmpresa = 930 
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
		)
	GROUP BY 
		T.Mes
	

	SELECT 
		T.Mes,
		COUNT(DISTINCT idPuntoDeVenta) Cant 
	INTO
		#TmpCantComp
	FROM 
		#TmpDistrPdvComp T 
	WHERE 
	idPuntoDeVenta IN (
		SELECT DISTINCT idPuntoDeVenta 
		FROM Reporte R 
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte 
		WHERE idEmpresa = 930 
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
		)
	GROUP BY 
		T.Mes
	
	SELECT 
		T.idProducto,
		T.Mes,
		SUM(TieneFrente) PdvConFrentes,
		CONVERT(VARCHAR,(SELECT Cant FROM #TmpCant WHERE Mes = T.Mes)) + LEFT(T.Mes,2) TotalPdv,
		CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),SUM(TieneFrente) * 100) / (SELECT Cant FROM #TmpCant WHERE Mes = T.Mes)) Porcentaje
	INTO
		#TmpDistriProd
	FROM 
		#TmpDistrPdv T
		LEFT JOIN Producto P ON T.idProducto = P.idProducto
	WHERE
		ISNULL(P.idFamilia,0) != 0
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #Productos WHERE idProducto = p.idProducto))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = p.idFamilia))
	GROUP BY 
		T.idProducto,
		T.Mes
	
	SELECT 
		T.idProducto,
		T.Mes,
		SUM(TieneFrente) PdvConFrentes,
		CONVERT(VARCHAR,(SELECT Cant FROM #TmpCantComp WHERE Mes = T.Mes)) + LEFT(T.Mes,2) TotalPdv,
		CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),SUM(TieneFrente) * 100) / (SELECT Cant FROM #TmpCantComp WHERE Mes = T.Mes)) Porcentaje
	INTO
		#TmpDistriProdComp
	FROM 
		#TmpDistrPdvComp T
		LEFT JOIN Producto P ON T.idProducto = P.idProducto
	WHERE
		T.idProducto IN (
		SELECT DISTINCT 
			P2.idProducto 
		FROM 
			#TmpDistriProd T
			INNER JOIN ProductoCompetencia PC ON T.idProducto = PC.idProducto
			INNER JOIN Producto P2 ON PC.idProductoCompetencia = P2.idProducto
		)
	GROUP BY 
		T.idProducto,
		T.Mes
	
	--Categoria
	SELECT 
		TC.Mes + M.Nombre COLLATE DATABASE_DEFAULT mes,
		TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT mesdescr,
		'Porcentaje' descr, 
		CONVERT(NUMERIC(18,2),AVG(TC.Porcentaje)) qty
	FROM #TmpDistriProd T
		INNER JOIN Producto P ON T.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		INNER JOIN ProductoCompetencia PC ON P.idProducto = PC.idProducto
		INNER JOIN Producto P2 ON PC.idProductoCompetencia =  P2.idProducto
		INNER JOIN Marca M2 ON P2.idMarca = M2.idMarca
		INNER JOIN #TmpDistriProdComp TC ON P2.idProducto = TC.idProducto
	GROUP BY
		M.Nombre, TC.Mes
	ORDER BY 
		RIGHT(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT,CHARINDEX('-',REVERSE(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT)) - 1),
		LEFT(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT,CHARINDEX('-',TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT) - 1),
		qty DESC

	--Producto
	SELECT 
		TC.Mes + M.Nombre COLLATE DATABASE_DEFAULT mes,
		TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT mesdescr,
		P2.idProducto,
		P2.Nombre,
		'Porcentaje' decr,
		TC.Porcentaje qty
	FROM #TmpDistriProd T
		INNER JOIN Producto P ON T.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		INNER JOIN ProductoCompetencia PC ON P.idProducto = PC.idProducto
		INNER JOIN Producto P2 ON PC.idProductoCompetencia =  P2.idProducto
		INNER JOIN Marca M2 ON P2.idMarca = M2.idMarca
		INNER JOIN #TmpDistriProdComp TC ON P2.idProducto = TC.idProducto
	ORDER BY
		RIGHT(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT,CHARINDEX('-',REVERSE(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT)) - 1),
		LEFT(TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT,CHARINDEX('-',TC.Mes + ' ' + M.Nombre COLLATE DATABASE_DEFAULT) - 1), 
		P.Nombre, qty DESC


	DROP TABLE #TmpDistrPdv
	DROP TABLE #TmpDistriProd
	DROP TABLE #TmpDistriProdComp
	DROP TABLE #TmpCant
	DROP TABLE #TmpCantComp

	DROP TABLE #fechaCreacionReporte
	DROP TABLE #cadenas
	DROP TABLE #zonas
	DROP TABLE #localidades
	DROP TABLE #usuarios
	DROP TABLE #puntosdeventa
	DROP TABLE #marcas
	DROP TABLE #productos
	DROP TABLE #familia

END