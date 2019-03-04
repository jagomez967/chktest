IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_PdvDistribucionZona_T20'))
   exec('CREATE PROCEDURE [dbo].[Savant_PdvDistribucionZona_T20] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Savant_PdvDistribucionZona_T20] 	
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
)
as
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

	CREATE TABLE #ColumnasDef
	(
		Name	VARCHAR(100),
		Title	VARCHAR(100),
		Width	INT,
		Orden	INT
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

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltMarcas'),',') WHERE ISNULL(clave,'')<>''
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
		R.idEmpresa,
		LEFT(CONVERT(varchar, r.FechaCreacion,112),6) fecha
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		---INNER JOIN Usuario_Cliente CU on CU.idCliente = C.idCliente and CU.idUsuario = r.idUsuario
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
		R.idEmpresa,		
		LEFT(CONVERT(varchar, r.FechaCreacion,112),6) 
	)
	
	SELECT 
		Z.idZona,
		Z.Nombre Zona,
		COUNT(DISTINCT Rpt.idPuntoDeVenta) Qty,
		rpt.fecha		
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
		Z.idZona,Z.Nombre,rpt.fecha
			
	
	create table #reporte
	(
		idReporte int,
		IdPuntoDeVenta int,
		idEmpresa int,
		fecha char(6)
	)
	
	create table #relevados
	(		
		qtyPuntoDeVenta int,
		idzona int,
		zona varchar (100),
		fecha char(6)
	)
	
	
		
	insert #reporte (idReporte, IdPuntoDeVenta,idEmpresa,fecha)
	SELECT DISTINCT
		MAX(R.idReporte),
		R.idPuntoDeVenta,
		R.idEmpresa,
		LEFT(CONVERT(varchar,r.FechaCreacion,112),6)
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		---INNER JOIN Usuario_Cliente CU on CU.idCliente = C.idCliente and CU.idUsuario = r.idUsuario

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
		R.idEmpresa,
		LEFT(CONVERT(varchar, r.fechaCreacion,112),6)

		
		insert #relevados (idzona,zona,qtyPuntoDeVenta,fecha)
		SELECT 
		Z.idZona,
		Z.Nombre, 
		COUNT(DISTINCT Rpt.idPuntoDeVenta),
		rpt.fecha	
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
		Z.idZona,Z.Nombre,rpt.fecha
		

	
	SELECT 1 Id,t.Zona,t.Qty as cantidadPDV,r.qtyPuntoDeVenta as Relevados
       ,t.fecha
	  	INTO #DatosFinal 
	FROM #tmp t
	INNER JOIN #relevados r on r.idzona = t.idzona	
	and r.fecha = t.fecha    
	UNION
	SELECT 2 Id,'Total', SUM(t.Qty) as cantidadPDV,SUM(r.qtyPuntoDeVenta) as Relevados,t.fecha
	FROM #TMP t
	INNER JOIN #relevados r on r.zona = t.zona	collate database_default 
	and r.fecha = t.fecha 
	group by t.fecha

------------------------------------------------------------------------------------

DECLARE @MesesCant VARCHAR(MAX)
	SELECT @MesesCant = 
	  COALESCE(
		@MesesCant + ',[' + fecha + 'cant]',
		'['+fecha+'cant]' 
	  ) 	FROM (select distinct fecha from #DatosFinal)x

DECLARE @MesesRel VARCHAR(MAX)
	SELECT @MesesRel = 
	  COALESCE(
		@MesesRel + ',[' + fecha + 'rel]',
		'['+fecha+'rel]' 
	  ) 	FROM (select distinct fecha from #DatosFinal)x


----------------------------------------------------------------------------

DECLARE @MesesMax VARCHAR(MAX)
	SELECT @MesesMax = 
	  COALESCE(
	  @MesesMax + ',max(['+ fecha + 'cant]) as [CantidadPDV_'+fecha + '],max(['+ fecha + 'rel]) as [Relevados_'+fecha +']' 
	  ,
		'max(['+ fecha + 'cant]) as [CantidadPDV_' + fecha+ '],max(['+ fecha + 'rel]) as [Relevados_'+fecha+']' 
	  ) 	FROM (select distinct fecha from #DatosFinal)x


select 1

IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Zona','Zona',10,0)
	
	END

	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Zona','Zone',10,0)		
		
	END

	insert into #ColumnasDef (name,title,width,Orden) 			
	select  'CantidadPDV_' + fecha ,'Cantidad PDV ' + datename(month,convert(datetime,fecha+'01',112)),10,ROW_NUMBER() OVER(ORDER BY fecha ASC) *10 from (select distinct fecha from #DatosFinal)x 
	UNION
	select  'Relevados_' + fecha ,'Relevados ' + datename(month,convert(datetime,fecha+'01',112)),10,(ROW_NUMBER() OVER(ORDER BY fecha ASC)*10 )+ 1 from (select distinct fecha from #DatosFinal)x 
	

	SELECT 
		Name, 
		Title, 
		Width 
	FROM 
		#ColumnasDef 
	ORDER BY 
		Orden, Name


	declare @Query nvarchar(max) = 'SELECT  Zona, '+@MesesMax+'
	FROM  
	(SELECT zona, CantidadPDV,relevados, Fecha +''cant'' as fechaCant, fecha  + ''rel'' as fechaRel
    FROM #DatosFinal) AS SourceTable		
	PIVOT  
	(  
	AVG(CantidadPDV)  
	FOR FechaCant IN ('+@MesesCant+')  
	) AS PivotCantidad  
	PIVOT 
	(  
	AVG(Relevados)  
	FOR FechaRel IN ('+@MesesRel+')  
	) AS PivotRelevado  
	group by zona'

	EXEC sp_executesql @Query 
	
	
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
	DROP TABLE #DatosFinal
	DROP TABLE #ColumnasDef
	
END
GO


/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181001,20181226')
--insert into @p2 values(N'fltpuntosdeventa',N'189279')
--insert into @p2 values(N'fltusuarios',N'3976')
--insert into @p2 values(N'fltMarcas',N'2464')
exec Savant_PdvDistribucionZona_T20 @IdCliente=49,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/