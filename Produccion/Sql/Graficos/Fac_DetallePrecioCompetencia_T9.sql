IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_DetallePrecioCompetencia_T9'))
   exec('CREATE PROCEDURE [dbo].[Fac_DetallePrecioCompetencia_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_DetallePrecioCompetencia_T9]
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
		idMarca int
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

	create table #CategoriaProducto
	(
		idCategoriaProducto int
	)
	
	create table #SubCategoria
	(
		idSubCategoria int
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
	declare @cCategoriaProducto varchar(max)
	declare @cSubCategoria varchar(max) 
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

	insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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

	insert #CategoriaProducto (idCategoriaProducto) select clave as CategoriaProducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoriaProducto'),',') where isnull(clave,'')<>''
	set @cCategoriaProducto = @@ROWCOUNT
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
	set @cSubCategoria = @@ROWCOUNT
	
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

	if (@cMarcas = 0)
	BEGIN
		insert #marcas(idMarca)
		select idMarca from producto where idProducto in (select idProducto from #productos)
		set @cMarcas = @@ROWCOUNT
	END
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	insert #cadenas(idCadena)
	select c.idCadena 
	from cadena c
	inner join empresa e on e.idNegocio = c.idNegocio
	inner join cliente cl on cl.idEmpresa = e.idEmpresa 
	inner join
	(select nombre from cadena 
	where idCadena in(select idCadena from #cadenas))cx 
	on cx.nombre = c.nombre
	where cl.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #cadenas where idCadena = c.idCadena)

	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)

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

	insert #TipoPDV(idTipo)
	select t.idTipo
	from tipo t
	inner join
	(select nombre from tipo
	where idTipo in (select idTipo from #TipoPDV))tx
	on tx.nombre = t.nombre
	where t.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #TipoPDV where idTipo = t.idTipo)


	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)


	insert #marcas(idMarca)
	select m.idMarca 
	from marca m 
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join
	(select nombre from marca 
	where idMarca in(select idMarca from #marcas))mx 
	on mx.nombre = m.nombre
	where c.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #marcas where idMarca = m.idMarca)

	insert #productos(idProducto)
	select p.idProducto 
	from producto p
	inner join marca m on m.idMarca = p.idMarca
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join 
	(select nombre from producto
	where idProducto in(select idProducto from #productos))px
	on px.nombre = p.nombre 
	where c.idCliente in(select idCliente from #clientes)
	and not exists(select 1 from #productos where idProducto = p.idProducto)

	insert #familia(idFamilia)
	select f.idFamilia 
	from familia f 
	inner join marca m on m.idMarca = f.idMarca 
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join 
	(select nombre from familia 
	where idFamilia in(select idFamilia from #familia))fx
	on fx.nombre = f.nombre 
	where c.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #familia where idFamilia = f.idFamilia) 

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

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		idUsuario int,
		mes varchar(8),
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		idPuntoDeVenta int,
		Fecha varchar(10),
		PuntoDeVenta varchar(500),
		Usuario varchar(500),
		Zona varchar(500),
		Provincia varchar(500),
		Cadena varchar(500),
		idMarca int,
		Marca varchar(500),
		idProducto int,
		Producto varchar(500),
		Precio numeric(18,2)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #reportesMesPdv (idPuntoDeVenta, idUsuario, idEmpresa, mes, idReporte)
	select distinct r.idpuntodeventa, r.idUsuario, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where	c.IdCliente in(select idCliente from #clientes)
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6)
	

	insert #datosFinal (idPuntoDeVenta, Fecha, PuntoDeVenta, Usuario, Zona, Provincia, idMarca, Marca, idProducto, Producto, Precio)
	select	t.IdPuntoDeVenta,
			convert(varchar(10),convert(date,rep.FechaCreacion)),
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default,
			ltrim(rtrim(z.Nombre)),
			ltrim(rtrim(pr.Nombre)),
			m2.IdMarca,
			ltrim(rtrim(m2.Nombre)),
			p2.IdProducto,
			ltrim(rtrim(p2.Nombre)),
			isnull(rp.Precio,0)
	from #reportesMesPdv t
		inner join Reporte rep on rep.idReporte = t.idReporte
		inner join ReporteProductoCompetencia rp on rp.IdReporte=rep.IdReporte
		inner join ProductoCompetencia pc on pc.IdProductoCompetencia=rp.IdProducto
		inner join Producto p on p.IdProducto=pc.IdProducto--producto propio
		inner join Marca m on m.IdMarca=p.IdMarca
		inner join Producto p2 on p2.idProducto = rp.idProducto
		inner join Marca m2 on m2.idMarca = p2.idMarca
		inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = t.IdPuntoDeVenta
		inner join Usuario u on u.IdUsuario = t.idUsuario
		inner join Zona z on z.IdZona = pdv.IdZona
		inner join Localidad l on l.IdLocalidad = pdv.IdLocalidad
		inner join Provincia pr on pr.IdProvincia = l.IdProvincia
	where (isnull(rp.Cantidad,0)>0 or isnull(rp.Cantidad2,0)>0 or isnull(Precio,0)>0)
		and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
		and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
		and (isnull(@cCategoriaProducto,0) = 0 or exists(select 1 from #CategoriaProducto where idCategoriaProducto = p.idCategoria))
		and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
	--Solo detalle de la competencia	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca)) 
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria f inner join MarcaCompetencia mct on f.idMarca = mct.idMarca where f.idMarca = m.idMarca and mct.idMarcaCompetencia = m.idMarca and isnull(mct.esCompetenciaPrimaria,0) = 1))  
		and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
														  inner join subCategoriaProducto scp 
																on sc.idSubCategoria = scp.idSubCategoria
														 where scp.idProducto = p.IdProducto))
	order by pdv.Nombre
	
	--Cantidad de páginas
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
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Fecha',5),('PuntoDeVenta','PuntoDeVenta',5),('Usuario','RTM',5),('Zona','Zona',5),('Provincia','Provincia',5),('Marca','Marca',5),('Producto','Producto',5),('Precio','Precio',5)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Date',5),('PuntoDeVenta','PDV',5),('Usuario','RTM',5),('Zona','Zone',5),('Provincia','Province',5),('Marca','Brand',5),('Producto','Product',5),('Precio','Price',5)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Marca, Producto, Precio from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Marca, Producto, Precio from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Marca, Producto, Precio from #datosFinal
	
	
	
	end
	GO
	
/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p2 values(N'fltSubCategoria',N'1000')
exec Fac_DetallePrecioCompetencia_T9 @IdCliente=235,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

declare @p3 dbo.FiltrosReporting
insert into @p3 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p3 values(N'fltSubCategoria',N'1001')
exec Fac_DetallePrecioCompetencia_T9 @IdCliente=235,@Filtros=@p3,@NumeroDePagina=-1,@Lenguaje='es'

*/

