IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_Dist_SinExh_quiebre_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Cob_Dist_SinExh_quiebre_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Cob_Dist_SinExh_quiebre_T20]
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
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #Asignados
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		usuario varchar(200),
		localidad varchar(200),
		direccion varchar(200),
		idReporte int
	)

-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes,usuario, localidad,direccion, idReporte)
	select	c.IdCliente,
			r.IdUsuario,
			r.IdPuntoDeVenta,
			convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes,
			--left(convert(varchar,r.fechacreacion,112),8), 			
			ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default,
			ltrim(rtrim(l.nombre)),
			ltrim(rtrim(p.direccion)),
			max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and r.idusuario=cu.idusuario
	inner join usuario u on u.idUsuario = r.IdUsuario
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	
	
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),
	---left(convert(varchar,r.fechacreacion,112),8),
	ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default,ltrim(rtrim(l.nombre)),ltrim(rtrim(p.direccion))

	
	create table #Relevados
	(
		
		id_rep int,
		mes varchar(8),
		qty int
		
	)
	
	insert #Relevados (id_rep, qty,mes )
	select idReporte, count(distinct IdPuntoDeVenta),mes
	from #tempReporte t
	--inner join Reporte r on r.idReporte = t.idReporte
	group by idReporte,mes
	
	---select sum (qty)from #Relevados
	
	create table #NOAuditados
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)

	insert #NOAuditados (id_rep, qty,mes)
	select t.idReporte, isnull(count(distinct r.idPuntoDeventa),0),mes
	from #tempReporte t
	inner join Reporte r on r.idReporte = t.idReporte
	where r.AuditoriaNoAutorizada = 1
	group by t.idReporte,mes
	
	
	---select sum (qty) from #NOAuditados
	
	
	create table #aud
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)
	
	insert #aud (id_rep, qty,mes)
	select r.idreporte, 1,mes
	from #tempReporte t
	inner join Reporte r on r.idReporte = t.idReporte
	where r.AuditoriaNoAutorizada = 0
	
	
	create table #aud_Total
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)
	
	insert #aud_Total (id_rep, qty,mes)
	select t.id_rep, 1,t.mes
	from #Relevados t
	left join #aud a on a.id_rep = t.id_rep
	where not exists (select 1 from #Relevados 
	where id_rep = a.id_rep)

	
	---select * from #aud_Total
	

	create table #dist
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
		
	)

	insert #dist (id_rep, qty,mes)
	select t.idReporte, count(distinct t.idpuntodeventa),mes
	from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto prod on prod.idproducto = rp.idproducto
	inner join reporte r on r.idreporte=t.idreporte
	inner join marca m on m.idMarca = prod.idMarca 
	where  	not exists(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 
				and (isnull(ReporteProducto.notrabaja,0)>0
				or isnull(ReporteProducto.cantidad,0) > 0
				or isnull(ReporteProducto.cantidad2,0)> 0				
				or isnull(ReporteProducto.Stock,0) > 0)
	)
	and r.AuditoriaNoAutorizada = 0	
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by t.idReporte,mes
	
	---select sum (qty) from #dist
	
	
	--exhibicion
	create table #exh
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)

	insert #exh (id_rep,qty,mes)
	select t.idReporte, count(distinct t.idpuntodeventa),mes
	from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto prod on prod.idproducto = rp.idproducto
	inner join Reporte r on r.idreporte=t.idreporte
	where ((isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0))
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	and r.AuditoriaNoAutorizada = 0
	and not exists (select 1 from reporteProducto rp2
					inner join producto p2 on p2.idProducto =rp2.idProducto
					where rp2.idReporte = rp.idReporte
					and isnull(rp.Cantidad,0) + isnull(rp.Cantidad2,0) = 0 
						and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p2.idMarca))
						and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p2.idProducto))
				  )
	group by t.idReporte,mes

	---select sum (qty) from #exh
	
	
	create table #quiebre
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)

	insert #quiebre (id_rep, qty,mes)
	select t.idReporte, count(distinct t.idpuntodeventa),mes
	from #tempreporte t
	inner join reporte r on r.idreporte=t.idreporte
	inner join reporteProducto rp on rp.idreporte=r.idreporte
	inner join producto prod on prod.idproducto = rp.idproducto
	where r.auditorianoautorizada=0
	and not exists
	(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 			
				and ReporteProducto.stock=0
	)
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by t.idReporte,mes
	
	---select sum (qty) from #quiebre

	create table #notrabaja
	(
		id int identity(1,1),
		id_rep int,
		mes varchar(8),
		qty int
	)

	insert #notrabaja (id_rep,qty,mes)
	select t.idReporte, count(distinct t.idpuntodeventa),mes
	from #tempreporte t
	inner join reporte r on r.idreporte=t.idreporte
	inner join reporteProducto rp on rp.idreporte=r.idreporte
	inner join producto prod on prod.idproducto = rp.idproducto
	where r.auditorianoautorizada=0
	and not exists
	(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 
				and ReporteProducto.notrabaja=0
	)
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by t.idReporte,mes

