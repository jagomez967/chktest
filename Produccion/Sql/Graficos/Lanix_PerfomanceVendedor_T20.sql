IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_PerfomanceVendedor_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Lanix_PerfomanceVendedor_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].Lanix_PerfomanceVendedor_T20
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

	CREATE TABLE #Familia
	(
		idFamilia INT
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
	DECLARE @cFamilia				INT


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

	insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''
	set @cFamilia = @@ROWCOUNT


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
	create table #valores
	(
	
	nombre varchar (300),
	valor int,
	color varchar(max)
	)
	
	insert into #valores (nombre,valor,color)
	SELECT
		ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'') COLLATE DATABASE_DEFAULT AS nombre,
		SUM(Cantidad) valor,
		CASE WHEN SUM(Cantidad) <= 14 THEN '<div style="text-align:center;"><img src="images/circuloRojo.png" align="middle" width="16" height="16"/></div>'  
		ELSE (CASE WHEN SUM(Cantidad) < 21 THEN '<div style="text-align:center;"><img src="images/circuloAmarillo.jpg" align="middle" width="16" height="16"/></div>'
		ELSE '<div style="text-align:center;"><img src="images/circuloVerde.png" align="middle" width="16" height="16"/></div>'  
		END) END color
	FROM 
		Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
		INNER JOIN Cliente C ON	C.idEmpresa = R.idEmpresa
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE
		ISNULL(RP.Cantidad,0) != 0 
		AND CONVERT(DATE,R.FechaCreacion) >= @fechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @fechaHasta
		AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
		AND c.IdCliente = CASE @idCliente WHEN 147 THEN 144 ELSE @idCliente END
	GROUP BY
		
		U.Nombre,
		U.Apellido
		
	create table #datos_final 
	(
	id int identity (1,1),
	nombre varchar (300),
	valor int,
	color varchar(max)
	)
	
	insert into #datos_final (nombre,valor,color)	
	select nombre,valor,color
	FROM 
		#valores
	ORDER BY  valor desc
	
	SELECT 1 --@MaxPag

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('id','Puesto',5,1),('nombre','Nombre',5,2),('valor','Ventas',5,3),
		('color','Semaforo',5,4)
		
	END
	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES
			('nombre','Nombre',5,1),('valor','Ventas',5,2),
			('color','Semaforo',5,3)
	END

	SELECT 
		Name, 
		Title, 
		Width 
	FROM 
		#ColumnasDef 
	ORDER BY 
		Orden, Name

	select id,nombre,valor,color
	FROM 
		#datos_final
	
	

END
--go
--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20180821,20180920')
----insert into @p2 values(N'fltpuntosdeventa',N'99647')
-----insert into @p2 values(N'fltusuarios',N'3915')
----insert into @p2 values(N'fltMarcas',N'614')
--
--exec Lanix_PerfomanceVendedor_T20 @IdCliente=147,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'