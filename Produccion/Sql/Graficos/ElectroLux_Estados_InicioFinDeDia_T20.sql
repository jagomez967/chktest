IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ElectroLux_Estados_InicioFinDeDia_T20'))
   EXEC('CREATE PROCEDURE [dbo].[ElectroLux_Estados_InicioFinDeDia_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].ElectroLux_Estados_InicioFinDeDia_T20
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
	 create table #datos_Inicio
	(
		id int identity(1,1),
		Cliente	VARCHAR(30),
		Usuario varchar(100),
		Fecha varchar(20),
		Fecha_Hora datetime,
		Hora varchar(8),
		AccionTipo varchar(100),
		Id_Tipo int,
		id_usuario int,
		id_cliente int
		
	)
	
	insert into #datos_Inicio (cliente, usuario,fecha,AccionTipo,Hora,Id_Tipo,id_usuario,id_cliente,Fecha_Hora)
	select  l.nombre as cliente, ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default as Usuario,  max(convert(varchar,el.FechaHora,103))as Fecha, e.Nombre as AccionTipo, convert(char(8), el.FechaHora, 108),e.id,uc.idUsuario,uc.idCliente,	el.FechaHora
	from Usuario u
	inner join EstadosLog el on el.IdUsuario=u.IdUsuario
	inner join Estados e on e.Id=el.IdEstado
	inner join EstadosClientes ec on ec.IdEstado = e.Id
    inner join usuario_cliente uc on uc.idUsuario = u.idUsuario and uc.idCliente = ec.idCliente
	inner join Cliente l on l.idCliente = ec.idCliente
	and e.id = 13
	where convert(date,el.FechaHora) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		and exists(select 1 from #clientes where idCliente = ec.idCliente)
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = u.IdUsuario)) and isnull(u.esCheckPos,0) = 0
	group by u.IdUsuario, u.Apellido, u.Nombre, e.Nombre,l.nombre,el.FechaHora,e.id,uc.idUsuario,uc.idCliente	
	
	
	 create table #datos_Fin
	(
		id int identity(1,1),
		Cliente	VARCHAR(30),
		Usuario varchar(100),
		Fecha varchar(20),
		Hora varchar(8),
		Fecha_Hora datetime,
		AccionTipo varchar(100),
		Id_Tipo int,
		id_usuario int,
		id_cliente int
		
	)
	
	insert into #datos_Fin (cliente, usuario,fecha,AccionTipo,Hora,Id_Tipo,id_usuario,id_cliente,Fecha_Hora)
	select  l.nombre as cliente, ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default as Usuario,  max(convert(varchar,el.FechaHora,103))as Fecha, e.Nombre as AccionTipo,convert(char(8), el.FechaHora, 108) ,e.id,uc.idUsuario,uc.idCliente, el.FechaHora
	from Usuario u
	inner join EstadosLog el on el.IdUsuario=u.IdUsuario
	inner join Estados e on e.Id=el.IdEstado
	inner join EstadosClientes ec on ec.IdEstado = e.Id
    inner join usuario_cliente uc on uc.idUsuario = u.idUsuario and uc.idCliente = ec.idCliente
	inner join Cliente l on l.idCliente = ec.idCliente
	and e.id = 14
	where convert(date,el.FechaHora) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		and exists(select 1 from #clientes where idCliente = ec.idCliente)
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = u.IdUsuario)) and isnull(u.esCheckPos,0) = 0
	group by u.IdUsuario, u.Apellido, u.Nombre, e.Nombre,l.nombre,el.FechaHora,e.id,uc.idUsuario,uc.idCliente	
	
	
	create table #Datos_Final
	(
	Cliente varchar(200),
	Usuario varchar (200),
	Fecha varchar(100),
	Hora_Inicio varchar(20),
	Hora_Fin varchar(20),
	Horas_Trabajadas varchar(200),
	Reportes int)
	
	Insert into #Datos_Final(Cliente,Usuario,Fecha,Hora_Inicio,Hora_Fin,Horas_Trabajadas,Reportes) 
	SELECT  a.cliente, a.usuario,a.fecha,B.Hora as 'Inicio del Dia',A.Hora as 'Fin del Dia',CONVERT(varchar(5),DATEADD(minute,DATEDIFF(minute,b.hora, a.hora),0), 114) as 'Horas trabajadas', count (r.idreporte) as reporte
	from #datos_Fin a
	inner join #datos_Inicio b on a.id_usuario =  b.id_usuario  and a.fecha =b.fecha
	left join Reporte R on r.idUsuario = a.id_Usuario
	where  r.fechacreacion between b.Fecha_Hora and a.Fecha_Hora
	group by a.cliente, a.usuario,a.fecha,B.Hora,A.Hora

	SELECT 1 --@MaxPag

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Usuario','Usuario',5,1),('Fecha','Fecha',5,2),
		('Hora_Inicio','Hora_Inicio',5,3),('Hora_Fin','Hora_Fin',5,4),
		('Horas_Trabajadas','Horas_Trabajadas',5,5),('Reportes','Reportes',5,6)
		
	END
	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES
		('Usuario','User',5,1),('Fecha','Date',5,2),
		('Hora_Inicio','Hour_Inicio',5,3),('Hora_Fin','Hour_End',5,4),
		('Horas_Trabajadas','Horas_Trabajadas',5,5),('Reportes','Reportes',5,6)
	END

	SELECT 
		Name, 
		Title, 
		Width 
	FROM 
		#ColumnasDef 
	ORDER BY 
		Orden, Name

	select Usuario,Fecha,Hora_Inicio,Hora_Fin,Horas_Trabajadas,Reportes
	FROM 
		#Datos_Final
	ORDER BY 
		Fecha 
    
END
GO