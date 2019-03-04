IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_ResumenEquipos_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_ResumenEquipos_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Cob_ResumenEquipos_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
)
as
begin
/*
	
	Para filtrar en un query hacer:
	===============================
	*	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	*	(isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))

*/		

	SET LANGUAGE spanish
	set nocount on

	if @lenguaje = 'es' set language spanish
	if @lenguaje = 'en' set language english

	declare @strFDesde varchar(30)
	declare @strFHasta varchar(30)
	declare @fechaDesde datetime
	declare @fechaHasta datetime
	
	create table #fechaCreacionReporte
	(
		id int identity(1,1)
		,fecha	varchar(10)
	)

	create table #zonas
	(
		idZona int
	)

	create table #cadenas
	(
		idCadena int
	)

	create table #localidades
	(
		idLocalidad int
	)

	create table #puntosdeventa
	(
		idPuntoDeVenta int
	)

	create table #usuarios
	(
		idUsuario int
	)

	create table #marcas
	(
		idMarca int
	)

	create table #productos
	(
		idProducto int
	)

	create table #competenciaPrimaria
	(
		idMarcaComp int
	)

	create table #vendedores
	(
		idVendedor int
	)

	create table #tipoRtm
	(
		idTipoRtm int
	)

	create table #Provincias
	(
		idProvincia int
	)

	create table #Tags
	(
		IdTag int
	)
	create table #Familia
	(
		idFamilia int
	)
	create table #TipoPDV
	(
		idTipo int
	)

	declare @cMarcas varchar(max)
	declare @cProductos varchar(max)
	declare @cCadenas varchar(max)
	declare @cZonas varchar(max)
	declare @cLocalidades varchar(max)
	declare @cUsuarios varchar(max)
	declare @cPuntosDeVenta varchar(max)
	declare @cCompetenciaPrimaria varchar(max)
	declare @cVendedores varchar(max)
	declare @cTipoRtm varchar(max)
	declare @cProvincias varchar(max)
	declare @cTags varchar(max)
	declare @cFamilia varchar(max)
	declare @cTipoPDV varchar(max)

	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		

	insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	set @cMarcas = @@ROWCOUNT
	
	insert #productos (idproducto) select clave as idproducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProductos'),',') where isnull(clave,'')<>''
	set @cProductos = @@ROWCOUNT
	
	insert #cadenas (idCadena) select clave as idCadena from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCadenas'),',') where isnull(clave,'')<>''
	set @cCadenas = @@ROWCOUNT

	insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''
	set @cZonas = @@ROWCOUNT

	insert #localidades (idLocalidad) select clave as idLocalidad from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltLocalidades'),',') where isnull(clave,'')<>''
	set @cLocalidades = @@ROWCOUNT

	insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	set @cUsuarios = @@ROWCOUNT

	insert #puntosdeventa (idPuntoDeVenta) select clave as idPuntoDeVenta from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPuntosDeVenta'),',') where isnull(clave,'')<>''
	set @cPuntosDeVenta = @@ROWCOUNT

	insert #competenciaPrimaria (idMarcaComp) select clave as idMarcaComp from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
	set @cCompetenciaPrimaria = @@ROWCOUNT

	insert #vendedores (idVendedor) select clave as idVendedor from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltVendedores'),',') where isnull(clave,'')<>''
	set @cVendedores = @@ROWCOUNT

	insert #tipoRtm (idTipoRtm) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoDeRTM'),',') where isnull(clave,'')<>''
	set @cTipoRtm = @@ROWCOUNT

	insert #Provincias (idProvincia) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProvincias'),',') where isnull(clave,'')<>''
	set @cProvincias = @@ROWCOUNT

	insert #Tags (IdTag) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTags'),',') where isnull(clave,'')<>''
	set @cTags = @@ROWCOUNT
	
	insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''
	set @cFamilia = @@ROWCOUNT
	
	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT

	select @strFDesde = fecha from #fechaCreacionReporte where id = 2
	select @strFHasta = fecha from #fechaCreacionReporte where id = 3

	if(@strFDesde='00010101' or @strFDesde is null)
		set @fechaDesde = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2

	if(@strFHasta='00010101' or @strFHasta is null)
		set @fechaHasta = getdate()
	else
		select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #meses
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes,qty) select convert(varchar, @fechaDesdeMeses,112),0
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end


	create table #asignados
	(
		id int
		,idUsuario int
		,idPuntoDeVenta int
	)

	create table #datos
	(
		idEquipo int,
		qty int
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
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	declare @i int = 1
	declare @max int
	declare @currentFechaHasta datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU

		select @fechaHasta=dateadd(day,-1,DATEADD(month,1,mes)) from #meses where id=@i
		set @currentFechaHasta = dateadd(month,1,dateadd(day,-day(@fechaHasta),@fechaHasta))

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join usuario_cliente cu on cu.idcliente=pcu.idcliente and pcu.idusuario=cu.idusuario
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
		and pcu.idCliente = @idcliente
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta)
		select @i, idUsuario, IdPuntoDeVenta
		from #tempPCU
		
		set @i=@i+1
	end


	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))	
	group by c.IdCliente ,r.IdUsuario ,r.IdPuntoDeVenta ,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #datos (idEquipo, qty)
	select e.idEquipo, count(distinct a.idpuntodeventa) from #asignados a
	inner join Equipo_RTM e on e.idUsuario = a.idUsuario
	group by e.idEquipo


	create table #datosDist
	(
		idEquipo int,
		qty1 int,
		qty2 int
	)

	insert #datosDist (idEquipo, qty1, qty2)
	select e.idEquipo, count(distinct t.idPuntoDeventa), count(distinct t.idPuntoDeVenta)*100/d.qty from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Equipo_RTM e on e.idUsuario = t.idUsuario
	inner join #datos d on d.idEquipo = e.idEquipo
	where isnull(rp.Stock,0) = 0
	group by e.idEquipo, d.qty


	create table #datosExh
	(
		idEquipo int,
		qty1 int,
		qty2 int
	)

	insert #datosExh (idEquipo, qty1, qty2)
	select e.idEquipo, count(distinct t.idPuntoDeventa), count(distinct t.idPuntoDeVenta)*100/d.qty from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Equipo_RTM e on e.idUsuario = t.idUsuario
	inner join #datos d on d.idEquipo = e.idEquipo
	where isnull(rp.Cantidad,0) > 0
	group by e.idEquipo, d.qty
	

	create table #datosFac
	(
		idEquipo int,
		qty1 int,
		qty2 int
	)

	insert #datosFac (idEquipo, qty1)
	select e.idEquipo, sum(isnull(Cantidad,0))+sum(isnull(cantidad2,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Equipo_RTM e on e.idUsuario = t.idUsuario
	inner join #datos d on d.idEquipo = e.idEquipo
	group by e.idEquipo


	create table #datosQuiebre
	(
		idEquipo int,
		qty1 int,
		qty2 int
	)

	insert #datosQuiebre (idEquipo, qty1)
	select idEquipo, sum(qty) from (
	select e.idEquipo, 1 as qty from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Equipo_RTM e on e.idUsuario = t.idUsuario
	group by e.idEquipo, t.idreporte
	having count(distinct idproducto) = sum(stock)) as EE
	group by idEquipo


	create table #datosFinal
	(
		equipo varchar(max),
		q int,
		q2 int,
		q3 int,
		q4 int,
		q5 int,
		q6 int,
		q7 decimal(18,2),
		q8 int,
		q9 decimal(18,2)
	)


	insert #datosFinal (equipo, q,q2,q3,q4,q5,q6,q7,q8,q9)
	select	e.Nombre,
			d.qty,
			d1.qty1 as Dist,
			d1.qty2 as '%Dist',
			d2.qty1 as Exh,
			d2.qty2 as '% Exh',
			d3.qty1 as Fac,
			d3.qty1/d.qty as '% Fac',
			d4.qty1 as Quiebre,
			d4.qty1*100/d.qty as '% Quiebre'
			from #datos d
	inner join #datosDist d1 on d1.idEquipo = d.idEquipo
	inner join #datosExh d2 on d2.idEquipo = d.idEquipo
	inner join #datosFac d3 on d3.idEquipo = d.idEquipo
	left join #datosQuiebre d4 on d4.idEquipo = d.idEquipo
	inner join Equipo e on e.idEquipo = d.idEquipo
	union all
	select	'Total',
			sum(d.qty),
			sum(d1.qty1) as Dist,
			sum(d1.qty2)/count(distinct d.idEquipo) as '%Dist',
			sum(d2.qty1) as Exh,
			sum(d2.qty2)/count(distinct d.idEquipo) as '% Exh',
			sum(d3.qty1) as Fac,
			sum(d3.qty1/d.qty)/count(distinct d.idEquipo) as '% Fac',
			sum(d4.qty1) as Quiebre,
			sum(d4.qty1*100/d.qty) as '% Quiebre'
			from #datos d
	inner join #datosDist d1 on d1.idEquipo = d.idEquipo
	inner join #datosExh d2 on d2.idEquipo = d.idEquipo
	inner join #datosFac d3 on d3.idEquipo = d.idEquipo
	left join #datosQuiebre d4 on d4.idEquipo = d.idEquipo
	inner join Equipo e on e.idEquipo = d.idEquipo

		

	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal
	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (1,0,'idequipo','idEquipo',0), (0,1,'equipo','Equipo',50),(0,1,'q','Q PDV Total',30),(0,1,'q2','Distribucion',30),(0,1,'q3','Dist %',30),(0,1,'q4','Exhibicion',30),(0,1,'q5','Exh %',30),(0,1,'q6','Facing',30),(0,1,'q7','Facing prom',30),(0,1,'q8','Quiebre',30),(0,1,'q9','Quiebre %',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (1,0,'idequipo','idEquipo',0), (0,1,'equipo','Team',50),(0,1,'q','Q PDV',30),(0,1,'q2','Distribution',30),(0,1,'q3','Dist %',30),(0,1,'q4','Exhibition',30),(0,1,'q5','Exh %',30),(0,1,'q6','Facing',30),(0,1,'q7','Facing avg',30),(0,1,'q8','BOS',30),(0,1,'q9','BOS %',30)

	select esclave, mostrar, name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select equipo, q,q2,q3,q4,q5,q6,q7,q8,q9 from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select equipo, q,q2,q3,q4,q5,q6,q7,q8,q9 from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select equipo, q,q2,q3,q4,q5,q6,q7,q8,q9 from #datosFinal
end

