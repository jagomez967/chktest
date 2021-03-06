SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMarkersCobertura]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMarkersCobertura] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMarkersCobertura]
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
	if @idCliente = 147
	BEGIN
		Execute dbo.GetMarkersCobertura_lanix
			@IdCliente			= @IdCliente
			,@Filtros			= @Filtros
			,@NumeroDePagina	= @NumeroDePagina
			,@Lenguaje			= @Lenguaje
			,@IdUsuarioConsulta = @IdUsuarioConsulta
			,@TamañoPagina		= @TamañoPagina

		return;
	END

	
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
	if (@@rowcount = 0)
	BEGIN
		insert #fechaCreacionReporte(fecha)
		select cast('M' as char(10))
			
		insert #fechaCreacionReporte(fecha)
		select convert(char(6), getdate(), 112) + '01'
	
		insert #fechaCreacionReporte(fecha)
		select convert(char(10), dateadd(DAY,-1,dateadd(MONTH,1,cast(convert(char(6), getdate(), 112) + '01' as datetime))),112)

		
	END
	--select * from #fechacreacionreporte
	--return 0
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
		nombrePdv varchar(200),
		idReporte int,
		usuario varchar(200),
		fecha datetime
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
		latRep decimal(11,8),
		lngRep decimal(11,8),
		latPdv decimal(11,8),
		lngPdv decimal(11,8),
		nombrePdv varchar(200),
		idReporte int,
		fecha datetime
	)
	
	create table #tempMaxReportes
	(
		idReporte int,
		idpuntodeventa int
	)

	insert #tempMaxReportes(idReporte, idpuntodeventa)
	select max(idreporte), r.idpuntodeventa
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
			and (isnull(r.Latitud,0) <> 0 or isnull(p.latitud,0) <> 0)
			and (isnull(r.Longitud,0) <> 0 or isnull(p.longitud,0) <> 0)
	group by r.IdPuntoDeVenta

	insert #asignados (idCliente, IdPuntoDeVenta, IdUsuario, lat, lng, nombrePdv, idPuntoDeVenta_Cliente_Usuario)
	select pcu.idCliente, pcu.idpuntodeventa, pcu.idusuario
	,p.Latitud
	,p.Longitud
	,p.nombre, max(pcu.idPuntoDeVenta_Cliente_Usuario)
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
			and isnull(p.latitud,0) <> 0
			and isnull(p.longitud,0) <> 0
	group by pcu.idCliente, pcu.idpuntodeventa, pcu.idusuario, p.Latitud, p.Longitud, p.Nombre

	delete from #asignados where exists(select 1 from puntodeventa_Cliente_usuario where idPuntoDeVenta_Cliente_Usuario = #asignados.idPuntoDeVenta_Cliente_Usuario and activo=0)

	--Elimino los puntosdeventa Ya Existentes
	delete a from #asignados a
	where exists (select 1 from #asignados 
				where a.idPuntoDeVenta =idPuntoDeVenta 
				and a.idPuntoDeVenta_Cliente_Usuario > idPuntoDeVenta_Cliente_Usuario)
	


	insert #visitados(idCliente, idPuntoDeVenta, idUsuario, latRep, lngRep, latPdv, lngPdv, nombrePdv, idReporte, fecha)
	select c.idcliente, r.idpuntodeventa, r.idusuario
	,p.latitud
	,p.longitud
	,p.latitud
	,p.longitud
	,p.Nombre, r.idreporte, r.FechaCreacion
	from reporte r
	inner join cliente c on c.idempresa=r.idempresa
	inner join puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
	inner join #tempMaxReportes tr on tr.idReporte=r.IdReporte
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(r.Latitud,0) <> 0 or isnull(p.latitud,0) <> 0)
			and (isnull(r.Longitud,0) <> 0 or isnull(p.longitud,0) <> 0)
			and (p.latitud is not null or p.longitud is not null)

	delete from #asignados where exists(select 1 from #visitados where #visitados.idCliente=#asignados.idcliente and #visitados.idusuario=#asignados.idusuario and #visitados.idpuntodeventa=#asignados.idpuntodeventa)
	
	--Elimino los puntos de venta YA VISITADOS
	delete a from #asignados a
	where exists (select 1 from #visitados
				where a.idPuntoDeVenta = idPuntoDeVenta )


	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,nombrePdv, idReporte, usuario)
	select a.idpuntodeventa, a.lat, a.lng, a.idusuario, '0', 'sinReporte.png', 'cobertura',a.nombrePdv, 0, u.apellido + ', ' + u.nombre collate database_default as usuario
	from #asignados a
	inner join usuario u on u.idusuario = a.idusuario

	insert #Marcadores (idPuntoDeVenta,lat,lng,idUsuario,visitado,icon,layer,nombrePdv, idReporte, usuario,fecha)
	select v.idpuntodeventa
	,case when isnull(v.latRep,0)=0 then v.latPdv else v.latRep end
	,case when isnull(v.lngRep,0)=0 then v.lngPdv else v.lngRep end
	,v.idusuario, '1'
	,'conReporte.png'
	,'cobertura',v.nombrePdv, v.idReporte, u.apellido + ', ' + u.nombre collate database_default as usuario, fecha
	from #visitados v
	inner join usuario u on u.idusuario = v.idusuario

	select	lat as lat
			,lng as lng
			,idUsuario as idUsuario
			,visitado as visitado
			,icon as icon
			,layer as layer
			,case when fecha is not null then convert(varchar,fecha,103) + ' ' + nombrePdv else nombrePdv end as title
			,idReporte as idReporte
			,usuario as usuario
			,convert(varchar,fecha,113) as fecha
			,idPuntoDeVenta as idPuntoDeVenta 
	from #Marcadores
	where isnull(lat,0) != 0 and isnull(lng,0) != 0
	order by layer, idusuario,idReporte
end
GO


--[GetMarkersCobertura] 44


/*

select * from puntodeventa where idCliente = 44

*/