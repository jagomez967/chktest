IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_PerformanceVendedor_T9'))
   exec('CREATE PROCEDURE [dbo].[Edding_PerformanceVendedor_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Edding_PerformanceVendedor_T9]
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

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		idReporte int
	)

	create table #datos
	(
		idUsuario int,
		qty numeric(18,2)
	)


	create table #datosFinal
	(
		id int identity(1,1),
		usuario varchar(500),
		m1 varchar(50),
		m2 varchar(50),
		m3 varchar(50),
		m4 varchar(50),
		m5 varchar(50),
		m6 varchar(50),
		valor varchar(max)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by c.IdCliente ,r.IdUsuario ,r.IdPuntoDeVenta


	create table #Relevados
	(
		idUsuario int,
		qty int
	)

	insert #Relevados (idUsuario, qty)
	select idUsuario, count(distinct idPuntoDeVenta) from #tempReporte group by idUsuario


	insert #datos (idUsuario, qty)
	select t.idUsuario, sum(isnull(rp.Stock,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	group by t.idUsuario
	
	
	declare @cantProductos int
	select @CantProductos = count(idProducto) from Producto p
	inner join Marca m on m.idMarca = p.idMarca
	inner join Cliente c on c.idEmpresa = m.idEmpresa
	where c.idCliente = @idCliente and p.Reporte = 1
	
	update #datos set qty = qty*100.0/@cantProductos
	
	
	create table #datosMarcas
	(
		idUsuario int,
		idMarca int,
		qty numeric(18,2)
	)

	insert #datosMarcas (idUsuario, idMarca, qty)
	select t.idUsuario, p.idMarca, sum(isnull(rp.Stock,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	group by t.idUsuario, p.idMarca


	create table #ProductosPorMarca
	(
		idUsuario int,
		idMarca int,
		cant int
	)
	insert #ProductosPorMarca (idMarca, cant)
	select p.idMarca, count (distinct idProducto) from Producto p
	inner join Marca m on m.idMarca = p.idMarca
	inner join Cliente c on c.idEmpresa = m.idEmpresa
	where c.idCliente = @idCliente and p.Reporte = 1
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
	group by p.idMarca
	

	create table #MarcaActual
	(
		idUsuario int,
		idMarca int,
		valor decimal(10,2),
	)

	insert #MarcaActual (idUsuario, idMarca, valor)
	select d.idUsuario, d.idMarca, d.qty*100.0/(select cant from #ProductosPorMarca where #ProductosPorMarca.idMarca=d.idMarca)
	from #datosMarcas d


	update A
	set A.qty = A.qty/B.qty
	from #datos A, #Relevados B
	where A.idUsuario = B.idUsuario

	update A
	set A.valor = A.valor/B.qty
	from #MarcaActual A, #Relevados B
	where A.idUsuario = B.idUsuario


	create table #pivotMarcas
	(
		idUsuario int,
		m1 numeric(18,2),
		m2 numeric(18,2),
		m3 numeric(18,2),
		m4 numeric(18,2),
		m5 numeric(18,2),
		m6 numeric(18,2),
	)


	insert #pivotMarcas (idUsuario, m1, m2, m3, m4, m5, m6)
	select * from
	(
		select idUsuario, idMarca, valor from #MarcaActual
	) pv
	PIVOT
		(max(valor) for idMarca in ([1461],[1462],[1463],[1464],[1465],[1466])) as pvt



	insert #datosFinal (usuario, m1, m2, m3, m4, m5, m6, valor)
	select	u.Apellido+', '+u.Nombre collate database_default,
			cast(pvt.m1 as varchar)+'%',
			cast(pvt.m2 as varchar)+'%',
			cast(pvt.m3 as varchar)+'%',
			cast(pvt.m4 as varchar)+'%',
			cast(pvt.m5 as varchar)+'%',
			cast(pvt.m6 as varchar)+'%',
			cast(qty as varchar)+'%'
	from #datos d
	inner join Usuario u on u.idUsuario = d.idUsuario
	inner join #pivotMarcas pvt on pvt.idUsuario = d.idUsuario



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

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('usuario','Usuario',60),('m1','Perm. todas las sup.',60),('m2','Educar y presentar',60),('m3','Escribir, resaltar y corregir',60),('m4','Diseñar y decorar',60),('m5','Colorear y jugar',60),('m6','Ecoline',60),('valor','Valor',60)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('usuario','Usuario',60),('m1','Perm. todas las sup.',60),('m2','Educar y presentar',60),('m3','Escribir, resaltar y corregir',60),('m4','Diseñar y decorar',60),('m5','Colorear y jugar',60),('m6','Ecoline',60),('valor','Valor',60)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select usuario, m1, m2, m3, m4, m5, m6, valor from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select usuario, m1, m2, m3, m4, m5, m6, valor from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select usuario, m1, m2, m3, m4, m5, m6, valor from #datosFinal
end
go