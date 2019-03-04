IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonTrade_DistribucionFisica_T30'))
   exec('CREATE PROCEDURE [dbo].[EpsonTrade_DistribucionFisica_T30] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[EpsonTrade_DistribucionFisica_T30]
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

	DECLARE @Query				NVARCHAR(MAX)
	DECLARE @SelectProductos	NVARCHAR(MAX)
	
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

	CREATE TABLE #Colores
	(
		idColor		INT
	)


	DECLARE @cCadenas				INT
	DECLARE @cZonas					INT
	DECLARE @cLocalidades			INT
	DECLARE @cUsuarios				INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT
	DECLARE @cColores				INT

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

	INSERT INTO #Colores (idColor) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltSemaforoTrade'),',') WHERE ISNULL(clave,'')<>''
	SET @cColores = @@ROWCOUNT

	IF @cColores = 0 BEGIN
		INSERT INTO #Colores VALUES
		(100),(200),(300),(400)
		set @cColores = 4
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

	DROP TABLE #fechaCreacionReporte

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
	declare @maxfechaep date
	declare @dfFechaDesde date
	declare @dfFechaHasta date
	declare @idnegocio int

	select @idnegocio = e.idnegocio
	from empresa e
	inner join cliente c on c.idempresa= e.idempresa
	where c.idcliente = @idcliente

	select @maxfechaep =  max(fecha) from EpsonTradeProductosSellIn e
	inner join cadena c on c.idcadena = e.idcadena
	where c.idnegocio = @idnegocio

	if(@maxfechaep<@fechadesde)
	begin
		set @dfFechaDesde = CONVERT(VARCHAR,YEAR(@maxfechaep)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@maxfechaep)),2) + '01'
		set @dfFechaHasta = CONVERT(VARCHAR,YEAR(@maxfechaep)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@maxfechaep)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@maxfechaep), @maxfechaep))))),2)
	end
	else
	begin
		set @dfFechaDesde = @fechaDesde
		set @dfFechaHasta = @fechaHasta
	end


	--select @fechadesde
	--select @fechahasta
	--select @dffechadesde
	--select @dffechahasta

	--	SELECT
	--	MAX(R.idReporte) idReporte,
	--	R.idPuntoDeVenta,
	--	R.idEmpresa
	--FROM
	--	Reporte R
	--	INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
	--	INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
	--	INNER JOIN Cadena CA ON PDV.idCadena = CA.idCadena
	--WHERE 
	--	C.idCliente = @idCliente
	--	AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
	--	AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
	--	AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
	--	AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
	--	AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
	--	AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
	--	AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
	--GROUP BY
	--	LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
	--	R.idPuntoDeVenta,
	--	R.idEmpresa


	;WITH RPT AS
	(
	SELECT
		MAX(R.idReporte) idReporte,
		R.idPuntoDeVenta,
		R.idEmpresa
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		INNER JOIN Cadena CA ON PDV.idCadena = CA.idCadena
	WHERE 
		C.idCliente = @idCliente
		AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
	GROUP BY
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		R.idPuntoDeVenta,
		R.idEmpresa
	)
	SELECT 
		CONVERT(VARCHAR,R.FechaCreacion,103) Fecha,
		R.idReporte,
		PDV.Nombre PuntoDeVenta,
		PDV.Direccion,
		U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Usuario,
		CA.Nombre Cadena,
		LOC.Nombre Localidad,
		PROV.Nombre Provincia,
		Z.Nombre Zona,
		P.Nombre Producto,
		/*
		Los colores son arbitrarios (definido por Epson) y responden a combinaciones de los siguientes factores:

		Cantidad:
			Frentes
		Precio:
			Stock

		El filtro de Colores es super Custom para este grafico:
		EXEC GetFiltrosSemaforoTrade 222
		*/
		CASE WHEN @NumeroDePagina != -1 THEN
			N'<div style="text-align:center;"><img src="images/' + 
			CASE
				WHEN ISNULL(RP.Precio,0) > 0 AND ISNULL(RP.Cantidad,0) > 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 100 ) != 0 THEN N'circuloVerde.png'
				WHEN ISNULL(RP.Precio,0) > 0 AND ISNULL(RP.Cantidad,0) = 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 200 ) != 0 THEN N'circuloAmarillo.jpg'
				WHEN ISNULL(RP.Precio,0) = 0 AND ISNULL(RP.Cantidad,0) = 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 300 ) != 0 THEN N'circuloRojo.png'
				WHEN ISNULL(RP.Precio,0) = 0 AND ISNULL(RP.Cantidad,0) > 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 400 ) != 0 THEN N'circuloAzul.jpg'
				ELSE NULL
			END 
			+ N'" align="middle" width="16" height="16"/></div>' 
		--La exportacion a excel toma esta nomenclatura puntito+color sin ningun caracter extra ni espacios
		WHEN @NumeroDePagina = -1 THEN
			CASE
				WHEN ISNULL(RP.Precio,0) > 0 AND ISNULL(RP.Cantidad,0) > 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 100 ) != 0 THEN N'●#62F707'
				WHEN ISNULL(RP.Precio,0) > 0 AND ISNULL(RP.Cantidad,0) = 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 200 ) != 0 THEN N'●#FFFF00'
				WHEN ISNULL(RP.Precio,0) = 0 AND ISNULL(RP.Cantidad,0) = 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 300 ) != 0 THEN N'●#FF0000'
				WHEN ISNULL(RP.Precio,0) = 0 AND ISNULL(RP.Cantidad,0) > 0 AND (SELECT COUNT(1) FROM #Colores WHERE idColor = 400 ) != 0 THEN N'●#0000FF'
				ELSE NULL
			END
		END Circulo
	INTO
		#RAWDATA
	FROM 
		RPT
		INNER JOIN Reporte R ON RPT.idReporte = R.idReporte
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN Cadena CA ON PDV.idCadena = CA.idCadena
		INNER JOIN EpsonTradeProductosSellIn ETPS ON PDV.idCadena = ETPS.idCadena AND P.idProducto = ETPS.idProducto
		INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
		INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
		LEFT JOIN Localidad LOC on LOC.IdLocalidad = pdv.IdLocalidad
		LEFT JOIN Provincia PROV on PROV.IdProvincia = LOC.IdProvincia
		LEFT JOIN ZONA Z on Z.IdZona = PDV.IdZona
	WHERE 
		C.idCliente = @idCliente
		AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND ETPS.Fecha >= @dfFechaDesde
		AND ETPS.Fecha  <= @dfFechaHasta
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
	ORDER BY
		R.FechaCreacion,
		CA.Nombre,
		PDV.idPuntoDeVenta
	
	DELETE FROM #RAWDATA WHERE ISNULL(Circulo,'') = ''

	SET @Query = 
	'
	SELECT
		Fecha,
		idReporte,
		PuntoDeVenta,
		Direccion,
		Usuario,
		Cadena,
		Localidad,
		Provincia,
		Zona,
		{SelectProductos}
	FROM 
		(SELECT Fecha,
		idReporte,
		PuntoDeVenta,
		Direccion,
		Usuario,
		Cadena,
		Localidad,
		Provincia,
		Zona,
		Producto,
		Circulo FROM #RAWDATA) A
	PIVOT 
		(MIN(Circulo) 
	FOR 
		Producto
	IN (
		{SelectProductos}
		)) AS Piv
	'
	

	SELECT DISTINCT 
		Producto
	INTO 
		#SelectProductos 
	FROM 
		#RAWDATA

	SELECT 
		@SelectProductos = COALESCE(@SelectProductos + ',', '') + '['+CONVERT(VARCHAR,Producto)+']' 
	FROM 
		#SelectProductos

	SET @Query = REPLACE(@Query,'{SelectProductos}',@SelectProductos)
	
	--SELECT @Query
	EXEC sp_executesql @Query

	DROP TABLE #SelectProductos
	DROP TABLE #RAWDATA

	DROP TABLE #cadenas
	DROP TABLE #zonas
	DROP TABLE #localidades
	DROP TABLE #usuarios
	DROP TABLE #puntosdeventa
	DROP TABLE #marcas
	DROP TABLE #productos

END

GO
 

