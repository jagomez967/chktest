IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ElNoble_PerfCategorias_T12'))
   exec('CREATE PROCEDURE [dbo].[ElNoble_PerfCategorias_T12] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].[ElNoble_PerfCategorias_T12]
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
	declare @strFDesdePeriodoAnterior varchar(30)
	declare @strFHastaPeriodoAnterior varchar(30)
	
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------


	set @difDias = DATEDIFF(DAY, @fechaDesde, @fechaHasta)
	set @strFDesdePeriodoAnterior = CONVERT(varchar,dateadd(day,-@difDias-1,@fechaDesde),112)
	set @strFHastaPeriodoAnterior = convert(varchar,dateadd(day,-@difDias-1,@fechaHasta),112)

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int
	)

		create table #reportesMesPdvPeriodoAnterior
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int
	)

	create table #datos
	(
		idPuntoDeVenta int,
		idusuario int,
		idmarca int,
		iditem int,
		valor decimal(18,2),
		mes varchar(8)
	)

	create table #datosPeriodoAnterior
	(
		idPuntoDeVenta int,
		idusuario int,
		idmarca int,
		iditem int,
		valor decimal(18,2),
		mes varchar(8)
	)

	create table #datosFinal
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(18,2),
		varianza decimal(18,2),
		nivel int,
		idmarca int
	)

	create table #datosFinalAnterior
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(18,2),
		varianza decimal(18,2),
		nivel int,
		idmarca int
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte, idUsuario)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte), r.IdUsuario
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), r.IdUsuario

	insert #reportesMesPdvPeriodoAnterior (idEmpresa, idPuntoDeVenta, mes, idReporte, idUsuario)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte), r.IdUsuario
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and r.FechaCreacion between @strFDesdePeriodoAnterior and @strFHastaPeriodoAnterior
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), r.IdUsuario


	--SUMA MARCAS OPERACIONES Y EQUIPAMIENTO (suma ponderacion items con valor1 = 0)
	insert #datos(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, mi.idMarca, mi.idItem, sum(isnull(mi.ponderacion,0)) from MD_ModuloMarcaItem mi, #reportesMesPdv r
	where mi.idMarca in (374,379)
	group by r.idPuntoDeVenta, r.idusuario, r.mes, mi.idMarca, mi.idItem
	
	delete from #datos where exists (
		select r.idPuntodeVenta, rm.idItem from MD_ReporteModuloItem rm
		inner join #reportesMesPdv r on r.idReporte = rm.idReporte
		where #datos.idPuntoDeVenta = r.idPuntodeventa and #datos.idItem = rm.idItem and rm.valor1 = 1)
	

	--SUMA MARCA PRODUCTOS (suma ponderacion items con valor1 = 1)
	insert #datos(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idUsuario, r.mes, rm.idMarca, mi.idItem, sum(isnull(mi.ponderacion,0)) from MD_ReporteModuloItem rm
	inner join #reportesMesPdv r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 378
	group by r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem

	--SUMA MARCA ORDEN Y LIMPIEZA (suma ponderacion del Modulo dependiendo de la ponderacion del item con valor1 = 1)
	insert #datos(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem, ((isnull(mi.Ponderacion,0)/100.00)*mm.Ponderacion) from MD_ReporteModuloItem rm
	inner join #reportesMesPdv r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 377

	--SUMA MARCA AGRUP IMAGEN (suma ponderacion del Modulo dependiendo de la ponderacion del item con valor1 = 1)
	insert #datos(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.IdMarca, mi.idItem, ((isnull(mi.Ponderacion,0)/100.00)*mm.Ponderacion)
	from MD_ReporteModuloItem rm
	inner join #reportesMesPdv r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca in (375,376)

	--SUMA MARCA CRITICOS (suma ponderacion items con valor1 = 1) [RESTA A LA PONDERACION TOTAL] [PONDERACION NEGATIVA]
	insert #datos(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem, -sum(isnull(mm.ponderacion,0)) from MD_ReporteModuloItem rm
	inner join #reportesMesPdv r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 380
	group by r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem


	--SUMA PERÍODO ANTERIOR

	--SUMA MARCAS OPERACIONES Y EQUIPAMIENTO (suma ponderacion items con valor1 = 0)
	insert #datosPeriodoAnterior(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, mi.idMarca, mi.idItem, sum(isnull(mi.ponderacion,0)) from MD_ModuloMarcaItem mi, #reportesMesPdvPeriodoAnterior r
	where mi.idMarca in (374,379)
	group by r.idPuntoDeVenta, r.idusuario, r.mes, mi.idMarca, mi.idItem
	
	delete from #datosPeriodoAnterior where exists (
		select r.idPuntodeVenta, rm.idItem from MD_ReporteModuloItem rm
		inner join #reportesMesPdvPeriodoAnterior r on r.idReporte = rm.idReporte
		where #datosPeriodoAnterior.idPuntoDeVenta = r.idPuntodeventa and #datosPeriodoAnterior.idItem = rm.idItem and rm.valor1 = 1)
	

	--SUMA MARCA PRODUCTOS (suma ponderacion items con valor1 = 1)
	insert #datosPeriodoAnterior(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idUsuario, r.mes, rm.idMarca, mi.idItem, sum(isnull(mi.ponderacion,0)) from MD_ReporteModuloItem rm
	inner join #reportesMesPdvPeriodoAnterior r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 378
	group by r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem

	--SUMA MARCA ORDEN Y LIMPIEZA (suma ponderacion del Modulo dependiendo de la ponderacion del item con valor1 = 1)
	insert #datosPeriodoAnterior(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem, ((isnull(mi.Ponderacion,0)/100.00)*mm.Ponderacion) from MD_ReporteModuloItem rm
	inner join #reportesMesPdvPeriodoAnterior r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 377

	--SUMA MARCA AGRUP IMAGEN (suma ponderacion del Modulo dependiendo de la ponderacion del item con valor1 = 1)
	insert #datosPeriodoAnterior(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.IdMarca, mi.idItem, ((isnull(mi.Ponderacion,0)/100.00)*mm.Ponderacion)
	from MD_ReporteModuloItem rm
	inner join #reportesMesPdvPeriodoAnterior r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca in (375,376)

	--SUMA MARCA CRITICOS (suma ponderacion items con valor1 = 1) [RESTA A LA PONDERACION TOTAL] [PONDERACION NEGATIVA]
	insert #datosPeriodoAnterior(idPuntoDeVenta, idusuario, mes, idmarca, iditem, valor)
	select r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem, -sum(isnull(mm.ponderacion,0)) from MD_ReporteModuloItem rm
	inner join #reportesMesPdvPeriodoAnterior r on rm.idReporte = r.idReporte
	inner join MD_ModuloMarcaItem mi on rm.idItem = mi.idItem
	inner join MD_Item i on i.idItem = rm.idItem
	inner join MD_ModuloMarca mm on mm.idModulo = i.idModulo
	where isnull(rm.valor1,0) = 1 and rm.idmarca = 380
	group by r.idPuntoDeVenta, r.idusuario, r.mes, rm.idMarca, mi.idItem


	declare @pondII decimal(18,2) = 0.4
	declare @pondIE decimal(18,2) = 0.6

	insert #datosFinal (idmarca, valor)
	select d.idmarca,
			case when d.idmarca = 375 then sum(valor)*@pondIE
			when d.idmarca = 376 then sum(valor)*@pondII
			else sum(valor)
			end
			from #datos d
	group by d.idmarca

	update #datosFinal set idmarca = 0 where idmarca in (375,376)


	insert #datosFinalAnterior (idmarca, valor)
	select d.idmarca,
			case when d.idmarca = 375 then sum(valor)*@pondIE
			when d.idmarca = 376 then sum(valor)*@pondII
			else sum(valor)
			end
			from #datosPeriodoAnterior d
	group by d.idmarca

	update #datosFinalAnterior set idmarca = 0 where idmarca in (375,376)


	create table #varPorMarca
	(
		id int identity(1,1),
		idMarca int,
		valor decimal(18,2),
		varianza decimal(18,2)
	)


	create table #varPorMarcaAnterior
	(
		id int identity(1,1),
		idMarca int,
		valor decimal(18,2),
		varianza decimal(18,2)
	)


	insert #varPorMarca (idMarca, valor, varianza)
	select idMarca, sum(valor), 0 from #datosFinal group by idmarca

	insert #varporMarcaAnterior (idMarca, valor, varianza)
	select idMarca, sum(valor), 0 from #datosFinalAnterior group by idmarca

	update A
	set A.varianza = A.valor - B.valor
	from #varPorMarca A, #varporMarcaAnterior B
	where A.idMarca = B.idMarca

	select	d.id as id,
			'7EA568' as color,
			NULL as logo, 0 as nivel,
			d.valor as valor,
			isnull(d.varianza,0) as varianza,
			0 as parentId,
			case when d.idMarca = 0 then 'IMAGEN'
			else m.Nombre end
	from #varPorMarca d
	left join Marca m on m.idMarca = d.idMarca
	order by d.id
end