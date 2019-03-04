IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ASUS_RepProdPropio_T9'))
   exec('CREATE PROCEDURE [dbo].[ASUS_RepProdPropio_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[ASUS_RepProdPropio_T9]
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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		Fecha varchar(50),
		idPuntoDeVenta int,
		PuntoDeVenta varchar(100),
		Usuario varchar(100),
		Zona varchar(100),
		Provincia varchar(100),
		Cadena varchar(100),
		idMarca int,
		Marca varchar(100),
		idProducto int,
		Producto varchar(100),
		Ventas int,
		Stock int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte)
	select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), r.idreporte
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))

	insert #datosFinal (Fecha, idPuntoDeVenta, PuntoDeVenta, Usuario, Zona, Provincia, Cadena, idMarca, Marca, idProducto, Producto, Ventas, Stock)
	select	convert(varchar, rep.FechaCreacion, 120),
			pdv.IdPuntoDeVenta,
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default,
			ltrim(rtrim(z.Nombre)),
			ltrim(rtrim(pr.Nombre)),
			ltrim(rtrim(ca.Nombre)),
			m.IdMarca,
			ltrim(rtrim(m.Nombre)),
			p.IdProducto,
			ltrim(rtrim(p.Nombre)),
			isnull(rp.Precio,0),
			isnull(rp.Cantidad,0)
	from ReporteProducto rp
		inner join #reportesMesPdv r on r.IdReporte = rp.IdReporte
		inner join reporte rep on rep.IdReporte=r.idReporte
		inner join Producto p on p.IdProducto = rp.IdProducto
		inner join Marca m on m.IdMarca = p.IdMarca
		left join Exhibidor e on e.IdExhibidor = rp.IdExhibidor
		left join Exhibidor e2 on e2.IdExhibidor = rp.IdExhibidor2
		inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
		left join Cadena ca on ca.idCadena = pdv.idCadena
		inner join Usuario u on u.IdUsuario = rep.idUsuario
		inner join Zona z on z.IdZona = pdv.IdZona
		inner join Localidad l on l.IdLocalidad = pdv.IdLocalidad
		inner join Provincia pr on pr.IdProvincia = l.IdProvincia
	where (isnull(rp.Cantidad,0)>0 or isnull(rp.Cantidad2,0)>0 or isnull(Precio,0)>0)
		and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
		and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
    and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	order by rep.FechaCreacion, pdv.Nombre

	
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
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Fecha Reporte',5),('PuntoDeVenta','PuntoDeVenta',5),('Usuario','RTM',5),('Zona','Zona',5),('Provincia','Provincia',5),('Cadena','Cadena',5),('Marca','Marca',5),('Producto','Producto',5),('Ventas','Ventas',5),('Stock','Stock',5)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Date',5),('PuntoDeVenta','PDV',5),('Usuario','RTM',5),('Zona','Zone',5),('Provincia','Province',5),('Cadena','Retail',5),('Marca','Brand',5),('Producto','Product',5),('Ventas','Sales',5),('Stock','Stock',5)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Cadena, Marca, Producto, Ventas, Stock from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Cadena, Marca, Producto, Ventas, Stock from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select Fecha, PuntoDeVenta, Usuario, Zona, Provincia, Cadena, Marca, Producto, Ventas, Stock from #datosFinal
	
	
	
	end

