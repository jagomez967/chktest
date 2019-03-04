IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_ResumenClientesInforme_T10'))
   exec('CREATE PROCEDURE [dbo].[Lanix_ResumenClientesInforme_T10] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Lanix_ResumenClientesInforme_T10
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
	
	create table #TipoPDV
	(
		idTipo int
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
	declare @cClientes varchar(max)
	declare @cTipoPDV varchar(max)
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

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT

	insert #TipoEntrega (IdTipoEntrega) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoEntrega'),',') where isnull(clave,'')<>''
	set @cTipoEntrega = @@ROWCOUNT

	--PREGUNTAR SI ESTO ESTA BIEN ASI O SACARLO (PARA EL CASO EN EL QUE NO SE INGRESE FILTRO POR CLIENTE)
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where fc.familia in (select familia from familiaClientes where idCliente = @idCliente
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

	select @fechaDesde = DATEADD(wk,-7,@fechaHasta)



	-----------------------------------------------------------------
	create table #datosStock
	(
		idPuntodeventa int,
		NombrePDV varchar(max),
		fecha varchar(7),
		semana varchar(9),
		qty numeric(18,0),
		diasInventario int,
		idProducto int,
		idMarca int
	)

	insert #datosStock(idPuntodeventa,nombrePDV,fecha,semana,qty,idProducto,idMarca,diasInventario)
	select
	isnull(max(pdv.idPuntodeventa),DENSE_RANK() OVER(ORDER BY Il.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, Il.[CAV]) as NombrePDV,
	convert(varchar,year(Il.[FECHA DE RECEPCION]))+convert(varchar,datepart(wk,Il.[FECHA DE RECEPCION])-1),
	'W'+convert(varchar,datepart(WEEK,Il.[FECHA DE RECEPCION])-1),
	count(Il.[SERIAL PROVEEDOR]) as cantidad,
	p.idProducto,
	p.idMarca,
	datediff(day,Il.[FECHA DE RECEPCION],convert(date,@fechaHasta))
	From informes_lanix Il
	left  join puntodeventa pdv 
		on pdv.nombre = Il.[CAV] collate database_default
		and pdv.idCliente = 142 --HARCODE ESTE CLIENTE PARA TOMAR LOS PUNTOS DE VENTA DE ALGUN CLIENTE DE LA FAMILIA LANIX.. ESTE ES: LANIX FOTOS
	left join producto p
		on p.nombre = Il.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = Il.[TIPO DE ENTREGA] collate database_default
	where Il.[ESTADO] = 'STOCK DISPONIBLE CAV'
	and Il.[PROVEEDOR] = 'LANIX' 
	and convert(date,Il.[FECHA DE RECEPCION]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by convert(varchar,year(Il.[FECHA DE RECEPCION])),convert(varchar,datepart(wk,Il.[FECHA DE RECEPCION])-1),pdv.nombre,Il.[CAV],p.idProducto,p.idMarca,Il.[FECHA DE RECEPCION]

	
	create table #datosRes
	(
		idPuntoDeVenta int,
		NombrePDV varchar(max),
		Fecha varchar(7),
		semana varchar(9),
		ventas numeric(18,0),
		SemanaInventario numeric(18,8),
		idProducto int
	)

	insert #datosRes (idPuntoDeVenta,NombrePDV, Fecha, semana, Ventas,SemanaInventario,idProducto)
	select
	isnull(max(pdv.idPuntodeventa),DENSE_RANK() OVER(ORDER BY lx.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, lx.[CAV]) as NombrePDV,
	convert(varchar,year(lx.[FECHA DE RECEPCION]))+convert(varchar,datepart(wk,lx.[FECHA DE RECEPCION])-1),
	'W'+convert(varchar, datepart(WEEK,lx.[FECHA DE RECEPCION]) -1),	
	count(lx.[SERIAL PROVEEDOR]) as Ventas,
	AVG(lx.[DIAS DE INVENTARIO])/7 as SemanaInventario,
	p.idProducto
	From informes_lanix lx
	left  join puntodeventa pdv 
		on pdv.nombre = lx.[CAV] collate database_default
		and pdv.idCliente = 142 --HARCODE ESTE CLIENTE PARA TOMAR LOS PUNTOS DE VENTA DE ALGUN CLIENTE DE LA FAMILIA LANIX.. ESTE ES: LANIX FOTOS
	left join producto p
		on p.nombre = lx.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = lx.[TIPO DE ENTREGA] collate database_default
	where lx.[PROVEEDOR] = 'LANIX'
	and (lx.[TIPO DE ENTREGA] = 'DOMICILIO' or lx.[TIPO DE ENTREGA] = 'PRESENCIAL' or lx.[TIPO DE ENTREGA] = 'CAV')
	and convert(date,lx.[FECHA DE RECEPCION]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto)) 
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by convert(varchar,year(lx.[FECHA DE RECEPCION])),convert(varchar,datepart(wk,lx.[FECHA DE RECEPCION])-1),pdv.nombre,lx.[CAV],p.idProducto

	create table #datosSemanaInventario
	(
		idPuntodeventa int,
		NombrePDV varchar(max),
		fecha varchar(7),
		semana varchar(9),
		qty numeric(18,8),
		diasInventario int,
		idProducto int,
		idMarca int
	)

	insert #datosSemanaInventario(idPuntodeventa,nombrePDV,fecha,semana,qty,idProducto,idMarca,diasInventario)
	select
	isnull(max(pdv.idPuntodeventa),DENSE_RANK() OVER(ORDER BY Il.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, Il.[CAV]) as NombrePDV,
	convert(varchar,year(Il.[FECHA DE RECEPCION]))+convert(varchar,datepart(wk,Il.[FECHA DE RECEPCION])-1),
	'W'+convert(varchar,datepart(WEEK,Il.[FECHA DE RECEPCION])-1),
	datediff(day,Il.[FECHA DE RECEPCION],getdate())/7.0 as SemanaInventario,
	p.idProducto,
	p.idMarca,
	--datediff(day,Il.[FECHA DE RECEPCION],convert(date,@fechaHasta))
	COUNT([SERIAL PROVEEDOR])
	From informes_lanix Il
	left  join puntodeventa pdv 
		on pdv.nombre = Il.[CAV] collate database_default
		and pdv.idCliente = 142 --HARCODE ESTE CLIENTE PARA TOMAR LOS PUNTOS DE VENTA DE ALGUN CLIENTE DE LA FAMILIA LANIX.. ESTE ES: LANIX FOTOS
	left join producto p
		on p.nombre = Il.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = Il.[TIPO DE ENTREGA] collate database_default
	where Il.[ESTADO] = 'STOCK DISPONIBLE CAV'
	and Il.[PROVEEDOR] = 'LANIX' 
	and convert(date,Il.[FECHA DE RECEPCION]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by convert(varchar,year(Il.[FECHA DE RECEPCION])),convert(varchar,datepart(wk,Il.[FECHA DE RECEPCION])-1),pdv.nombre,Il.[CAV],p.idProducto,p.idMarca,Il.[FECHA DE RECEPCION],datediff(day,[FECHA DE RECEPCION],getdate())

	
	
	
	
	create table #PromedioVentas
	(
		semana int,
		promedio int
	)

	--PROMEDIO POR 2 SEMANAS ANTERIORES
	insert #PromedioVentas (semana, promedio)
	select x.fecha, sum(s.qty)/2.0
	from #datosStock x
	inner join #datosStock s
	on s.idProducto = x.idProducto
	and cast(s.fecha as int) between cast(x.fecha as int)-1 and cast(x.fecha as int)
	and s.idPuntodeventa = x.idPuntodeventa
	group by x.fecha


	--(select sum(isnull(qty,0)) from #datosStock where fecha between x.fecha-1 and x.fecha)/2 
	

	select 0 as idCliente,'Stock en PDV' as Nombre,
		fecha as semana, semana as NombreSemana, sum(qty)*1.0 as cantidad 
	from #datosStock
	group by fecha,semana
	union
	select 1 as idCliente,'Sell out' as Nombre,
		fecha as semana, semana as nombreSemana, sum(ventas)*1.0 as cantidad 
	from #datosRes
	group by fecha,semana
	union
	select 2 as idCliente,'Sem. Inventario' as Nombre,
		ds.fecha as semana, ds.semana as NombreSemana, 
		--avg(ds.diasInventario/7.0) as cantidad
		MAX(qty)
	from #datosSemanaInventario ds
	group by ds.fecha,ds.semana
	order by  3
--	union
--	select 3 as idCliente, 'Sem. Inventario new' as Nombre,
--	ds.fecha as semana, ds.semana as nombreSemana
--		max( ds.qty /  case when isnull(pv.promedio,0) = 0 then 1 else pv.promedio end) 
--	  as cantidad 
--	 from #datosStock ds
--	 left join #PromedioVentas pv
--	 on pv.semana = ds.fecha
--	group by ds.fecha,ds.semana
	

end
go


--Lanix_ResumenClientesInforme_T10 147
--lanix_resumenClientes_t10 147






	