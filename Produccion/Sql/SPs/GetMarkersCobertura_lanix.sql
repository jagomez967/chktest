SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMarkersCobertura_lanix]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMarkersCobertura_lanix] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMarkersCobertura_lanix]
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

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT

	--PREGUNTAR SI ESTO ESTA BIEN ASI O SACARLO (PARA EL CASO EN EL QUE NO SE INGRESE FILTRO POR CLIENTE)
		insert #clientes(idCliente) 
		values(144),(143)
		
	
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
	where exists (select 1 from #clientes where idCliente = c.idCliente)
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
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by r.IdPuntoDeVenta

	insert #asignados (idCliente, IdPuntoDeVenta, IdUsuario, lat, lng, nombrePdv, idPuntoDeVenta_Cliente_Usuario)
	select pcu.idCliente, pcu.idpuntodeventa, pcu.idusuario
	,p.Latitud
	,p.Longitud
	,p.nombre, max(pcu.idPuntoDeVenta_Cliente_Usuario)
	from puntodeventa_cliente_usuario pcu
	inner join puntodeventa p on p.idpuntodeventa = pcu.idpuntodeventa
	where exists (select 1 from #clientes where idCliente = pcu.idCliente)
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
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
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
	where exists (select 1 from #clientes where idCliente = c.idCliente)
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
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
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
	--group by idUsuario,visitado,icon,layer,fecha,nombrepdv,usuario
	order by layer, idusuario,idReporte
end



--GetMarkersCobertura 147


/*

select * From reporte where	idReporte in(
545706,
544894,
544895,
545714)

select * from usuario where idUsuario = 2559
*/

GO
