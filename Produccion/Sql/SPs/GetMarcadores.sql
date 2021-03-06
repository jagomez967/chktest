SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMarcadores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMarcadores] AS' 
END
GO
ALTER procedure [dbo].[GetMarcadores]
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
		set @fechaDesde=dateadd(month,-3,dateadd(day,-day(getdate())+1,getdate()))
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2

	if(@strFHasta='00010101' or @strFHasta is null)
		set @fechaHasta = getdate()
	else
		select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #Marcadores
	(
		idPuntoDeVenta int,
		lat decimal(11,8),
		lng decimal(11,8),
		idUsuario int,
		visitado varchar(1),
		icon varchar(200),
		layer varchar(200),
		inicioRuta varchar(1),
		finRuta varchar(1),
		zIndex int,
		map varchar(200),
		nombrePdv varchar(200),
		idReporte int,
		usuario varchar(200),
		fechaReporte datetime
	)

	create table #asignados
	(
		idCliente int,
		idPuntoDeVenta int,
		idUsuario int,
		idPuntoDeVenta_Cliente_Usuario int,
		lat decimal(11,8),
		lng decimal(11,8),
		nombrePdv varchar(200)
	)

	create table #visitados
	(
		idCliente int,
		idPuntoDeVenta int,
		idUsuario int,
		lat decimal(11,8),
		lng decimal(11,8),
		nombrePdv varchar(200),
		idReporte int,
		fechaReporte datetime
	)

	insert #asignados (idCliente, IdPuntoDeVenta, IdUsuario, lat, lng, nombrePdv, idPuntoDeVenta_Cliente_Usuario)
	select pcu.idCliente, pcu.idpuntodeventa, pcu.idusuario, p.Latitud, p.Longitud, p.nombre, max(pcu.idPuntoDeVenta_Cliente_Usuario)
	from puntodeventa_cliente_usuario pcu
	inner join puntodeventa p on p.idpuntodeventa = pcu.idpuntodeventa
	where pcu.IdCliente=@IdCliente
			and convert(date,pcu.Fecha) <= convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario))
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and p.latitud is not null
			and p.longitud is not null
	group by pcu.idCliente, pcu.idpuntodeventa, pcu.idusuario, p.Latitud, p.Longitud, p.Nombre

	delete from #asignados where exists(select 1 from puntodeventa_Cliente_usuario where idPuntoDeVenta_Cliente_Usuario = #asignados.idPuntoDeVenta_Cliente_Usuario and activo=0)

	insert #visitados(idCliente, idPuntoDeVenta, idUsuario, lat, lng, nombrePdv, idReporte, fechaReporte)
	select c.idcliente, r.idpuntodeventa, r.idusuario, p.latitud, p.longitud, p.Nombre, r.idreporte, r.FechaCreacion
	from reporte r
	inner join cliente c on c.idempresa=r.idempresa
	inner join puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and p.latitud is not null
			and p.longitud is not null

	delete from #asignados where exists(select 1 from #visitados where #visitados.idCliente=#asignados.idcliente and #visitados.idusuario=#asignados.idusuario and #visitados.idpuntodeventa=#asignados.idpuntodeventa)

	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,zIndex,map,nombrePdv, idReporte, usuario)
	select a.idpuntodeventa, a.lat, a.lng, a.idusuario, '0', 'noVisitado.png', 'cobertura',2,'map',a.nombrePdv, 0, u.apellido + ', ' + u.nombre collate database_default as usuario
	from #asignados a
	inner join usuario u on u.idusuario = a.idusuario

	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,zIndex,map,nombrePdv, idReporte, usuario,fechaReporte)
	select v.idpuntodeventa, v.lat, v.lng, v.idusuario, '1', 'flag-export.png', 'cobertura',3,'map',v.nombrePdv, v.idReporte, u.apellido + ', ' + u.nombre collate database_default as usuario, fechaReporte
	from #visitados v
	inner join usuario u on u.idusuario = v.idusuario

	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,zIndex,map,nombrePdv, idReporte, usuario, fechaReporte)
	select idpuntodeventa, lat, lng, idusuario, visitado, icon, 'ordenado',1,'map',nombrePdv, idReporte, usuario, fechaReporte
	from #Marcadores where visitado='1'

	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,zIndex,map,nombrePdv, idReporte, usuario, fechaReporte)
	select idpuntodeventa, lat, lng, idusuario, visitado, icon, 'dia',4,'map',nombrePdv, idReporte, usuario, fechaReporte
	from #Marcadores where visitado='1' and convert(varchar,fechaReporte,112)=convert(varchar,getdate(),112)

	create table #finRuta
	(
		idReporte int,
		idUsuario int
	)

	insert #finRuta(idReporte,idUsuario)
	select max(idReporte),idUsuario
	from #Marcadores
	where layer='ordenado'
	group by idUsuario

	update #Marcadores set finRuta = '1' where exists(select 1 from #finRuta where #Marcadores.idReporte=#finRuta.idReporte)

	create table #inicioRuta
	(
		idReporte int,
		idUsuario int
	)

	insert #inicioRuta(idReporte,idUsuario)
	select min(idReporte),idUsuario
	from #Marcadores
	where layer='ordenado'
	group by idUsuario

	update #Marcadores set inicioRuta = '1' where exists(select 1 from #inicioRuta where #Marcadores.idReporte=#inicioRuta.idReporte)

	select	lat as lat
			,lng as lng
			,idUsuario as idUsuario
			,visitado as visitado
			,icon as icon
			,layer as layer
			,inicioRuta as inicioRuta
			,finRuta as finRuta
			,zIndex as zIndex
			,map as map
			,nombrePdv as title
			,idReporte as idReporte
			,usuario as usuario
			,convert(varchar,fechaReporte,113) as fechaReporte
	from #Marcadores
	order by layer, idusuario,idReporte

	--exec GetMarcadores 8, 'M,20150101,20150101'
end
GO
