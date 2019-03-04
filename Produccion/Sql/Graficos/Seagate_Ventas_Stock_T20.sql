IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Seagate_Ventas_Stock_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Seagate_Ventas_Stock_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].Seagate_Ventas_Stock_T20
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
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

		create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		usuario varchar(300),
		idReporte int
	)
   create table #datosFinal
	(
		id int identity(1,1),
		Fecha	VARCHAR(30),
		idPuntoDeVenta int,
		PuntoDeVenta varchar(100),
		Usuario varchar(100),
		direccion varchar(100),
		Zona varchar(100),
		Producto varchar(100),
		marca varchar(100),
		Frentes1 int,
		Frentes2 int
		
	)
   
  
  -------------------------------------------------------------------- END (Tablas de trabajo) ----------------------------------------------------------------  

  insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte,usuario)
	select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte),ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Usuario u on u.IdUsuario = r.idUsuario
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6),
	ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default


	insert #datosFinal (Fecha,idPuntoDeVenta, PuntoDeVenta, Usuario,direccion,Zona, Producto, marca, Frentes1, Frentes2 )
	select	convert(varchar(50),r1.fechacreacion,106),
			pdv.IdPuntoDeVenta,
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(r.usuario)),
			ltrim(rtrim(pdv.direccion)),
		    ltrim(rtrim(z.Nombre)),
			ltrim(rtrim(p.Nombre)),
			ltrim(rtrim(m.Nombre)),
			isnull(rp.Cantidad,0),
			isnull(rp.Cantidad2,0)			
	from ReporteProducto rp
		inner join #reportesMesPdv r on r.IdReporte = rp.IdReporte
		inner join Producto p on p.IdProducto = rp.IdProducto
		inner join Marca m on m.IdMarca = p.IdMarca
		inner join reporte r1 on r1.idReporte = r.idreporte
		inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
		inner join Zona z on z.IdZona = pdv.IdZona
		where (isnull(rp.Cantidad,0)>0 or isnull(rp.Cantidad2,0)>0 )
		and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	order by pdv.Nombre
	
	SELECT 1 --@MaxPag

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Fecha','Fecha',5,1),('PuntoDeVenta','PuntoDeVenta',5,2),
		('Usuario','Usuario',5,3),('direccion','direccion',5,4),('Zona','Zona',5,5),('Producto','Producto',5,6), ('marca','Marca',5,7), 
		('Frentes1','Ventas',5,8),('Frentes2','Stock',5,9)
	END

	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES
		('Fecha','Fecha',5,1),('PuntoDeVenta','PuntoDeVenta',5,2),
		('Usuario','Usuario',5,3),('direccion','direccion',5,4),('Zona','Zona',5,5),('Producto','Producto',5,6), ('marca','Marca',5,7), 
		('Frentes1','Ventas',5,8),('Frentes2','Stock',5,9)
		
	END

	SELECT 
		Name, 
		Title, 
		Width 
	FROM 
		#ColumnasDef 
	ORDER BY 
		Orden, Name

	select Fecha,PuntoDeVenta,Usuario,direccion,Zona,Producto,marca,Frentes1,Frentes2
	FROM 
		#DatosFinal
	ORDER BY 
		Fecha DESC

END