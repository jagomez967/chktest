IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ElNoble_EvaluacionCat_T6'))
   exec('CREATE PROCEDURE [dbo].[ElNoble_EvaluacionCat_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[ElNoble_EvaluacionCat_T6] 	
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

	-------------------------------------------------------------------- END (Filtros)

	create table #Meses
	(
		mes varchar(8)
	)

	create table #datos
	(
		idpuntodeventa int,
		idusuario int,
		mes varchar(8),
		idmarca int,
		iditem int,
		valor decimal(18,2)
	)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int
	)

	create table #datosMarcas
	(
		idmarca int,
		marca varchar(max),
		mes varchar(8),
		valor decimal(18,2)
	)

	-------------------------------------------------------------------- END (Temp)
	

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


	declare @pondII decimal(18,2) = 0.4
	declare @pondIE decimal(18,2) = 0.6


	insert #Meses (mes)
	select distinct mes from #datos

	create table #MarcasMeses
	(
		idMarca int,
		mes varchar(8)
	)

	insert #MarcasMeses (idmarca, mes)
	select distinct tmp.idMarca, m.mes
	from #datos tmp
	left join #Meses m on 1=1


	create table #Resultados
	(
		idMarca int,
		iditem int,
		mes varchar(8),
		valor numeric(18,2)
	)

	insert #Resultados (idMarca, mes, valor)
	select te.idMarca, te.mes, SUM(isnull(d.valor,0))
	from #MarcasMeses te
	left join #datos d on d.idMarca=te.idMarca and d.mes=te.mes
	group by te.idMarca, te.mes
	
	update #Resultados set valor = valor*@pondIE where idmarca = 375
	update #Resultados set valor = valor*@pondII where idmarca = 376
	update #Resultados set idmarca = 0 where idmarca in (375,376)

	select r.idmarca,
			case when r.idmarca = 0 then 'IMAGEN'
			else LTRIM(rtrim(m.nombre)) end, right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), sum(isnull(r.valor,0)), r.mes
	from #Resultados r
	left join Marca m on m.idmarca=r.idMarca
	group by r.idmarca, m.Nombre, right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), r.mes
	order by r.mes, r.idmarca
	
	delete from #Resultados


	create table #ItemsMeses
	(
		idMarca int,
		iditem int,
		mes varchar(8)
	)

	insert #ItemsMeses (idmarca, iditem, mes)
	select distinct tmp.idMarca, tmp.idItem, m.mes
	from #datos tmp
	left join #Meses m on 1=1

	insert #Resultados (idmarca, iditem, mes, valor)
	select te.idmarca, te.iditem, te.mes, SUM(isnull(d.valor,0))
	from #ItemsMeses te
	left join #datos d on d.idMarca=te.idMarca and d.idItem=te.iditem and d.mes=te.mes
	group by te.idmarca, te.iditem, te.mes

	update #Resultados set valor = valor*@pondIE where idmarca = 375
	update #Resultados set valor = valor*@pondII where idmarca = 376
	update #Resultados set idmarca = 0 where idmarca in (375,376)

	select r.idmarca,
			case when r.idmarca = 0 then 'IMAGEN'
			else LTRIM(rtrim(m.nombre)) end, r.iditem,
			case when r.idmarca in (0, 377) then mm.Nombre
			else mi.Nombre end,
			right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), sum(isnull(r.valor,0)), r.mes
	from #Resultados r
	left join Marca m on m.idmarca=r.idMarca
	inner join MD_Item mi on mi.idItem = r.idItem
	inner join MD_Modulo mm on mm.idModulo = mi.idModulo
	group by r.idmarca, m.Nombre, r.iditem, mm.Nombre, mi.Nombre, right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), r.mes
	order by r.mes, r.idmarca
	

end