IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_ShelfShareMarcaPropia_T1'))
   exec('CREATE PROCEDURE [dbo].[Savant_ShelfShareMarcaPropia_T1] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Savant_ShelfShareMarcaPropia_T1]
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
		DECLARE @MarcasColumns	VARCHAR(MAX)
		DECLARE @SelectMarcas	VARCHAR(MAX)
	
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
			idMarca INT
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
	
	;WITH DateTable
		AS
		(
			SELECT CAST(@FechaHasta AS DATETIME) Fecha, NULL Asignados, NULL Relevados
			UNION ALL
			SELECT CONVERT(DATETIME,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,Fecha),0))) , NULL Asignados, NULL Relevados
			FROM DateTable
			WHERE CONVERT(DATETIME,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,Fecha),0))) >= CAST(@FechaDesde AS DATE)
		)
		SELECT 
			CONVERT(DATE,Fecha) Fecha,
			Asignados,
			Relevados
		INTO 
			#TmpTotalesPdv
		FROM 
			DateTable

	UPDATE 
		T
	SET
		Relevados = (
			SELECT 
				COUNT(DISTINCT idPuntoDeVenta) 
			FROM
				(
				SELECT	C.idCliente,
						R.idUsuario,
						R.idPuntoDeVenta,
						CONVERT(VARCHAR, DATEADD(DAY, -(DAY(FechaCreacion) - 1), FechaCreacion),112) Mes
				FROM 
					Reporte R
					INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
					INNER JOIN Cliente C on C.idempresa = R.idempresa
				WHERE 
					CONVERT(DATE,FechaCreacion) BETWEEN CONVERT(DATE,CONVERT(DATETIME,DATEADD(mm, DATEDIFF(m,0,T.Fecha),0))) AND CONVERT(DATE,T.Fecha)
					AND C.idCliente = @idCliente
					AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
					AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
					AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
					AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
					AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
					AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = R.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
					AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
				) A
			GROUP BY 
				Mes
			) 
	FROM 
		#TmpTotalesPdv T

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
					AND PCU.idCliente = @idCliente
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
		#TmpTotalesPdv T 
	
	----------------
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
	),  
	DT AS
	(
		SELECT 1 Id, CAST(@FechaHasta AS DATE) Fecha, NULL Asignados, NULL Relevados, NULL Restantes, NULL Porcentaje
		UNION ALL
		SELECT Id + 1, CONVERT(DATE, DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, Fecha), 0))) , NULL Asignados, NULL Relevados, NULL Restantes, NULL Porcentaje
		FROM DT
		WHERE CONVERT(DATE, DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, Fecha), 0))) >= CAST(@FechaDesde AS DATE)
	)
	SELECT
		Dt.Id,
		LEFT(DATENAME(MONTH,DT.Fecha),3) + '-' + RIGHT(YEAR(DT.Fecha),2) +  '  Relevados:' + convert(varchar(12),t.Relevados) Fecha, 
		M.idMarca,
		M.Nombre,
		CONVERT(NUMERIC(18,1),SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0))) Qty
	INTO 
		#TMP
	FROM 
		RPT 
		INNER JOIN ReporteProducto RP ON RPT.idReporte = RP.idReporte
		INNER JOIN Reporte RE ON RP.idReporte = RE.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		RIGHT JOIN DT ON LEFT(DATENAME(MONTH,DT.Fecha),3) + '-' + RIGHT(YEAR(DT.Fecha),2) = LEFT(DATENAME(MONTH,RE.FechaCreacion),3) + '-' + RIGHT(YEAR(RE.FechaCreacion),2)
		INNER JOIN #TmpTotalesPdv T on t.fecha = DT.Fecha
	WHERE 
		((ISNULL(RPT.idReporte,0) = 0)
		OR (ISNULL(Cantidad,0) + ISNULL(Cantidad2,0) != 0))
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
	GROUP BY
		DT.Id,
		LEFT(DATENAME(MONTH,DT.Fecha),3) + '-' + RIGHT(YEAR(DT.Fecha),2),
		M.idMarca,
		M.Nombre,
		t.Relevados
	ORDER BY 
		DT.Id DESC
	
	--SELECT Fecha,Nombre,CONVERT(NUMERIC(18,1),CONVERT(NUMERIC(18,1),Qty*100)/(SELECT SUM(Qty) FROM #TMP WHERE Fecha = T.Fecha)) FROM #TMP T
	UPDATE T SET Qty = CONVERT(NUMERIC(18,1),CONVERT(NUMERIC(18,1),Qty*100)/(SELECT SUM(Qty) FROM #TMP WHERE Fecha = T.Fecha)) FROM #TMP T  

	SET @Query = 
	'
	SELECT 
		Fecha,
		{SelectMarcas}
	FROM 
		(SELECT DISTINCT Id, Fecha,
		Nombre,
		Qty FROM #TMP) A
	PIVOT 
		(MIN(Qty) 
	FOR 
		Nombre 
	IN (
		{Marcas}
		)) AS Piv
	ORDER BY Id DESC
	'
	SELECT DISTINCT  
		Nombre 
	INTO 
		#SelectMarcas 
	FROM 
		#TMP 
	ORDER BY 
		Nombre

	SELECT name,title FROM
	(
	SELECT 1 Id, 'Fecha' name,'Mes' title
	UNION
	SELECT 2, Nombre,Nombre FROM #SelectMarcas
	) A

	
	SELECT 
		@SelectMarcas = COALESCE(@SelectMarcas + ',', '') + 'ISNULL('+Nombre+',0) ' + Nombre
	FROM 
		#SelectMarcas
	SET @Query = REPLACE(@Query,'{SelectMarcas}',@SelectMarcas)

	
	SELECT 
		@MarcasColumns = ISNULL(@MarcasColumns,'') + '[' +  Nombre + '],'
	FROM 
		(SELECT DISTINCT Nombre FROM #TMP) A
	SET @MarcasColumns = LEFT(@MarcasColumns,LEN(@MarcasColumns) - 1)
	SET @Query = REPLACE(@Query,'{Marcas}',@MarcasColumns)
	
	--SELECT @Query
	EXEC sp_executesql @Query

	SELECT 
		SUM(Asignados) 'Total PDV',
		SUM(Relevados) 'PDV Relevados' 
	FROM 
		#TmpTotalesPdv

	SELECT 1
		
	DROP TABLE #TmpTotalesPdv
	DROP TABLE #SelectMarcas
	DROP TABLE #TMP
	DROP TABLE #fechaCreacionReporte
	DROP TABLE #zonas
	DROP TABLE #cadenas
	DROP TABLE #localidades
	DROP TABLE #puntosdeventa
	DROP TABLE #usuarios
	DROP TABLE #vendedores
	DROP TABLE #tipoRtm
	DROP TABLE #Clientes
END