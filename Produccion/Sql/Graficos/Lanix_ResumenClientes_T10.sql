IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_ResumenClientes_T10'))
   exec('CREATE PROCEDURE [dbo].[Lanix_ResumenClientes_T10] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Lanix_ResumenClientes_T10
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



	-----------------------------------------------------------------


	create table #tempReporteVentas
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		semana int,
		idReporte int
	)

	create table #tempReporteInventario
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		semana int,
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	--Clientes con Ventas usan SUMA de los PDVs
	insert #tempReporteVentas (idCliente, idUsuario, IdPuntoDeVenta, semana, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			--,cast(datepart(year, r.FechaCreacion) as varchar(4))+''+cast(datepart(wk, r.FechaCreacion) as varchar(2)) as semana
			--,LEFT(CONVERT(varchar, r.FechaCreacion,112),6) as semana
			,year(r.fechacreacion) * 10000 + datepart(month,r.fechacreacion) * 100 + datepart(wk,r.fechacreacion) as semana
			,r.idReporte
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	(convert(date, FechaCreacion) between convert(date,dateadd(wk, -12, GETDATE())) and convert(date, GETDATE()))
			and exists (select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and r.idEmpresa = CASE @idCliente WHEN 147 THEN 746 ELSE (SELECT idEmpresa FROM Cliente WHERE idCliente = @idCliente) END


	--Clientes con Inventario usan último Reporte por PDV
	insert #tempReporteInventario (idCliente, idUsuario, IdPuntoDeVenta, semana, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			--,cast(datepart(year, r.FechaCreacion) as varchar(4))+''+cast(datepart(wk, r.FechaCreacion) as varchar(2)) as semana
			,year(r.fechacreacion) * 10000 + datepart(month,r.fechacreacion) * 100 + datepart(wk,r.fechacreacion) as semana
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	(convert(date, FechaCreacion) between convert(date,dateadd(wk, -12, GETDATE())) and convert(date, GETDATE()))
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (r.idEmpresa = CASE @idCliente WHEN 147 THEN 745 ELSE (SELECT idEmpresa FROM Cliente WHERE idCliente = @idCliente) END
			or r.idEmpresa = CASE @idCliente WHEN 147 THEN 748 ELSE (SELECT idEmpresa FROM Cliente WHERE idCliente = @idCliente) END )
			group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta,year(r.fechacreacion) * 10000 + datepart(month,r.fechacreacion) * 100 + datepart(wk,r.fechacreacion) 


	
	create table #SemanasVentas
	(
		semana int,
		ventas int
	)

	insert #SemanasVentas (semana, ventas)
	select t.semana, sum(isnull(rp.Cantidad,0)) from #tempReporteVentas t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by t.semana


	create table #PromedioVentas
	(
		semana int,
		promedio int
	)

	
	--PROMEDIO POR 2 SEMANAS ANTERIORES
	insert #PromedioVentas (semana, promedio)
	select x.semana, (select sum(ventas) from #SemanasVentas where semana between x.semana-1 and x.semana)/2 from #SemanasVentas x
	

	create table #datos
	(
		idCliente int,
		Nombre varchar(500),
		semana int,
		nombreSemana varchar(5),
		cantidad numeric(18,2)
	)

	insert #datos (idCliente, Nombre, semana, nombreSemana, cantidad)
	select	t.idCliente,
			'Sell out',
			t.semana,
			'W '+substring(cast(t.semana as varchar),7,len(cast(t.semana as varchar))-1),
			sum(isnull(rp.Cantidad,0))
	from #tempReporteVentas t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by t.idCliente, t.semana

	insert #datos (idCliente, Nombre, semana, nombreSemana, cantidad)
	select	t.idCliente,
			case when idCliente = 143 then 'Stock en PDV'
			when idCliente = 146 then 'Stock Almacen' end,
			t.semana,
			'W '+substring(cast(t.semana as varchar),7,len(cast(t.semana as varchar))-1),
			sum(isnull(rp.Cantidad2,0))
	from #tempReporteInventario t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by t.idCliente, t.semana


	insert #datos (idCliente, Nombre, semana, nombreSemana, cantidad)
	select	1,
			'Semana Inventario',
			d.semana,
			'W '+substring(cast(d.semana as varchar),7,len(cast(d.semana as varchar))-1),
			case when sv.promedio = 0 then cast(isnull(d.cantidad,0)/1 as numeric(18,2))
			else cast(isnull(d.cantidad,0)/isnull(sv.promedio,0) as numeric(18,2))
			end


	from #datos d
	inner join #PromedioVentas sv on sv.semana = d.semana
	where d.idCliente = CASE @idCliente WHEN 147 THEN 144 ELSE @idCliente END and sv.semana = d.semana


	insert #datos (idCliente, Nombre, semana, nombreSemana, cantidad)
	select	2,
			'Semana Inventario Almacen',
			d.semana,
			'W '+substring(cast(d.semana as varchar),7,len(cast(d.semana as varchar))-1),
			case when sv.promedio = 0 then cast(isnull(d.cantidad,0)/1 as numeric(18,2))
			else cast(isnull(d.cantidad,0)/isnull(sv.promedio,0) as numeric(18,2))
			end
	from #datos d
	inner join #PromedioVentas sv on sv.semana = d.semana
	where d.idCliente = CASE @idCliente WHEN 147 THEN 146 ELSE @idCliente END and sv.semana = d.semana


	select idCliente,nombre, CAST(LEFT(semana, 4) AS INT) * 100 + 
		 CAST(right(semana, 2) AS INT)
		 ,nombreSemana,sum(cantidad) from #datos 
	group by idCliente,nombre, CAST(LEFT(semana, 4) AS INT) * 100 + 
		 CAST(right(semana, 2) AS INT),nombreSemana
	order by 3 asc

	
	


end
go


--Lanix_ResumenClientes_T10 147