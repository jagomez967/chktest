IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_ExhAdicional_T9_Datos_Anidados'))
   exec('CREATE PROCEDURE [dbo].[Mattel_ExhAdicional_T9_Datos_Anidados] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].Mattel_ExhAdicional_T9_Datos_Anidados
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamaņoPagina		int = 0
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
	declare @IdEmpresa int
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
	
	select @IdEmpresa = cast(Valores as int) from @Filtros where IdFiltro = 'IdEmpresa'

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

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		--mes varchar(8),
		idReporte int,
		--idCadena int
	)

		create table #reportesMesPdvPeriodoAnterior
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idCadena int
	)

	create table #datos
	(
		id int identity(1,1),
		valor int,
		idempresa int,
		idProducto int,
		share decimal(10,2)
	)

	create table #datosPeriodoAnterior
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int
	)

	create table #datosResultados
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int
	)
	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, idReporte)
	select distinct r.IdPuntoDeVenta, r.IdEmpresa, max(r.IdReporte)
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	group by r.IdPuntoDeVenta, r.IdEmpresa

	insert #datos(idEmpresa, idProducto, valor, share)
	select r.idempresa, rp.idproducto, sum(isnull(rp.Cantidad2,0)), NULL
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	where isnull(rp.Cantidad2,0)>0
	group by  r.IdEmpresa, rp.IdProducto

	insert #datos (idEmpresa, idProducto, valor, share)
	select m.idempresa, rp.IdProducto, sum(isnull(rp.Cantidad2,0)), NULL
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.Cantidad2,0)>0
	group by  m.idempresa, rp.IdProducto

	create table #datosRes
	(
		id int identity(1,1),
		idproducto int,
		nested1 varchar(100),
		nested2 int,
		nested3 numeric(10,2)
	)

	declare @total as numeric (10,2)
	set @total = (select sum(valor) from #datos)

	insert #datosRes (idproducto, nested1, nested2, nested3)
	select d.idproducto, ltrim(rtrim(p.nombre)), sum(d.valor), cast(sum(d.valor)*100.0/@total as numeric(10,2)) from #datos d
	inner join Producto p on p.idproducto = d.idproducto
	where d.idEmpresa = @idEmpresa
	group by p.Nombre, d.idProducto
	order by p.Nombre, d.idProducto

	declare @maxpag int
	if(@TamaņoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamaņoPagina) from #datosRes
	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje='es')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (0,1,'nested1','Producto',5),(0,1,'nested2', 'Q',5), (0,1,'nested3', '%',10)

	if(@lenguaje='en')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (0,1,'nested1','Product',5),(0,1,'nested2', 'Q',5), (0,1,'nested3', '%',10)

	select esclave, mostrar, name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select nested1, nested2, nested3 from #datosRes where id between ((@NumeroDePagina - 1) * @TamaņoPagina + 1) and (@NumeroDePagina * @TamaņoPagina)
	
	if(@NumeroDePagina=0)
		select nested1, nested2, nested3 from #datosRes where id between ((@maxpag - 1) * @TamaņoPagina + 1) and (@maxpag * @TamaņoPagina)
		
	if(@NumeroDePagina<0)
		select nested1, nested2, nested3 from #datosRes
end

