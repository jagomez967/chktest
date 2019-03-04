IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GardenPE_VentaEfectiva_T9'))
   exec('CREATE PROCEDURE [dbo].[GardenPE_VentaEfectiva_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[GardenPE_VentaEfectiva_T9]
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
	
	if(@FechaDesde = @FechaHasta)
		set @FechaHasta = dateadd(second,-1,dateadd(day,1,@FechaDesde))
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #tempReporte
	(
		id int identity(1,1),
		IdReporte int,
		año int,
		mes int,
		dia int,
		idPuntoDeVenta int,
		idUsuario int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------


	insert #tempReporte (IdReporte, año,mes,dia,idPuntoDeVenta,idUsuario)
	select max(r.idReporte),
		   datepart(year,r.fechaCreacion),
		   datepart(month,r.fechaCreacion),
		   datepart(day,r.fechaCreacion),
		   r.idPuntoDeVenta,
		   u.idUsuario
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	inner join usuario u on u.idUsuario = r.idUsuario
	where   c.idCliente= @IdCliente
			and r.FechaCreacion between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and isnull(u.escheckpos,0) = 0
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and isnull(u.esCheckPos,0)=0
	group by	
		   datepart(year,r.fechaCreacion),
		   datepart(month,r.fechaCreacion),
		   datepart(day,r.fechaCreacion),
	r.idPuntoDeVenta	, u.idUsuario
	
	create table #DatosParcial
	(
		idUsuario int,
		cantidad int,
		año int,
		mes int,
		objetivo int,
		cumplimiento as ((cantidad*100.0)/objetivo)
	)
	
	insert #datosParcial(idUsuario,cantidad,año,mes)
	select t.idUsuario,  count(t.idReporte), t.año,t.mes
	from #tempreporte t
	--inner join reportePOP rp on rp.idReporte = t.idReporte
	where exists (select 1 from reportePOP where idReporte = t.idReporte)
	group by t.idUsuario, t.año,t.mes

	update dp
	set objetivo = gc.ventaEF 
	from #datosParcial dp
	inner join gardenPE_ClienteVentaEfectiva gc
	on gc.idZona = dp.idUsuario
	and gc.mes = dp.mes
	and gc.año = dp.año



	create table #datosFinal
	(
		id int identity(1,1),
		fecha datetime,
		zona varchar(200),
		realCuota int,
		Objetivo int,
		cumplimiento decimal(5,2)
	)
	insert #datosFinal(fecha,zona,realcuota,objetivo,cumplimiento)
	select convert(date,cast(dp.año as varchar)+ right('00' + cast(dp.mes as varchar),2) + '01') as Fecha,
		   u.usuario,
		   dp.cantidad,
		   dp.objetivo,
		   dp.cumplimiento
	from #datosParcial dp 
	inner join usuario u on u.idUsuario = dp.idUsuario


	
	--Cantidad de páginas
	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Fecha',5),('Zona','Zona',5),('realCuota','Ventas',5),('Objetivo','Objetivo',5),('cumplimiento','%',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Date',5),('Zona','Zone',5),('realCuota','Sales',5),('Objetivo','Target',5),('cumplimiento','%',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select datename(month,Fecha) + ' ' + cast(year(Fecha) as varchar) as Fecha,Zona,realCuota,Objetivo,cast(Cumplimiento as varchar)+' %' as cumplimiento from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select datename(month,Fecha) + ' ' + cast(year(Fecha) as varchar) as Fecha,Zona,realCuota,Objetivo,cast(Cumplimiento as varchar)+' %' as cumplimiento from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select datename(month,Fecha) + ' ' + cast(year(Fecha) as varchar) as Fecha,Zona,realCuota,Objetivo,cast(Cumplimiento as varchar)+' %' as cumplimiento from #datosFinal
	
end
--GardenPE_VentaEfectiva_T9 81


