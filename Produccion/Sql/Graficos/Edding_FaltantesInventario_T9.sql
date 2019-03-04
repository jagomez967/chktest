IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_FaltantesInventario_T9'))
   exec('CREATE PROCEDURE [dbo].[Edding_FaltantesInventario_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Edding_FaltantesInventario_T9] 	
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

	create table #Clientes
	(
		idCliente int
	)

	create table #Pop
	(
		idPop int
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
	declare @cClientes varchar(max)
	declare @cPop varchar(max)

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

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #Pop (idPop) select clave as idPop from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPop'),',') where isnull(clave,'')<>''
	set @cPop = @@ROWCOUNT


	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end

	select @strFDesde = fecha from #fechaCreacionReporte where id = 2
	select @strFHasta = fecha from #fechaCreacionReporte where id = 3

	if(@strFDesde='00010101' or @strFDesde is null)
		set @fechaDesde=dateadd(month,-3,dateadd(day,-day(getdate())+1,getdate()))
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

	declare @fechaDesdePrimerPeriodo datetime
	declare @fechaHastaPrimerPeriodo datetime
	set @fechaDesdePrimerPeriodo = dateadd(month,datediff(month,0,@fechaDesde),0)
	set @fechaHastaPrimerPeriodo = dateadd(day,-1,dateadd(month,datediff(month,-1,@fechaDesde),0))

	declare @fechaDesdeUltimoPeriodo datetime
	declare @fechaHastaUltimoPeriodo datetime
	set @fechaDesdeUltimoPeriodo = dateadd(month,datediff(month,0,@fechaHasta),0)
	set @fechaHastaUltimoPeriodo = dateadd(day,-1,dateadd(month,datediff(month,-1,@fechaHasta),0))


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

	create table #Relevados
	(
		idUsuario int
		,qty int
	)

	create table #Visitados
	(
		idUsuario int
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

	create table #tempReportePrimerPeriodo
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #tempReporteUltimoPeriodo
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		pdv varchar(500),
		direccion varchar(500),
		zona varchar(500),
		pop varchar(500),
		estado varchar(100)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	declare @i int = 1
	declare @max int
	declare @currentFechaHasta datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU

		--select @fechaHasta=dateadd(day,-1,DATEADD(month,1,mes)) from #meses where id=@i
		set @currentFechaHasta = dateadd(month,1,dateadd(day,-day(@fechaHasta),@fechaHasta))

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
		and exists(select 1 from #clientes where idCliente = pcu.idCliente)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta)
		select @i, idUsuario, IdPuntoDeVenta
		from #tempPCU
		
		set @i=@i+1
	end

	insert #tempReportePrimerPeriodo (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesdePrimerPeriodo) and convert(date,@fechaHastaPrimerPeriodo)
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #tempReporteUltimoPeriodo (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesdeUltimoPeriodo) and convert(date,@fechaHastaUltimoPeriodo)
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	create table #datosPerAnt
	(
		idPuntoDeVenta int,
		idPop int,
		qty int
	)
	
	create table #datosPerUlt
	(
		idPuntoDeVenta int,
		idPop int,
		qty int
	)


	insert #datosPerAnt (idPuntoDeVenta, idPop)
	select t.idPuntoDeVenta, p.idPop from #tempReportePrimerPeriodo t, Pop p
	inner join Pop_Marca pm on pm.idPop = p.idPop
	where p.idCliente = @idCliente
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pm.IdMarca))
			and (isnull(@cPop,0) = 0 or exists(select 1 from #pop where idPop = p.idPop))

	update #datosPerAnt
	set qty = isnull(rp.Cantidad,0) from #tempReportePrimerPeriodo t
	inner join ReportePop rp on rp.idReporte = t.idReporte
	where #datosPerAnt.idPop = rp.idPop


	insert #datosPerUlt (idPuntoDeVenta, idPop)
	select t.idPuntoDeVenta, p.idPop from #tempReporteUltimoPeriodo t, Pop p
	inner join Pop_Marca pm on pm.idPop = p.idPop
	where p.idCliente = @idCliente
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pm.IdMarca))
			and (isnull(@cPop,0) = 0 or exists(select 1 from #pop where idPop = p.idPop))

	update #datosPerUlt
	set qty = isnull(rp.Cantidad,0) from #tempReporteUltimoPeriodo t
	inner join ReportePop rp on rp.idReporte = t.idReporte
	where #datosPerUlt.idPop = rp.idPop

	
	
	insert #datosFinal (pdv, direccion, zona, pop, estado)
	select	distinct ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(pdv.Direccion)),
			ltrim(rtrim(z.Nombre)),
			ltrim(rtrim(p.Nombre)),
			case when (isnull(d1.qty,0) = 0 and isnull(d2.qty,0) = 0) then 'Oportunidad de Codificación'
			when (isnull(d2.qty,0) = 0 and isnull(d1.qty,0) > 0) then 'Quiebre de Stock'
			when ((isnull(d2.qty,0) - isnull(d1.qty,0)) > 3) then 'Sobre Stockeado'
			when ((isnull(d2.qty,0) - isnull(d1.qty,0)) between 1 and 3) then 'Stock Sano'
			else 'Stock Sano'
			end
	from #datosPerAnt d1
	inner join #datosPerUlt d2 on d1.idPuntoDeVenta = d2.idPuntoDeVenta and d1.idPop = d2.idPop
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = d1.idPuntoDeVenta
	inner join Pop p on p.idPop = d1.idPop
	inner join Zona z on z.idZona = pdv.idZona
	order by ltrim(rtrim(pdv.Nombre)), ltrim(rtrim(p.Nombre))



	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal
	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje='es')
		insert #columnasConfiguracion (name, title, width) values ('pdv','PuntoDeVenta',30),('direccion','Direccion',50),('zona','Zona',50),('pop','Producto',50),('estado','Estado',50)

	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('pdv','PointOfSale',30),('direccion','Address',50),('zona','Location',50),('pop','Product',50),('estado','Status',50)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select pdv, direccion, zona, pop, estado from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select pdv, direccion, zona, pop, estado from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select pdv, direccion, zona, pop, estado from #datosFinal
end