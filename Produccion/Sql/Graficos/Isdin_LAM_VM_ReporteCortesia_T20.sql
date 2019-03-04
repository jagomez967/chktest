IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Isdin_LAM_VM_ReporteCortesia_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Isdin_LAM_VM_ReporteCortesia_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Isdin_LAM_VM_ReporteCortesia_T20]
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
	CREATE TABLE #tmpMod
	(
		idModulo INT
	)

	IF @idCliente = 175 BEGIN	--LAM ISDIN
		INSERT INTO #tmpMod VALUES
		(2168),	-- LAM IMPULSO
		(2091),	-- LAM VISITA FARMACIA
		(2363)	-- LAM ASESORA
	END

	IF @idCliente = 174 BEGIN	--VM ISDIN
		INSERT INTO #tmpMod VALUES
		(2131),	-- VM FARMACIAS
		(2113)	-- VM MEDICOS
	END

	SELECT
		ROW_NUMBER() OVER (ORDER BY R.FechaCreacion DESC) AS Id,
		--R.idReporte,
		CONVERT(VARCHAR(10),R.FechaCreacion,103) Fecha,
		ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre COLLATE DATABASE_DEFAULT,'') Usuario,
		C.Nombre Cliente,
		UPPER(PDV.Nombre) PuntoDeVenta,
		I.Nombre Producto,
		CASE WHEN RMI.Valor4 LIKE '%[a-zA-z]%' OR RMI.Valor4 = '' THEN '1' ELSE RMI.Valor4 END Cantidad
	INTO
		#DatosFinal
	FROM
		Reporte R
		INNER JOIN MD_ReporteModuloItem RMI ON R.idReporte = RMI.idReporte
		INNER JOIN MD_Item I ON RMI.idItem = I.idItem
		INNER JOIN MD_Modulo M ON I.idModulo = M.idModulo
		INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
		INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE 
		M.idModulo IN ( SELECT idModulo FROM #tmpMod)
		AND 1 = CASE WHEN ISNULL(RMI.Valor1,0) = 0 THEN CASE WHEN RMI.Valor4 LIKE '%[a-zA-z]%' OR RMI.Valor4 = '' THEN 0 ELSE 1 END ELSE 1 END
		--AND R.idReporte IN (631669)
		AND CONVERT(DATE, R.FechaCreacion) BETWEEN @fechaDesde AND @fechaHasta
		AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = R.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
	ORDER BY 
		R.FechaCreacion DESC

	SELECT 1 --@MaxPag

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Fecha','Fecha',10,0),
		('Usuario','Usuario',10,1),
		('Cliente','Cliente',10,2),
		('PuntoDeVenta','Punto de Venta',10,3),
		('Producto','Producto',10,4),
		('Cantidad','Cantidad',10,5)
		
	END

	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES
		('Fecha','Date',10,0),
		('Usuario','User',10,1),
		('Cliente','Client',10,2),
		('PuntoDeVenta','Point of Sale',10,3),
		('Producto','Product',10,4),
		('Cantidad','Quantity',10,5)
	END

	SELECT 
		Name, 
		Title, 
		Width 
	FROM 
		#ColumnasDef 
	ORDER BY 
		Orden, Name

	SELECT
		Fecha,
		Usuario,
		Cliente,
		PuntoDeVenta,
		Producto,
		Cantidad
	FROM 
		#DatosFinal
	ORDER BY 
		Fecha DESC

	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #vendedores
	DROP TABLE #tipoRtm
	DROP TABLE #Clientes
	DROP TABLE #DatosFinal
	DROP TABLE #ColumnasDef
	DROP TABLE #tmpMod

END