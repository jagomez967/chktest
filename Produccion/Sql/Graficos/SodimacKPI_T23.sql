IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SodimacKPI_T23'))
   exec('CREATE PROCEDURE [dbo].[SodimacKPI_T23] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[SodimacKPI_T23]
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
	declare @difDias int
	declare @fechaDesdeAnterior varchar(30)
	declare @fechaHastaAnterior varchar(30)

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

	create table #marcasEpson
	(
		idMarcaEpson int
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
	declare @cMarcasEpson varchar(max)

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
	
	insert #marcasEpson (idmarcaEpson) select clave as idmarcaEpson from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcasEpson'),',') where isnull(clave,'')<>''
	set @cMarcasEpson = @@ROWCOUNT
	

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

	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)
	
	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)

	insert #Zonas(idZona)
	select z.idZona 
	from Zona z
	inner join
	(select nombre from Zona
	where idZona in (select idZona from #Zonas))pdx
	on pdx.nombre = z.nombre
	where z.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Zonas where idZona = z.idZona)

	insert #Localidades(idLocalidad)
	select l.idLocalidad
	from Localidad l
	inner join
	(select nombre from Localidad
	where idLocalidad in (select idLocalidad from #Localidades))pdx
	on pdx.nombre = l.nombre
	inner join Provincia p on p.idProvincia = l.idProvincia
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Localidades where idLocalidad = l.idLocalidad)

	insert #MarcasEpson(idMarcaEpson)
	select m.idSubMarca
	from SubMarca m
	inner join
	(select nombre from SubMarca
	where idSubMarca in (select idMarcaEpson from #MarcasEpson))me
	on me.nombre = m.nombre
	--Traigo todos, total siempre va a ser EPSON
	where not exists (select 1 from #MarcasEpson where idMarcaEpson = m.idMarca)
	and m.idMarca in(select mar.idMarca from marca mar
					inner join cliente c on c.idEmpresa = mar.idEmpresa
					where c.idCliente in(select idCliente from #clientes))


	insert #productos(idProducto)
	select p.idProducto 
	from producto p
	inner join
	(select nombre from producto
	where idProducto in (select idProducto from #Productos))prx
	on prx.nombre = p.nombre
	where p.idMarca in(select m.idMarca
						from marca m 
						where idEmpresa in (
							select e.idEmpresa 
							from #clientes c 
							inner join cliente e on e.idCliente = c.idCliente)
						)
	and not exists (select 1 from #Productos where idproducto = p.idProducto)
	and p.reporte = 1 


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

	create table #Relevados
	(
		mes varchar(8)
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
		mes varchar(8)
	)
	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	DECLARE @Usuarios int,
			@Visitados int,
			@Cobertura int,
			@DiasReportados int,
			@cantPDVS int

			create table #UsuariosPCU (idUsuario int)
			create table #pdvPCU(idPuntodeventa int)

	insert #Asignados(mes,qty)
	select mes, 0 from #Meses

	declare @i int = 1
	declare @max int
	declare @currentFecha datetime
	select @max = MAX(id) from #Asignados
	while(@i<=@max)
	begin
		delete from #tempPCU

		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #Asignados where id=@i
		
		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join usuarioGrupo g on g.idUsuario = pcu.idUsuario
		where convert(date,Fecha)<=convert(date,@currentFecha)
		and exists(select 1 from #clientes where idCliente = pcu.idCliente) 
		and g.idGrupo = 2
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))	
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)
		
		insert #usuariosPCU(idUsuario) select idUsuario from #tempPCU

		insert #pdvPCU(idPuntodeventa) 
		select t.idPuntodeventa from #tempPCU t
		where not exists(select 1 from #pdvPCU where idPuntodeventa = t.idPuntodeventa)
		
		update #Asignados set qty = 
		(
			select count(distinct IdPuntoDeVenta) from #tempPCU
		) where id=@i
		
		set @i=@i+1
	end

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join UsuarioGrupo g on g.IdUsuario = r.IdUsuario
	where convert(date,r.FechaCreacion) between convert(date,@fechadesde) and convert(date,@fechahasta)
	and exists(select 1 from #clientes where idCliente = c.idCliente) 
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	and g.idGrupo = 2
	

		select	ltrim(rtrim(pdv.nombre)) as pdv
			,ltrim(rtrim(m.nombre)) as marca
			,count(p.IdProducto)  as objetivo
			,abs(((sum(rp.NoTrabaja) * 100.0) / count(p.IdProducto)) - 100) as cumplimiento
			into #tmp_marcaskpi
	from reporte r
	inner join reporteProducto rp on rp.idreporte = r.idreporte
	inner join producto p on p.idproducto = rp.idproducto
	inner join puntodeventa pdv on pdv.idpuntodeventa = r.idpuntodeventa
	inner join cliente c on c.idempresa = r.idempresa
	inner join zona z on z.idzona=pdv.idzona
	inner join usuario u on u.idusuario=r.idusuario
	inner join marca m on m.idmarca=p.idmarca
	where	convert(date,r.fechacreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idcliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by r.fechacreacion
			,ltrim(rtrim(pdv.nombre))
			,ltrim(rtrim(m.nombre))
	having sum(rp.cantidad)>0
	order by abs(((sum(rp.NoTrabaja) * 100.0) / count(p.IdProducto)) - 100) asc
	
	select pdv as pdv,avg(cumplimiento) as cumplimiento into #tmp_promedio from #tmp_marcaskpi group by pdv

	declare @cuenta int

	select @cuenta = count(idpuntodeventa) from  #tempReporte

	if @cuenta = (select count(idpuntodeventa) from #tempReporte)
	begin
		set @cuenta = 100
	end

	--select @cuenta = convert(int,avg(cumplimiento)) from #tmp_promedio
		
	insert #Relevados (mes, qty)
	select mes, count(distinct IdPuntoDeVenta) from #tempReporte group by mes

	select @visitados = sum(isnull(qty,0)) from #Relevados
	select @Cobertura=SUM(qty) from #Asignados
	
	

	select @usuarios = count(distinct idUsuario) from #UsuariosPCU
	select @cantPDVS = count(distinct idPuntodeventa) from #tempReporte

	create table #coberturaPorPais(idCliente int ,cobertura int)
	
	select @cobertura = sum(cobertura)
	from #coberturaPorPais 
	where idCliente in(select idCliente from #clientes)


	if(isnull(@cobertura,0) <= 0)
	BEGIN
		select @cobertura = count(distinct idPuntodeventa) from #tempPCU
	END

	declare @fechaDesdeRepo datetime
	select @fechaDesderepo = min(r.fechaCreacion) from reporte r 
	inner join cliente c on c.idEmpresa = r.idEmpresa where 
	exists(select 1 from #clientes where idCliente = c.idCliente) 

	
	--select @diasReportados = DATEDIFF(DAY,@fechaDesdeRepo,getdate())+1

	select @DiasReportados = 1
	
	declare @promoters varchar(50),@stores varchar(50),@coverage varchar(50),@reported varchar(50)
	if(@Lenguaje = 'en')
	BEGIN
		SELECT @promoters = 'AUDITORS',
			@stores = 'STORES',
			@coverage = 'COVERAGE',
			@reported = 'REPORTED DAYS'
	END
	ELSE
	BEGIN
		SELECT @promoters = 'AUDITORES',
			@stores = 'TIENDAS',
			@coverage = 'COBERTURA',
			@reported = 'DIAS REPORTADOS'
	END
		
			
	select 1 as id,cast(@Usuarios as varchar) as valor, @promoters as titulo , 'promoters-icon' as icono,'lightblue' as color
	union
	select 2 as id,cast(@cantPDVS as varchar) as valor, @stores as titulo , 'store-icon' as icono,'lightblue' as color
	union
	select 3 as id,cast(convert(int,isnull(@CUENTA,0)) as varchar) + '%' as valor, @coverage as titulo , 'coverage-icon' as icono,'lightblue' as color
	union
	select 4 as id,cast(@DiasReportados as varchar)as valor, @reported as titulo , 'calendar-icon ' as icono,'lightblue' as color
	order by 1
end

go


--[SodimacKPI_T23] 212


/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20180101,20190106')
--insert into @p2 values(N'fltpuntosdeventa',N'189279')
--insert into @p2 values(N'fltusuarios',N'3976')
--insert into @p2 values(N'fltMarcas',N'2464')
exec SodimacKPI_T23 @IdCliente=212,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/



