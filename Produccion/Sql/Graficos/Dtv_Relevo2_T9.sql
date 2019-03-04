IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Dtv_Relevo2_T9'))
   exec('CREATE PROCEDURE [dbo].[Dtv_Relevo2_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Dtv_Relevo2_T9
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
		IdPuntoDeVenta int,
		idReporte int,
		Fecha varchar(8)
	)

	create table #datos
	(
		id int identity(1,1),
		pdv int,
		valor varchar (max),
		iditem int,
		preg varchar(max)
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (IdPuntoDeVenta, idReporte, Fecha)
	select r.IdPuntoDeVenta, r.IdReporte, left(convert(varchar,r.fechacreacion,112),6)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and p.IdTipo is not null

	create table #datosPvt
	(
		iditem int,
		nombre varchar(100)
	)

	insert #datosPvt
	select mi.IdItem, mi.Nombre from MD_Item mi
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	where mm.IdCliente = 8

	update #datosPvt set Nombre = 'vidriera JJOO?' where iditem = 115
	update #datosPvt set Nombre = 'foll. cuatripticos JJOO?' where iditem = 116
	update #datosPvt set Nombre = 'foll. anteriores?' where iditem = 117
	update #datosPvt set Nombre = 'totems JJOO?' where iditem = 118
	update #datosPvt set Nombre = 'totems anteriores?' where iditem = 119
	update #datosPvt set Nombre = 'flyers JJOO?' where iditem = 120
	update #datosPvt set Nombre = 'flyers anteriores?' where iditem = 121
	update #datosPvt set Nombre = 'sticker JJOO?' where iditem = 122
	update #datosPvt set Nombre = 'stickers anteriores?' where iditem = 123
	update #datosPvt set Nombre = 'hay?' where iditem = 124
	update #datosPvt set Nombre = 'realidad virtual folletos?' where iditem = 125
	update #datosPvt set Nombre = 'Hay' where iditem = 126
	update #datosPvt set Nombre = 'lista precios actual?' where iditem = 127
	update #datosPvt set Nombre = 'en escritorio?' where iditem = 128
	update #datosPvt set Nombre = 'Tiene?' where iditem = 129
	update #datosPvt set Nombre = 'TV local/stand?' where iditem = 130
	update #datosPvt set Nombre = 'encendida?' where iditem = 131
	update #datosPvt set Nombre = 'funciona?' where iditem = 132
	update #datosPvt set Nombre = 'Estado gral. PDV' where iditem = 133
	update #datosPvt set Nombre = 'Vidriera' where iditem = 134
	update #datosPvt set Nombre = 'Marquesina' where iditem = 135
	update #datosPvt set Nombre = 'Estado gral. Mobiliario' where iditem = 136
	update #datosPvt set Nombre = 'elementos rotos?' where iditem = 137

	create table #datosRes
	(
	id int identity(1,1),
	pdv varchar(100),
	c1 varchar(20),
	c2 varchar(20),
	c3 varchar(20),
	c4 varchar(20),
	c5 varchar(20),
	c6 varchar(20),
	c7 varchar(20),
	c8 varchar(20),
	c9 varchar(20),
	c10 varchar(20),
	c11 varchar(20),
	c12 varchar(20), 
	c13 varchar(20), 
	c14 varchar(20),
	c15 varchar(20),
	c16 varchar(20),
	c17 varchar(20),
	c18 varchar(20),
	c19 varchar(20),
	c20 varchar(20),
	c21 varchar(20),
	c22 varchar(20),
	c23 varchar(20)
	)


	insert #datosRes
	select *  from (
	select pdv.Nombre, mi.LabelCampo1 as valor, res.nombre as preg from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join #datosPvt res on res.iditem = mi.IdItem
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
	where isnull(mdr.valor1,0) > 0 and mm.IdCliente = 8
	union all
	select pdv.Nombre, mi.LabelCampo2 as valor, res.nombre as preg from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join #datosPvt res on res.iditem = mi.IdItem
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
	where isnull(mdr.valor2,0) > 0 and mm.IdCliente = 8
	) as s
	pivot
	(max(valor) for preg in (
	[vidriera JJOO?],
	[foll. cuatripticos JJOO?],
	[foll. anteriores?],
	[totems JJOO?],
	[totems anteriores?],
	[flyers JJOO?],
	[flyers anteriores?],
	[sticker JJOO?],
	[stickers anteriores?],
	[hay?],
	[realidad virtual folletos?],
	[Hay],
	[lista precios actual?],
	[en escritorio?],
	[Tiene?],
	[TV local/stand?],
	[encendida?],
	[funciona?],
	[Estado gral. PDV],
	[Vidriera],
	[Marquesina],
	[Estado gral. Mobiliario],
	[elementos rotos?])) as pvt

	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datosRes

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)
	insert #columnasConfiguracion (name, title, width) values ('pdv','PDV',5),('c1','vidriera JJOO?',5),('c2', 'foll. cuatripticos JJOO?',5),('c3', 'foll. anteriores?',5),('c4', 'totems JJOO?',5),('c5', 'totems anteriores?',5),('c6', 'flyers JJOO?',5),('c7', 'flyers anteriores?',5),('c8', 'sticker JJOO?',5),('c9', 'stickers anteriores?',5),('c10', 'hay?',5),('c11', 'realidad virtual folletos?',5),('c12', 'Hay',5),('c13', 'lista precios actual?',5),('c14', 'en escritorio?',5),('c15', 'Tiene?',5),('c16', 'TV local/stand?',5),('c17', 'encendida?',5),('c18', 'funciona?',5),('c19', 'Estado gral. PDV',5),('c20', 'Vidriera',5),('c21', 'Marquesina',5),('c22', 'Estado gral. Mobiliario',5),('c23', 'elementos rotos?',10)
	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select pdv, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23 from #datosRes where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select pdv, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23 from #datosRes where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select pdv, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23 from #datosRes



	--exec Dtv_Relevo2_T9 8,'M,20160401,20160815'
end