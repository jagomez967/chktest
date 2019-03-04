IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.WhirlPool_EvolucionPorPlataforma_T25'))
   exec('CREATE PROCEDURE [dbo].[WhirlPool_EvolucionPorPlataforma_T25] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].WhirlPool_EvolucionPorPlataforma_T25
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

	DECLARE @Query			NVARCHAR(MAX)
	DECLARE @SelectMonts	VARCHAR(200)
	
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

	CREATE TABLE #Pop
	(
		idPop INT
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
	DECLARE @cPop					INT
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

	INSERT INTO #Pop (IdPop) SELECT clave AS idPop FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltPop'),',') WHERE ISNULL(clave,'')<>''
	SET @cPop = @@ROWCOUNT

	INSERT INTO #Categoria (IdCategoria) SELECT clave AS Categoria FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCategoria'),',') WHERE ISNULL(clave,'')<>''
	SET @cCategoria = @@ROWCOUNT

	INSERT INTO #TipoPDV (IdTipo) SELECT clave AS idTipo FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
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
	SELECT
		R.YCreacion,
		R.MCreacion,
		GPOP.Nombre GrupoPop,
		M.Nombre Marca,
		GPOP.Color,
		SUM(ISNULL(RPOP.Cantidad,0)) qty
	INTO 
		#RawQtyComp
	FROM 
		Reporte R
		INNER JOIN ReportePop RPOP ON R.idReporte = RPOP.idReporte
		INNER JOIN Pop POP ON RPOP.idPop = POP.idPop
		INNER JOIN GrupoPop GPOP ON POP.idGrupoPop = GPOP.idGrupoPop
		INNER JOIN Pop_Marca MPOP ON POP.idPop = MPOP.idPop
		INNER JOIN Marca M ON MPOP.idMarca = M.idMarca
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE 
		R.idEmpresa in (930,953)  
		AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde--'20180701'
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta--'20180731'
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = pdv.IdCadena))
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = pdv.IdZona))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = pdv.IdLocalidad))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = pdv.IdPuntoDeVenta))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = M.IdMarca))
		AND (ISNULL(@cPop,0) = 0 OR EXISTS(SELECT 1 FROM #Pop WHERE idPop = RPOP.idPop))
		AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = pdv.idCategoria))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
	GROUP BY 
		R.YCreacion,
		R.MCreacion,
		GPOP.Nombre,
		M.Nombre,
		GPOP.Color

	SELECT
		R.YCreacion,
		R.MCreacion,
		F.Nombre GrupoPop,
		M.Nombre Marca,
		SUM(ISNULL(RP.Cantidad,0) + ISNULL(RP.Cantidad2,0)) qty
	INTO
		#RawQty
	FROM
		Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		INNER JOIN Familia F ON P.idFamilia = F.idFamilia	
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE
		R.idEmpresa in (930,953)  
		AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde--'20180701'
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta--'20180731'
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = pdv.IdCadena))
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = pdv.IdZona))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = pdv.IdLocalidad))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = pdv.IdPuntoDeVenta))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = M.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #Productos WHERE idProducto = p.idProducto))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = p.idFamilia))
		AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = pdv.idCategoria))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
	GROUP BY
		R.YCreacion,
		R.MCreacion,
		F.Nombre,
		M.Nombre
	ORDER BY
		qty

	SELECT
		RIGHT('00'+ CONVERT(VARCHAR,MCreacion),2)+'-'+ CONVERT(VARCHAR,Ycreacion) mesStr,
		GrupoPop,
		qty
	INTO
		#RawGroupComp
	FROM 
		#RawQtyComp RQ

	SELECT
		RIGHT('00'+ CONVERT(VARCHAR,MCreacion),2)+'-'+ CONVERT(VARCHAR,Ycreacion) mesStr,
		GrupoPop,
		qty
	INTO
		#RawGroup
	FROM 
		#RawQty RQ
	
	SELECT
		RTRIM(GrupoPop) GrupoPop,
		mesStr label,
		CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),SUM(qty) * 100) / CONVERT(NUMERIC(18,2),(SELECT SUM(QTY) FROM #RawGroupComp WHERE mesStr = RG.mesStr))) qty
	INTO
		#FinalData
	FROM 
		#RawGroup RG
	GROUP BY 
		GrupoPop,
		mesStr
	ORDER BY
		RIGHT(mesStr,CHARINDEX('-',REVERSE(mesStr)) - 1) ,
		LEFT(mesStr,CHARINDEX('-',mesStr) - 1),
		GrupoPop

	SELECT 
		label
	INTO 
		#SelectMonths 
	FROM
	(
	SELECT DISTINCT 
		label
	FROM 
		#FinalData
	) A
	ORDER BY
		RIGHT(label,CHARINDEX('-',REVERSE(label)) - 1) ,
		LEFT(label,CHARINDEX('-',label) - 1)
		

	SET @Query = 
	'
	SELECT
		GrupoPop Proyecto,
		{SelectMonths}
	FROM 
		(SELECT 
			GrupoPop, 
			label,
			qty 
		FROM 
			#FinalData) A
	PIVOT 
		(MIN(qty) 
	FOR 
		label 
	IN (
		{SelectMonths}
		)) AS Piv
	'

	SELECT 
		@SelectMonts = COALESCE(@SelectMonts + ',', '') + '['+CONVERT(VARCHAR,label)+']' 
	FROM 
		#SelectMonths

	SET @Query = REPLACE(@Query,'{SelectMonths}',@SelectMonts)
	
	EXEC sp_executesql @Query

	
	DROP TABLE #RawQtyComp
	DROP TABLE #RawQty
	DROP TABLE #RawGroupComp
	DROP TABLE #RawGroup
	DROP TABLE #FinalData
	DROP TABLE #SelectMonths

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