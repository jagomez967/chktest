IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_MesUsuario_T7'))
   exec('CREATE PROCEDURE [dbo].[Cob_MesUsuario_T7] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Cob_MesUsuario_T7] 	
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamaņoPagina		int = 0
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

	declare @asignadoTexto varchar(20)
	declare @relevadoTexto varchar(20)

	if @lenguaje = 'es'
	begin
		set language spanish
		set @asignadoTexto = 'Asignado'
		set @relevadoTexto = 'Relevado'
	end

	if @lenguaje = 'en'
	begin
		set language english
		set @asignadoTexto = 'Assigned'
		set @relevadoTexto = 'Visited'
	end

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

	create table #Clientes
	(
		idCliente int
	)
	create table #Categoria
	(
		idCategoria int
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
	declare @cClientes varchar(max)
	declare @cCategoria varchar(max)

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
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end
		
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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		id int identity(1,1),
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)

	create table #asignados
	(
		idUsuario int
		,mes varchar(6)
		,idPuntoDeVenta int
	)

	create table #Relevados
	(
		idUsuario int
		,mes varchar(6)
		,qty int
	)

	create table #resultados
	(
		mes varchar(6)
		,qty int
		,descr varchar(20)
	)

	create table #mesesResultado
	(
		mes varchar(6)
	)

	-------------------------------------------------------------------- TEMPS (Filtros)

	declare @i int = 1
	declare @max int
	declare @currentFecha datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU
		
		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #meses where id=@i

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, mes, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,left(@currentFecha,6)
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where	convert(date,Fecha)<=convert(date,@currentFecha)
				and exists(select 1 from #clientes where idCliente = pcu.idCliente)
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
				and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
				and	(isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in (select idProvincia from Localidad where idLocalidad = p.idLocalidad)))
				and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
				in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))		
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (idUsuario, mes, idPuntoDeVenta)
		select idUsuario, left(convert(varchar,@currentFecha,112),6),  IdPuntoDeVenta
		from #tempPCU

		set @i=@i+1
	end

	insert #Relevados (idUsuario, mes, qty)
	select	r.IdUsuario
			,left(convert(varchar, FechaCreacion, 112),6)
			,count(distinct r.idpuntodeventa)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
			and	(isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in (select idProvincia from Localidad where idLocalidad = p.idLocalidad)))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
			in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))				
	group by r.IdUsuario,left(convert(varchar, FechaCreacion, 112),6)

	insert #mesesResultado select left(mes,6) from #meses

	insert #resultados(mes, qty, descr)
	select m.mes, isnull(count(distinct a.idpuntodeventa),0), @asignadoTexto
	from #mesesResultado m
	left join #asignados a on a.mes=m.mes
	group by m.mes

	insert #resultados(mes, qty, descr)
	select m.mes, isnull(sum(b.qty),0), @relevadoTexto
	from #mesesResultado m
	left join #Relevados b on b.mes=m.mes
	group by m.mes

	declare @sumTotal numeric(18,5)
	select @sumTotal=SUM(qty) from #resultados
	if(@sumTotal=0)
		delete from #resultados

	
	create table #resultadosUsuariosAsignados
	(
		mes varchar(6),
		idUsuario int,
		descr varchar(20),
		qty int
	)

	create table #resultadosUsuarios
	(
		mes varchar(6),
		idUsuario int,
		descr varchar(20),
		qty int
	)

	insert #resultadosUsuariosAsignados (mes, idusuario, descr, qty)
	select m.mes, a.idUsuario, @asignadoTexto, isnull(count(distinct a.idpuntodeventa),0)
	from #mesesResultado m
	left join #asignados a on a.mes=m.mes
	group by m.mes, a.idusuario

	insert #resultadosUsuarios (mes, idusuario, descr, qty)
	select a.mes, a.idUsuario, @relevadoTexto, isnull(sum(b.qty),0)
	from #resultadosUsuariosAsignados a
	left join #relevados b on b.mes=a.mes and b.idusuario=a.idusuario
	group by a.mes, a.idusuario

	create table #cobertura
	(
		mes varchar(8),
		mesDescr varchar(20),
		idUsuario int,
		nombreUsuario varchar(400),
		asignadoRelevado varchar(20),
		qty numeric(18,5)
	)

	insert #Cobertura(mes, mesDescr, idUsuario, nombreUsuario, asignadoRelevado, qty)
	select a.mes, right(CONVERT(VARCHAR(11),convert(datetime,a.mes+'01'),6),6), a.idusuario, u.Apellido+', '+u.Nombre collate database_default, a.descr, a.qty
	from #resultadosUsuariosAsignados a
	inner join Usuario u on u.idusuario=a.idusuario
	
	insert #Cobertura(mes, mesDescr, idUsuario, nombreUsuario, asignadoRelevado, qty)
	select b.mes, right(CONVERT(VARCHAR(11),convert(datetime,b.mes+'01'),6),6), b.idusuario, u.Apellido+', '+u.Nombre collate database_default, b.descr, b.qty
	from #resultadosUsuarios b
	inner join Usuario u on u.idusuario=b.idusuario
	
	select mes, mesDescr, asignadoRelevado, sum(qty) from #cobertura
	group by mes,mesDescr,asignadoRelevado
	order by mes, asignadoRelevado


	select mes, mesDescr, idUsuario, nombreUsuario,asignadoRelevado, qty from #cobertura
	order by mes, nombreUsuario
end
go

