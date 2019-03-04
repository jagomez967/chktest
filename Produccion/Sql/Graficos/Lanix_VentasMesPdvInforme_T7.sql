IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_VentasMesPdvInforme_T7'))
   exec('CREATE PROCEDURE [dbo].[Lanix_VentasMesPdvInforme_T7] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Lanix_VentasMesPdvInforme_T7] 	
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

	declare @ventasTexto varchar(20)
	declare @inventarioTexto varchar(20)

	if @lenguaje = 'es'
	begin
		set language spanish
		set @ventasTexto = 'Ventas'
		set @inventarioTexto = 'Inventario'
	end

	if @lenguaje = 'en'
	begin
		set language english
		set @ventasTexto = 'Sales'
		set @inventarioTexto = 'Stock'
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
	
	create table #TipoEntrega
	(
		idTipoEntrega int
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
	declare @cTipoEntrega varchar(max)

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
	
	insert #TipoEntrega (IdTipoEntrega) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoEntrega'),',') where isnull(clave,'')<>''
	set @cTipoEntrega = @@ROWCOUNT
	

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
		
	insert #Productos(idProducto)
	select p.idProducto 
	from Producto p
	inner join
	(select nombre from Producto 
	where idProducto in (select idProducto from #productos))pdx
	on pdx.nombre = p.nombre
	where p.idMarca in(select idMarca from marca where idEmpresa in(select idEmpresa from cliente where idCliente in(select idCliente from #clientes)))
	and not exists (select 1 from #Productos where idProducto = p.idProducto)

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
	
	create table #diasResultado
	(
		mes varchar(6),
	)
	
	create table #tempReporteVentas
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(6),
		idReporte int
	)

	create table #tempReporteInventario
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(6),
		idReporte int
	)

	create table #resultados
	(
		mes varchar(6),
		qty int,
		descr varchar(20)
	)


		------------------------------------------PREPARACION TABLAS REEMPLAZO REPORTE/REPORTEPRODUCTO----------------------------------------
		
	create table #datosStock
	(
		idMarca int,
		idProducto int,
		idTipo int,
		idPuntodeventa int,
		nombrePDV varchar(max),
		nombreProducto varchar(max),
		sku nvarchar(max),
		cantidad int,
		tipoDeEntrega varchar(max),
		fecha date,
		idEmpresa int
	)

	insert #datosStock(idMarca,idProducto,idTipo,idPuntodeventa,NombrePDV,NombreProducto,SKU,cantidad,tipoDeEntrega,fecha,idEmpresa)
	select 
	p.idMarca as idMarca,
	isnull(p.idProducto,-DENSE_RANK() OVER(ORDER BY lx.[REFERENCIA] ASC))  as idProducto,
	null as idTipo,
	isnull(pdv.idPuntodeventa,-DENSE_RANK() OVER(ORDER BY lx.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, lx.[CAV]) as NombrePDV,
	lx.[REFERENCIA] as NombreProducto,
	null as SKU, 
	count(distinct lx.[SERIAL PROVEEDOR]) as cantidad,
	lx.[TIPO DE ENTREGA] as tipoDeEntrega,
	null as fecha,
	null as idEmpresa 
	From Informes_lanix lx
	left  join (
	select max(px.idPuntodeventa)idPuntodeventa,px.nombre from puntodeventa px
	where px.idCliente = 143 group by px.nombre) pdv
		on pdv.nombre = lx.[CAV] collate database_default
	left join producto p
		on p.nombre = lx.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
		and p.reporte = 1
	left join tipoDeEntrega te
		on te.nombre = lx.[TIPO DE ENTREGA] collate database_default
	where-- lx.[PROVEEDOR] = 'LANIX'
	 lx.[ESTADO] = 'STOCK DISPONIBLE CAV'
	--and (lx.[TIPO DE ENTREGA] = 'DOMICILIO' or lx.[TIPO DE ENTREGA] = 'PRESENCIAL')
	--and convert(date,lx.[FECHA DE RECEPCION]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by lx.[REFERENCIA], lx.[TIPO DE ENTREGA],pdv.nombre,lx.[CAV],p.idProducto,p.idMarca,pdv.idPuntodeventa

	create table #reporteBase
	(
		idMarca int,
		idProducto int,
		idTipo int,
		idPuntodeventa int,
		nombrePDV varchar(max),
		nombreProducto varchar(max),
		sku nvarchar(max),
		cantidad int,
		tipoDeEntrega varchar(max),
		fecha date,
		idEmpresa int
	)
	
	
	--QUERY "TODO MAL"
	insert #reporteBase(idMarca,idProducto,idTipo,idPuntodeventa,NombrePDV,NombreProducto,SKU,cantidad,tipoDeEntrega,fecha,idEmpresa)
	select 
	p.idMarca as idMarca,
	isnull(p.idProducto,-DENSE_RANK() OVER(ORDER BY lx.[REFERENCIA] ASC))  as idProducto,
	null as idTipo,
	isnull(max(pdv.idPuntodeventa),-DENSE_RANK() OVER(ORDER BY lx.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, lx.[CAV]) as NombrePDV,
	lx.[REFERENCIA] as NombreProducto,
	null as SKU, 
	count(distinct lx.[SERIAL PROVEEDOR]) as cantidad,
	lx.[TIPO DE ENTREGA] as tipoDeEntrega,
	cast(lx.[FECHA DE VENTA]as date) as fecha,
	null as idEmpresa 
	From informes_lanix lx
	left  join (select max(idPuntodeventa) idpuntodeventa,nombre  from puntodeventa where idCliente = 143 group by nombre)
	 pdv 
		on pdv.nombre = lx.[CAV] collate database_default	
	left join producto p
		on p.nombre = lx.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = lx.[TIPO DE ENTREGA] collate database_default
	where lx.[PROVEEDOR] = 'LANIX'
	--lx.[TIPO] = 'PC'
	and lx.[ESTADO] = 'SALIDA DE MERCANCIA'
	and (lx.[TIPO DE ENTREGA] = 'DOMICILIO' or lx.[TIPO DE ENTREGA] = 'PRESENCIAL' or lx.[TIPO DE ENTREGA] = 'CAV')
	and convert(date,lx.[FECHA DE VENTA]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by lx.[REFERENCIA], lx.[TIPO DE ENTREGA],lx.[FECHA DE VENTA],pdv.nombre,lx.[CAV],p.idMarca,p.idProducto
	

	
	------------------------------------------END (TABLAS REEMPLAZO)-----------------------------------------------------------------------

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	declare @inventario int

	select 	@inventario = 
			sum(isnull(r.cantidad, 0)) 
	from #datosStock r
	left join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	cross join (select left(convert(varchar, fecha, 112),6) as fecha ,
			right(CONVERT(VARCHAR(11),convert(datetime,left(convert(varchar, fecha, 112),6)+'01'),6),6) as descripcionFecha
				from #reporteBase group by left(convert(varchar, fecha, 112),6)) x
	where	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = r.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = r.IdProducto))


	select	left(convert(varchar, r.fecha, 112),6),
			right(CONVERT(VARCHAR(11),convert(datetime,left(convert(varchar, r.fecha, 112),6)+'01'),6),6),
			'Ventas' as descr, --r.NombreProducto, 
			sum(isnull(r.cantidad, 0)) 
	from #reporteBase r
	left join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	where	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = r.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = r.IdProducto))
	group by left(convert(varchar, r.fecha, 112),6)
	union
	select x.fecha,
			x.descripcionFecha,
			'Inventario' as descr, --r.NombreProducto, 
			sum(isnull(r.cantidad, 0)) 
	from #datosStock r
	left join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	cross join (select left(convert(varchar, fecha, 112),6) as fecha ,
			right(CONVERT(VARCHAR(11),convert(datetime,left(convert(varchar, fecha, 112),6)+'01'),6),6) as descripcionFecha
				from #reporteBase group by left(convert(varchar, fecha, 112),6)) x
	where	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = r.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = r.IdProducto))
	group by x.fecha,x.descripcionFecha
	order by 1,3 desc


	select	x.fecha,
		x.descrFecha,
		r.idPuntodeventa, 
		r.NombrePDV,
		'Inventario' as descr,
		@inventario
	from #datosStock r
	left join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	cross join (select left(convert(varchar, fecha, 112),6) fecha,
		right(CONVERT(VARCHAR(11),convert(datetime,left(convert(varchar, fecha, 112),6)+'01'),6),6) descrFecha
		 from #reporteBase group by fecha) x
	where	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = r.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = r.IdProducto))
	group by x.descrFecha,x.fecha,r.idPuntodeventa,r.NombrePDV
	union
		select	left(convert(varchar, r.fecha, 112),6),
			right(CONVERT(VARCHAR(11),convert(datetime,left(convert(varchar, r.fecha, 112),6)+'01'),6),6),
			r.idPuntodeventa, 
			r.NombrePDV,
			'Ventas' as descr,
			sum(isnull(r.cantidad, 0)) 
	from #reporteBase r
	left join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	where	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = r.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = r.IdProducto))
	group by left(convert(varchar, r.fecha, 112),6),r.idPuntodeventa,r.NombrePDV

	
end
go

--Lanix_VentasMesPdvInforme_T7 147