---select sum (qty) from #notrabaja

	
	
	create table #quiebreparcial
	(
		id int identity(1,1),
		qty int
	)
	
	
	
	declare @sumTotal numeric(18,5)
	select @sumTotal=SUM(qty) 
	from #Asignados
	if(@sumTotal=0)
	begin
		delete from #dist
		delete from #exh
		delete from #quiebre
		delete from #PdvsNoTrabajanNada
	end
	
	--select * from #aud a
	--inner join #aud_Total t on  t.mes=A.mes
	
	
	create table  #final(
	id int identity(1,1),
	Fecha varchar(8),
	pdv varchar (200),
	Usuario varchar (max),
	direccion varchar (200),
	localidad varchar(200),
	Zona varchar(200),
	estado varchar(200)
	)
	 
	 
	 insert #final (Fecha, pdv, Usuario, direccion,localidad,Zona,estado)
			select	
			right(CONVERT(VARCHAR(11),convert(datetime, r.fechacreacion),6),6) as Fecha,
			isnull(v.nombre,0) as pdv,
			ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default as Usuario, 
			isnull(v.direccion,0) as direccion,
			isnull(l.nombre,0) as localidad,
			ltrim(rtrim(z.nombre)) as Zona,
			case 
			---when (isnull(t.qty,0) > 0) then 'Auditoria No autorizada'
			when (isnull(d.qty,0) > 0) then 'Distribucion sin Exhibicion'
			when (isnull(e.qty,0) > 0) then 'Exhibicion'
			when (isnull(q.qty,0) > 0) then 'Quiebre'
			when (isnull(n.qty,0) > 0) then 'No trabaja'
			when (isnull(A.qty,0) - (isnull(d.qty,0)+ isnull(e.qty,0) + isnull(q.qty,0) +isnull(n.qty,0) )>0) then 'Quiebre parcial'
			end
			from #aud A
			inner join Reporte r on r.idreporte=A.id_rep
			inner join PuntoDeVenta v on v.IdPuntoDeVenta=r.IdPuntoDeVenta
			inner join Localidad l on l.idLocalidad = v.idLocalidad
			inner join usuario u on u.idUsuario = r.IdUsuario
			inner join Zona z on z.IdZona = v.IdZona
			left join #dist d on d.id_rep=A.id_rep and d.mes=A.mes
			left join #exh e on e.id_rep=A.id_rep and e.mes=A.mes
			left join #quiebre q on q.id_rep=A.id_rep and q.mes=A.mes
			left join #notrabaja n on n.id_rep=A.id_rep and n.mes=A.mes
			--left join #aud_Total t on t.id_rep=A.id_rep and t.mes=A.mes
			
	create table  #final_rel(
		id int identity(1,1),
		Fecha varchar(8),
		pdv varchar (200),
		Usuario varchar (max),
		direccion varchar (200),
		localidad varchar(200),
		Zona varchar(200),
		estado varchar(200)
	)		
	
	insert #final_rel (Fecha, pdv, usuario, direccion,localidad,Zona,estado)	
	select Fecha, pdv, Usuario,direccion,localidad,Zona,estado
	from #final
	union
	select right(CONVERT(VARCHAR(11),convert(datetime, r.fechacreacion),6),6),
			isnull(v.nombre,0)collate database_default,
			ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default as Usuario,
			isnull(v.direccion,0) collate database_default,
			isnull(l.nombre,0) collate database_default,
			ltrim(rtrim(z.nombre)) collate database_default,
			'Auditoria No autorizada' collate database_default
	from #aud_Total A
	inner join Reporte r on r.idreporte=A.id_rep
	inner join PuntoDeVenta v on v.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on l.idLocalidad = v.idLocalidad
	inner join usuario u on u.idUsuario = r.IdUsuario
	inner join Zona z on z.IdZona = v.IdZona
	
	--select * from #final_rel

	SELECT 1 
	--Configuracion de columnas
	create table #ColumnasDef
	(
		name varchar(50),
		title varchar(50),
		width INT,
		orden INT
	)

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		 ('Fecha','Fecha',10,1),('pdv','pdv',10,2),('Usuario','Usuario',10,3),
		('direccion','direccion',10,4),('localidad','localidad',10,5),('Zona','Zona',10,6),('estado','estado',10,7)
	end
	IF ISNULL(@Lenguaje,'ES') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Fecha','Fecha',10,1),('pdv','pdv',10,2),('Usuario','Usuario',10,3),
		('direccion','direccion',10,4),('localidad','localidad',10,5),('Zona','Zona',10,6),('estado','estado',10,7)
	
	end
	
	SELECT Name, Title, Width FROM #ColumnasDef 
	ORDER BY Orden, Name
		
		
	select Fecha, pdv, Usuario, direccion,localidad,Zona,estado
	from #final_rel
	
			
end

--go
--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20181001,20181031')
-----insert into @p2 values(N'fltpuntosdeventa',N'21257')
-----insert into @p2 values(N'fltusuarios',N'3915')
----insert into @p2 values(N'fltMarcas',N'611')
--
--exec Cob_Dist_SinExh_quiebre_T20 @IdCliente=49,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'