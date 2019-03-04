IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_PdvAsignadoMes_T2'))
   EXEC('CREATE PROCEDURE [dbo].[Savant_PdvAsignadoMes_T2] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Savant_PdvAsignadoMes_T2]
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

	;WITH DateTable
	AS
	(
		SELECT CAST(@FechaHasta AS DATETIME) Fecha, NULL Asignados
		UNION ALL
		SELECT CONVERT(DATETIME,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,Fecha),0))) , NULL Asignados
		FROM DateTable
		WHERE CONVERT(DATETIME,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,Fecha),0))) >= CAST(@FechaDesde AS DATE)
	)
	SELECT 
		CONVERT(DATE,Fecha) Fecha,
		Asignados
	INTO 
		#Tmp 
	FROM 
		DateTable

	UPDATE 
		T 
	SET 
		Asignados = (
			SELECT 
				COUNT(A.idPuntoDeVenta)
			FROM
				(
				SELECT	
						T.Fecha Fecha,
						PCU.idPuntoDeVenta,
						MAX(PCU.IdPuntoDeVenta_Cliente_Usuario) Id
				FROM 
					PuntoDeVenta_Cliente_Usuario PCU
					INNER JOIN PuntoDeVenta PDV ON PCU.idPuntoDeVenta = PDV.idPuntoDeVenta
				WHERE 
					CONVERT(DATE, Fecha) <= CONVERT(DATE,T.Fecha)
					AND  PCU.idCliente = @idCliente
					AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
					AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
					AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
					AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
					AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = PCU.IdUsuario)) AND PCU.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
					AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = PCU.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
					AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = PCU.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
				GROUP BY 
					PCU.idUsuario, 
					PCU.idPuntoDeVenta
				) A
			WHERE 
				(SELECT COUNT(1) FROM PuntoDeVenta_Cliente_Usuario PCU2 WHERE PCU2.IdPuntoDeVenta_Cliente_Usuario=A.Id and PCU2.Activo=0) = 0
			)
	FROM 
		#Tmp T 

	SELECT
		ROW_NUMBER() OVER (ORDER BY Fecha) AS Id,
		LEFT(DATENAME(MONTH,Fecha),3) + '-' + RIGHT(DATENAME(YEAR,Fecha),2) Periodo,
		Asignados
	INTO
		#DatosFinal
	FROM 
		#Tmp
	WHERE
		ISNULL(Asignados, 0) != 0
	ORDER BY 
		Fecha

	
	SELECT 
		Periodo,
		Asignados
	FROM 
	(
	SELECT
		Id,
		Periodo,
		Asignados
	FROM 
		#DatosFinal
	UNION
	SELECT
		(SELECT MAX(Id) FROM #DatosFinal) + 1 ,
		'Total' Periodo, 
		SUM(Asignados)
	FROM 
		#DatosFinal
	WHERE
		ISNULL(Asignados, 0) != 0
	) A
	ORDER BY 
		Id

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

END