IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_VentasDiarias_T7'))
   exec('CREATE PROCEDURE [dbo].[Lanix_VentasDiarias_T7] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Lanix_VentasDiarias_T7] 	
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@Tama�oPagina		int = 0
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
		dia date
	)
	
	create table #tempReporteVentas
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		PuntoDeVenta varchar(500),
		fecha date,
		idReporte int
	)

	create table #tempReporteInventario
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		PuntoDeVenta varchar(500),
		fecha date,
		idReporte int
	)

	create table #resultados
	(
		dia date,
		qty int,
		descr varchar(20)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	--Clientes con Ventas usan SUMA de los PDVs
	insert #tempReporteVentas (idCliente, idUsuario, IdPuntoDeVenta, PuntoDeVenta, fecha, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,ltrim(rtrim(p.Nombre))
			,convert(date, r.FechaCreacion)
			,r.idReporte
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists (select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and c.IdCliente = CASE @IdCliente WHEN 147 THEN 144 ELSE @IdCliente END


	--Clientes con Inventario usan �ltimo Reporte por PDV
	insert #tempReporteInventario (idCliente, IdPuntoDeVenta, PuntoDeVenta, fecha, idReporte)
	select	c.IdCliente
			,r.IdPuntoDeVenta
			,ltrim(rtrim(p.Nombre))
			,convert(date, r.FechaCreacion)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join ReporteProducto rp on r.idreporte = rp.idreporte
	where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and c.IdCliente = CASE @IdCliente WHEN 147 THEN 143 ELSE @IdCliente END
			AND rp.Cantidad2 > CASE (
						SELECT 
							COUNT(1) 
						FROM 
							ReporteProducto RP2
							INNER JOIN reporte R2 on RP2.idreporte = r2.idreporte
						WHERE
							ISNULL(rp.Cantidad2,0) != 0 
							and rp2.idproducto = rp.idproducto 
							and CONVERT(DATE,r.fechacreacion) = CONVERT(DATE,r2.fechacreacion)
						) 
					WHEN 0 THEN ISNULL(rp.Cantidad2,0) ELSE 0 END
			group by c.IdCliente, r.IdPuntoDeVenta, p.Nombre, convert(date, r.FechaCreacion)


	create table #Pdvs
	(
		PuntoDeVenta varchar(500),
		fecha date
	)
	insert #Pdvs (PuntoDeVenta, fecha)
	select distinct x.Nombre, x.fecha from
	(select distinct pdv.Nombre, t.fecha from #tempReporteVentas t
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = t.idPuntoDeVenta
	union all
	select distinct pdv.Nombre, t.fecha from #tempReporteInventario t
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = t.idPuntoDeVenta) x



	insert #resultados(dia, qty, descr)
	select p.fecha, sum(isnull(rp.Cantidad,0)), @ventasTexto
	from #Pdvs p
	left join #tempReporteVentas t on t.fecha = p.fecha and t.PuntoDeVenta = p.PuntoDeVenta
	left join ReporteProducto rp on rp.idReporte = t.idReporte
	left join Producto pr on pr.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pr.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pr.IdProducto))
	group by p.fecha


	insert #resultados(dia, qty, descr)
	select p.fecha, sum(isnull(rp.Cantidad2,0)), @inventarioTexto
	from #Pdvs p
	left join #tempReporteInventario t on t.fecha = p.fecha and t.PuntoDeVenta = p.PuntoDeVenta
	left join ReporteProducto rp on rp.idReporte = t.idReporte
	left join Producto pr on pr.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pr.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pr.IdProducto))
	group by p.fecha
	


	select CONVERT(VARCHAR(10), dia, 112), Convert(varchar(10),CONVERT(date,dia,106),103), descr, isnull(qty, 0) from #resultados
	order by 1,descr desc 


	create table #resultadosPdvVentas
	(
		mes date,
		PuntoDeVenta varchar(500),
		descr varchar(20),
		qty int
	)

	create table #resultadosPdv
	(
		mes date,
		PuntoDeVenta varchar(500),
		descr varchar(20),
		qty int
	)

	insert #ResultadosPdvVentas (mes, PuntoDeVenta, descr, qty)
	select p.fecha, p.PuntoDeVenta, @ventasTexto, sum(isnull(rp.Cantidad,0)) from #Pdvs p
	left join #tempReporteVentas t on t.fecha = p.fecha and p.PuntoDeVenta = t.PuntoDeVenta
	left join ReporteProducto rp on rp.idReporte = t.idReporte
	left join Producto pr on pr.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pr.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pr.IdProducto))
	group by p.fecha, p.PuntoDeVenta


	insert #ResultadosPdv (mes, PuntoDeVenta, descr, qty)
	select p.fecha, p.PuntoDeVenta, @inventarioTexto, sum(isnull(rp.Cantidad2,0)) from #Pdvs p
	left join #tempReporteInventario t on t.fecha = p.fecha and p.PuntoDeVenta = t.PuntoDeVenta
	left join ReporteProducto rp on rp.idReporte = t.idReporte
	left join Producto pr on pr.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pr.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pr.IdProducto))
	group by p.fecha, p.PuntoDeVenta


	create table #datosFinal
	(
		mes date,
		NombrePdv varchar(400),
		descr varchar(20),
		qty numeric(18,5)
	)

	insert #datosFinal (mes, NombrePdv, descr, qty)
	select mes, PuntoDeVenta, descr, isnull(qty,0)
	from #ResultadosPdvVentas
	order by PuntoDeVenta

	insert #datosFinal (mes, NombrePdv, descr, qty)
	select mes, PuntoDeVenta, descr, isnull(qty,0)
	from #ResultadosPdv
	order by PuntoDeVenta


	create table #resultadoFinal
	(
		mes varchar(8),
		mesDescr varchar(20),
		idPuntoDeVenta int,
		NombrePdv varchar(400),
		descr varchar(20),
		qty numeric(18,5)
	)

	insert #resultadoFinal (mes, mesDescr, idPuntoDeVenta, NombrePdv, descr, qty)
	select CONVERT(VARCHAR(10), mes, 112), Convert(varchar(10),CONVERT(date,mes,106),103), max(pdv.idPuntoDeVenta), NombrePdv, descr, qty from #datosFinal d
	inner join PuntoDeVenta pdv on pdv.Nombre = d.NombrePdv collate database_default
	group by mes, NombrePdv, descr, qty
	order by NombrePdv


	select mes, mesDescr, idPuntoDeVenta, NombrePdv, descr, qty from #resultadoFinal
	order by mes, NombrePdv,descr desc


	create table #ResultadosPdvProd
	(
		mes varchar(8),
		mesDescr varchar(20),
		idPuntoDeVenta int,
		NombrePdv varchar(400),
		descr varchar(20),
		idProducto int,
		Producto varchar(400),
		qty numeric(18,5)
	)



	insert #ResultadosPdvProd (mes, mesDescr, idPuntoDeVenta, NombrePdv, descr, idProducto, Producto, qty)
	select	CONVERT(VARCHAR(10), t.fecha, 112), 
			Convert(varchar(10),CONVERT(date,t.fecha,106),103), 
			pdv.idPuntoDeVenta,
			t.PuntoDeVenta, 
			@ventasTexto, 
			rp.idProducto, 
			p.Nombre, 
			sum(isnull(rp.Cantidad,0))
	from #tempReporteVentas t
	left join PuntoDeVenta pdv 
		on pdv.Nombre = t.PuntoDeVenta collate database_default
	left join ReporteProducto rp 
		on rp.idReporte = t.idReporte
	left join Producto p 
		on p.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by t.fecha, Convert(varchar(10),CONVERT(date,t.fecha,106),103), t.PuntoDeVenta, rp.idProducto, p.Nombre,pdv.idPuntodeventa


	insert #ResultadosPdvProd (mes, mesDescr, idPuntoDeVenta, NombrePdv, descr, idProducto, Producto, qty)
	select	CONVERT(VARCHAR(10), t.fecha, 112),
			Convert(varchar(10),CONVERT(date,t.fecha,106),103), 
			pdv.idPuntoDeVenta,
			t.PuntoDeVenta, 
			@inventarioTexto, 
			rp.idProducto,
			p.Nombre, 
			sum(isnull(rp.Cantidad2,0))
	from #tempReporteInventario t
	left join PuntoDeVenta pdv on pdv.Nombre = t.PuntoDeVenta collate database_default
	left join ReporteProducto rp on rp.idReporte = t.idReporte
	left join Producto p on p.idProducto = rp.idProducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by t.fecha, Convert(varchar(10),CONVERT(date,t.fecha,106),103), t.PuntoDeVenta, rp.idProducto, p.Nombre,pdv.idPuntodeventa


	select mes, mesDescr, idPuntoDeVenta, NombrePdv, descr, idProducto, Producto, qty,1 Visiblelabel from #ResultadosPdvProd
	order by mes, NombrePdv,descr desc

end

GO
