IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_ProductoDistribucionZona_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Savant_ProductoDistribucionZona_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Savant_ProductoDistribucionZona_T20]
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
	DECLARE @MaxPag		INT

	DECLARE @Query			NVARCHAR(MAX)
	DECLARE @Zonas			VARCHAR(MAX)
	DECLARE @TotalZonas		VARCHAR(MAX)
	DECLARE @SelectZonas	VARCHAR(MAX)
	
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

	CREATE TABLE #vendedores
	(
		idVendedor INT
	)

	CREATE TABLE #tipoRtm
	(
		idTipoRtm INT
	)

	CREATE TABLE #Clientes
	(
		idCliente INT
	)

	CREATE TABLE #Marcas
	(
		idMarca	INT
	)

	CREATE TABLE #Productos
	(
		idProducto INT
	)


	DECLARE @cZonas					INT
	DECLARE @cCadenas				INT
	DECLARE @cLocalidades			INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cUsuarios				INT
	DECLARE @cVendedores			INT
	DECLARE @cTipoRtm				INT
	DECLARE @cClientes				INT
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT


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

	INSERT INTO #vendedores (idVendedor) SELECT clave AS idVendedor FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltVendedores'),',') WHERE ISNULL(clave,'') <> ''
	SET @cVendedores = @@ROWCOUNT

	INSERT INTO #tipoRtm (idTipoRtm) SELECT clave AS idTipoRtm FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoDeRTM'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoRtm = @@ROWCOUNT

	INSERT INTO #clientes (IdCliente) SELECT clave AS idCliente FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltClientes'),',') WHERE ISNULL(clave,'') <> ''
	SET @cClientes = @@ROWCOUNT

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT

	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT


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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	;WITH RPT AS
	(
	SELECT DISTINCT
		MAX(R.idReporte) idReporte,
		R.idPuntoDeVenta,
		R.idEmpresa
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		--INNER JOIN Usuario_Cliente CU on CU.idCliente = C.idCliente and CU.idUsuario = r.idUsuario
	WHERE 
		CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND C.idCliente = @idCliente
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = R.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
	GROUP BY
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		R.idPuntoDeVenta,
		R.idEmpresa
	)SELECT
		z.idZona idZona,
		Z.Nombre Zona,
		UPPER(P.Nombre) Producto,
		COUNT(DISTINCT Rpt.idPuntoDeVenta) Qty
	INTO 
		#TMP
	FROM 
		RPT
		INNER JOIN ReporteProducto RP ON RPT.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M	ON P.idMarca = M.idMarca
		INNER JOIN PuntoDeVenta PDV ON RPT.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN Zona Z ON PDV.idZona = Z.idZona
	WHERE 
		((ISNULL(Cantidad,0) + ISNULL(Cantidad2,0) != 0) 
		OR (ISNULL(RP.NoTrabaja,0) = 0 AND ISNULL(RP.Stock,0) = 0))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
	GROUP BY 
		Z.Nombre,
		P.Nombre,
		Z.idzona
		--------------------------------------------------------------------------------------------------------------------------------
		create table #reporte
	(
		idReporte int,
		IdPuntoDeVenta int,
		idEmpresa int)
	
	
	---Inserto el reporte 
	insert #reporte (idReporte, IdPuntoDeVenta,idEmpresa)
	SELECT DISTINCT
		MAX(R.idReporte),
		R.idPuntoDeVenta,
		R.idEmpresa
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		--INNER JOIN Usuario_Cliente CU on CU.idCliente = C.idCliente and CU.idUsuario = r.idUsuario

	WHERE 
		CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND C.idCliente = @idCliente
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = R.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
	GROUP BY
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		R.idPuntoDeVenta,
		R.idEmpresa
		
	---Inserto el relevados
	
	create table #relevados
	(
		idZona int,
		Zona varchar (80),
		qtyPuntoDeVenta int,
		productos varchar (80)
	)
	
	   insert #relevados (idZona,zona,qtyPuntoDeVenta,productos)
		SELECT Z.idZona,
		Z.Nombre, 
		COUNT(DISTINCT Rpt.idPuntoDeVenta),
		UPPER(P.Nombre)
		FROM 
		#reporte rpt
		INNER JOIN ReporteProducto RP ON RPT.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M	ON P.idMarca = M.idMarca
		INNER JOIN PuntoDeVenta PDV ON RPT.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN Zona Z ON PDV.idZona = Z.idZona
		where		
		 (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		GROUP BY 
		z.idZona, Z.Nombre, P.Nombre
	

	SET @Query = 
	'
	SELECT 
		Producto,
		{SelectZonas}
	INTO
		##TEST
	FROM 
		(SELECT DISTINCT Producto, Zona, 
		Qty FROM #TMP) A
	PIVOT 
		(MIN(Qty) 
	FOR 
		Zona
	IN (
		{Zonas}
		)) AS Piv
	
	ORDER BY Producto 
	'
	
	SELECT DISTINCT  
		idZona, Zona
	INTO 
		#SelectZonas 
	FROM 
		#TMP 
    
	SELECT COUNT(DISTINCT Zona) FROM #TMP
	
	--SELECT DISTINCT 0 Id, Zona name, Zona title,10 width FROM #TMP 
	--UNION
	--SELECT  1 Id,'Producto' name,'Producto' title ,10 width
	--ORDER BY Id DESC
	
    
	SELECT 
		@SelectZonas = COALESCE(@SelectZonas + ',', '') + 'ISNULL(['+CONVERT(VARCHAR,Zona)+ '],0) AS ' + '''' + Zona + ''''
	FROM 
		#SelectZonas
	SET @Query = REPLACE(@Query,'{SelectZonas}',@SelectZonas)
    
	SELECT 
		@Zonas = COALESCE(@Zonas + ',', '') + '['+CONVERT(VARCHAR,Zona)+']' 
	FROM 
		#SelectZonas
	SET @Query = REPLACE(@Query,'{Zonas}',@Zonas)
    
	--SELECT @Query
	EXEC sp_executesql @Query 
    
	SET @Query = '
	SELECT Producto, {SelectZonas} 
	INTO ##Resultado
	FROM (
	SELECT 0 Id,* FROM ##TEST
	UNION
	SELECT 1 Id,{TotalZonas} FROM ##TEST
	--ORDER BY Id ASC
	) A
	'
	
	BEGIN TRY
	SET @TotalZonas = '''TOTAL'''		
	SELECT 
		@TotalZonas = COALESCE(@TotalZonas + ',', '') + 'SUM(['+CONVERT(VARCHAR,Zona)+'])' 
	FROM 
		#SelectZonas
	SET @Query = REPLACE(@Query,'{TotalZonas}',@TotalZonas)
	SET @Query = REPLACE(@Query,'{SelectZonas}',@SelectZonas)
    
	--SELECT @Query
	EXEC sp_executesql @Query 
	END TRY  
    BEGIN CATCH  
		select 0 valor
    END CATCH
	-------------------------------------------------------------------------------------------------------------------------
	declare @Query2 nvarchar(max),
	@SelectZonas2  nvarchar(max),
	@Zonas2 nvarchar(max)
	
	SET @Query2 = 
	'
	SELECT 
		Producto,
		{SelectZonas2}
	INTO
		##TEST2
	FROM 
		(SELECT DISTINCT productos COLLATE DATABASE_DEFAULT producto,zona + ''_relevado'' as zona,
		qtyPuntoDeVenta	
		FROM #relevados) B
	PIVOT 
		(MIN(qtyPuntoDeVenta) 
	FOR 
		Zona
	IN (
		{Zonas2}
		)) AS Piv
	--ORDER BY Producto 
	'
	
	SELECT DISTINCT  
		idZona , Zona + '_relevado' as Zona
	INTO 
		#SelectZonas2
	FROM 
		#relevados 
   
	--SELECT COUNT(DISTINCT Zona) FROM #relevados
		
	--DROP TABLE ##TEST2
	SELECT 
		@SelectZonas2 = COALESCE(@SelectZonas2 + ',', '') + 'ISNULL(['+CONVERT(VARCHAR,Zona)+ '],0) AS ' + '''' + Zona + ''''
	FROM 
		#SelectZonas2
	SET @Query2= REPLACE(@Query2,'{SelectZonas2}',@SelectZonas2)
    
	SELECT 
		@Zonas2 = COALESCE(@Zonas2 + ',', '') + '['+CONVERT(VARCHAR,Zona)+']'
	FROM 
		#SelectZonas2
	SET @Query2 = REPLACE(@Query2,'{Zonas2}',@Zonas2)
    
	---SELECT @Query2
	EXEC sp_executesql @Query2 

	-------------------------------------------------------------------------
	
	SET @Query2 = '
	SELECT Producto, {SelectZonas2} 
	INTO ##Resultado2
	FROM (
	SELECT 0 Id,* FROM ##TEST2 
	UNION
	SELECT 1 Id,{TotalZonas2} FROM ##TEST2	
	) A
	'
	

	declare @TotalZonas2 varchar(max)
	
	SET @TotalZonas2 = '''TOTAL'''
    BEGIN TRY	
	SELECT 
		@TotalZonas2 = COALESCE(@TotalZonas2 + ',', '') + 'SUM(['+CONVERT(VARCHAR,Zona)+'])' 
	FROM 
		#SelectZonas2
	SET @Query2 = REPLACE(@Query2,'{TotalZonas2}',@TotalZonas2)
	SET @Query2 = REPLACE(@Query2,'{SelectZonas2}',@SelectZonas2)
    
--	SELECT @Query2
	EXEC sp_executesql @Query2 
	END TRY  
    BEGIN CATCH  
		select 0 valor
    END CATCH
	-------------------------------------------------

	--COLUMNAS CONFIGURACION

	SELECT  0 Id,'Producto' name,'Producto' title ,10 width
	union
	SELECT (idZona * 10) + 1 Id, zona collate database_default name, zona collate database_default title,10 width
	from #SelectZonas2
	union
	SELECT (idZona * 10) Id, zona collate database_default name, zona collate database_default title,10 width
	from #SelectZonas
	ORDER BY Id ASC
	


	----------------------------------------------------------------
	declare @queryFinal nvarchar(max)

	SET @QueryFinal = '
	SELECT r.Producto,{SelectZonas}, {SelectZonas2} 
	FROM ##Resultado r
	inner join ##Resultado2 r2
	on r2.Producto = r.producto collate database_default
	'
	SET @QueryFinal = REPLACE(@QueryFinal,'{SelectZonas}',@SelectZonas)
	SET @QueryFinal = REPLACE(@QueryFinal,'{SelectZonas2}',@SelectZonas2)	
	
	EXEC sp_executesql @QueryFinal 


	DROP TABLE ##TEST
	DROP TABLE ##Resultado2
	DROP TABLE ##Resultado
	DROP TABLE ##TEST2	
	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #vendedores
	DROP TABLE #tipoRtm
	DROP TABLE #Clientes
	DROP TABLE #TMP
	DROP TABLE #SelectZonas
	DROP TABLE #SelectZonas2

END

