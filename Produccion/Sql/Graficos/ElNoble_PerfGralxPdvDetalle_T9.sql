IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ElNoble_PerfGralxPdvDetalle_T9'))
   exec('CREATE PROCEDURE [dbo].[ElNoble_PerfGralxPdvDetalle_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[ElNoble_PerfGralxPdvDetalle_T9] 	
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int
	)

	create table #datos
	(
		idpuntodeventa int,
		idusuario int,
		idmarca int,
		iditem int,
		valor decimal(18,2),
		mes varchar(8)
	)

	create table #Resultados
	(
		id int identity(1,1),
		pdv int,
		idusuario int,
		performance decimal(18,2),
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

	insert #Resultados (pdv, idusuario, performance, idmarca)
	select d.idPuntoDeVenta, d.idusuario,
			case when d.idmarca = 375 then sum(valor)*@pondIE
			when d.idmarca = 376 then sum(valor)*@pondII
			else sum(valor) end,
			d.idmarca
			from #datos d
	group by d.idPuntoDeVenta, d.idusuario, d.idmarca


	create table #datosFinal
	(
		id int identity(1,1),
		usuario varchar(max),
		pdv varchar(max),
		c1 decimal(18,2),
		c2 decimal(18,2),
		c3 decimal(18,2),
		c4 decimal(18,2),
		c5 decimal(18,2),
		c6 decimal(18,2),
		c7 decimal(18,2)
	)

	insert #datosFinal (usuario, pdv, c1,c2,c3,c4,c5,c6,c7)
	select * from
	(
		select u.Apellido+', '+u.Nombre collate database_default as Usuario,
				convert(varchar,r.pdv)+' - '+pdv.Nombre as PuntoDeVenta,
				performance,
				m.Nombre as marca from #Resultados r
		left join Marca m on m.idMarca = r.idMarca
		inner join Usuario u on u.idUsuario = r.idUsuario
		inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.pdv
	) x
	PIVOT
	(
		max(performance) for marca in ([IMAGEN EXTERIOR], [IMAGEN INTERIOR],[OPERACIONES],[ORDEN Y LIMPIEZA],[PRODUCTO],[EQUIPAMIENTO],[CRITICOS])
	) piv;
	

	declare @pondIMG decimal(18,2) = 0.25
	declare @pondOPE decimal(18,2) = 0.20
	declare @pondOYL decimal(18,2) = 0.30
	declare @pondPRO decimal(18,2) = 0.15
	declare @pondEQU decimal(18,2) = 0.10

	create table #datosTabla
	(
		id int identity(1,1),
		usuario varchar(max),
		pdv varchar(max),
		t1 decimal(18,2),
		t2 decimal(18,2),
		t3 decimal(18,2),
		t4 decimal(18,2),
		t5 decimal(18,2),
		t6 decimal(18,2),
		total decimal(18,2)
	)


	insert #datosTabla (usuario, pdv, t1,t2,t3,t4,t5,t6, total)
	select usuario, pdv, c1+c2,c3,c4,c5,c6,c7,
			round(((c1+c2)*@pondIMG+c3*@pondOPE+c4*@pondOYL+c5*@pondPRO+c6*@pondEQU),2)+isnull(c7,0)
			from #datosFinal



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
		insert #columnasConfiguracion (name, title, width) values ('usuario','Auditor',30),('pdv','Nombre PDV',50),('t1','Imagen',50),('t2','Operaciones',50),('t3','Orden y Limpieza',50),('t4','Producto',50),('t5','Equipamiento',50),('t6','Criticos',50),('total','Total',50)

	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('usuario','Auditor',30),('pdv','Nombre PDV',50),('t1','Image',50),('t2','Operations',50),('t3','Order and Cleaning',50),('t4','Product',50),('t5','Equipment',50),('t6','Critical',50),('total','Total',50)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select usuario, pdv, t1,t2,t3,t4,t5,t6, total from #datosTabla where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select usuario, pdv, t1,t2,t3,t4,t5,t6, total from #datosTabla where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select usuario, pdv, t1,t2,t3,t4,t5,t6, total from #datosTabla
end