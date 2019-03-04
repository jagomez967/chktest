IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.aventFarmacityQuiebreFrentes_t9'))
   exec('CREATE PROCEDURE [dbo].[aventFarmacityQuiebreFrentes_t9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[aventFarmacityQuiebreFrentes_t9]
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
	create table #MarcaPropiedad
	(
		idMarcaPropiedad int
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
	declare @cMarcaPropiedad varchar(max)

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

	insert #MarcaPropiedad (IdMarcaPropiedad) select clave as idMarcaPropiedad from dbo.fnSplitString((select valores from @Filtros where IdFiltro = 'fltMarcaPropiedad'),',') where isnull(clave,'')<>''
	set @cMarcaPropiedad = @@ROWCOUNT
	
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
	-----------------------------------------------------

	create table #tempReporte 
	(idPuntodeventa int,idReporte int)
	
	insert #tempReporte(idPuntodeventa,idReporte)
	select r.idPuntodeventa,r.idReporte
	from reporte r
	inner join cliente c
		on c.idEmpresa = r.idEmpresa 
	inner join puntodeventa pdv 
		on pdv.idPuntodeventa = r.idPuntodeventa
	where cast(r.fechaCreacion as date) between cast(@fechaDesde as date) and cast(@fechaHasta as date)				
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and c.idCliente = @idCliente

	create table #quiebreYFrentesPorProducto
	(id int identity(1,1),idProducto int, cantidad int, quiebre int,total int,propio bit)

	insert #quiebreYFrentesPorProducto(idProducto,cantidad,quiebre,total,propio)
	select p.idProducto,sum(isnull(rp.cantidad,0)),0,count(distinct tmp.idPuntodeventa),1
	from #tempReporte tmp
	inner join reporteProducto rp 
		on rp.idReporte = tmp.idReporte
	inner join producto p 
		on p.idProducto = rp.idProducto
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.idProducto))
		and (isnull(@cMarcas,0) = 0 or exists(select 1 from #Marcas where idMarca = p.idMarca))
	group by p.idProducto

	update q
	set quiebre = qxpdv.quiebre
	from #quiebreYFrentesPorProducto q
	inner join (
		select p.idProducto,count(distinct t.idPuntodeventa) as quiebre
		from #tempReporte t
		inner join reporteProducto p
		on p.idReporte = t.idReporte		
		where p.Stock = 1
		group by p.idProducto
	)qxpdv --Quiebre por pdv
	on qxpdv.idProducto = q.idProducto
	
	insert #quiebreYFrentesPorProducto(idProducto,cantidad,total,propio)
	select p.idProducto,sum(isnull(rp.cantidad,0)),count(distinct tmp.idPuntodeventa),0
	from #tempReporte tmp
	inner join ReporteProductoCompetencia rp
	on rp.IdReporte = tmp.idReporte 
	inner join producto p 
	on p.idProducto = rp.idProducto
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.idProducto))
		and (isnull(@cMarcas,0) = 0 or exists(select 1 from #Marcas where idMarca = p.idMarca))
	group by p.idProducto


	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #quiebreYFrentesPorProducto
	select @maxpag

	create table #columnasConfiguracion 
		(name varchar(100),
		title varchar(100),
		width int)

	insert #columnasConfiguracion (name, title, width)
		 values 
		 ('producto','Producto',70),
		 ('frentes','Frentes',10),
		 ('quiebre','Quiebre',10),
		 ('total','Total',10)

	select name,title,width from #columnasConfiguracion


	if(@NumeroDePagina>0)
		select p.nombre as producto, q.cantidad as frentes,q.quiebre as quiebre,q.total as total
		 from #quiebreYFrentesPorProducto q
		 inner join producto p
			on p.idProducto = q.idProducto
		 where q.id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select p.nombre as producto, q.cantidad as frentes,q.quiebre as quiebre,q.total as total
		 from #quiebreYFrentesPorProducto q
		 inner join producto p
		 on p.idProducto = q.idProducto 
		where q.id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select p.nombre as producto, q.cantidad as frentes,q.quiebre as quiebre,q.total as total
		 from #quiebreYFrentesPorProducto q
		 inner join producto p
		 on p.idProducto = q.idProducto 
END

GO

