SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetRutaDeUsuario_lanix]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetRutaDeUsuario_lanix] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetRutaDeUsuario_lanix]
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
	declare @IdUsuario int
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

	select @IdUsuario = cast(Valores as int) from @Filtros where IdFiltro = 'IdUsuario'

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
		set @fechaDesde=GETDATE()
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	create table #MarcadoresReportes
	(
		id int identity(1,1),
		lat decimal(11,8),
		lng decimal(11,8),
		idUsuario int,
		icon varchar(50),
		idReporte int,
		usuario varchar(200),
		fecha varchar(30),
		tipo varchar(10),
		operacion varchar(50)
	)

	--1) Marcadores de Reportes relevados. Si el Reporte tiene Lat/Lng entonces es verde, sino es rojo.

	insert #MarcadoresReportes (lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo)
	select	coalesce(r.latitud, p.latitud)
			,coalesce(r.longitud, p.longitud)
			,u.IdUsuario
			,case when isnull(r.latitud,0)=0 or isnull(r.longitud,0)=0 then 'rojo.png' else 'verde.png' end
			,r.IdReporte
			,u.apellido + ', ' + u.nombre collate database_default
			,convert(varchar,r.FechaCreacion,113)
			,'reporte'
	from reporte r
	inner join cliente c on c.idempresa=r.idempresa
	left join puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
	left join Usuario u on u.IdUsuario=r.IdUsuario
	where exists (select 1 from #clientes where idCliente = c.idCliente)
			and CONVERT(DATE, FechaCreacion) = CONVERT(DATE, @fechaDesde)
			and r.IdUsuario=@IdUsuario
			and (isnull(r.Latitud,0)<>0 or isnull(p.latitud,0)<>0)
			and (isnull(r.Longitud,0)<>0 or isnull(p.longitud,0)<>0)
	order by r.fechaCreacion



	--Obtengo la lista de logins y logouts
	create table #MarcadoresLogInOut
	(
		id int identity(1,1),
		lat decimal(11,8),
		lng decimal(11,8),
		idUsuario int,
		icon varchar(50),
		idReporte int,
		usuario varchar(200),
		fecha varchar(30),
		tipo varchar(10),
		operacion varchar(50)
	)

	insert #MarcadoresLogInOut (lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,operacion)
	select	r.Latitud
			,r.Longitud
			,u.IdUsuario
			,case when r.IdOperacion=1 then 'LogIn.png' else 'LogOut.png' end
			,0
			,u.apellido + ', ' + u.nombre collate database_default
			,convert(varchar,r.Fecha,113)
			,'loginout'
			,o.Descripcion
	from operacion_usuario r
	inner join Usuario u on u.IdUsuario=r.IdUsuario
	inner join Operacion o on o.IdOperacion=r.IdOperacion
	where CONVERT(DATE, r.fecha) = CONVERT(DATE, @fechaDesde)
			and r.IdUsuario=@IdUsuario
			and isnull(r.latitud,0)<>0
			and isnull(r.longitud,0)<>0
	order by r.idOperacion, r.Fecha	

	update #MarcadoresLogInOut
	set idReporte = (select min(idReporte) from #MarcadoresReportes)-1
	where icon ='LogIn.png' 
	
	update #MarcadoresLogInOut
	set idReporte = (select max(idReporte) from #MarcadoresReportes)+1
	where icon ='LogOut.png' 
	
	--Obtengo la lista de estados
	create table #MarcadoresEstados
	(
		id int identity(1,1),
		lat decimal(11,8),
		lng decimal(11,8),
		idUsuario int,
		icon varchar(50),
		idReporte int,
		usuario varchar(200),
		fecha varchar(30),
		tipo varchar(10),
		operacion varchar(50)
	)

	insert #MarcadoresEstados (lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,operacion)
	select	el.Latitude
			,el.Longitude
			,el.IdUsuario
			,case when el.IdEstado=1 then 'CheckIn.png' else 'CheckOut.png' end
			,0
			,u.apellido + ', ' + u.nombre collate database_default
			,convert(varchar,el.Fechahora,113)
			,'checkinout'
			,e.Nombre
	from EstadosLog el
	inner join Estados e on e.id = el.idEstado
	inner join Usuario u on u.IdUsuario=el.IdUsuario
	where CONVERT(DATE, el.fechahora) = CONVERT(DATE, @fechaDesde)
			and el.IdUsuario=@IdUsuario
			and isnull(el.latitude,'') <> ''
			and isnull(el.longitude,'')<>''
			and el.IdEstado in (1,2)
	order by el.idEstado, el.Fechahora	
	

	--Ruta de Usuario
	create table #RutaDeUsuario
	(
		id int identity(1,1),
		lat decimal(11,8),
		lng decimal(11,8),
		idUsuario int,
		icon varchar(50),
		idReporte int,
		usuario varchar(200),
		fecha varchar(30),
		tipo varchar(10),
		operacion varchar(50)
	)
	
	insert #RutaDeUsuario (lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo)
	select	ug.Latitud
			,ug.Longitud
			,ug.IdUsuario
			,null
			,0
			,u.apellido + ', ' + u.nombre collate database_default
			,ug.Fecha
			,'usuarioGeo'
	from UsuarioGeo ug
	inner join Usuario u on u.idUsuario=ug.IdUsuario
	where	isnull(ug.Latitud,0)<>0
			and isnull(ug.Longitud,0)<>0
			and ug.IdUsuario=@IdUsuario
			and CONVERT(DATE, fecha) = CONVERT(DATE, @fechaDesde)
	order by ug.fecha

	select ROW_NUMBER() OVER(ORDER BY Fecha ASC) AS id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,layer,isnull(operacion,'') as operacion
	,categoria
	from
		(select id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion,'reportes' as categoria
		from #MarcadoresReportes
		union all
		select null,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion,'estados' as categoria
		from #MarcadoresEstados
		union all
		select null,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion,'logs' as categoria
		from #MarcadoresLogInOut) x
	order by id, tipo, fecha

	select id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion from #RutaDeUsuario
	--where @IdUsuarioConsulta in (select idUsuario from usuario where escheckpos = 1) 
	order by tipo, fecha
end

--GetRutaDeUsuario 143
GO



declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'D,20180316,20180316')
insert into @p2 values(N'IdUsuario',N'2710')

exec GetRutaDeUsuario @IdCliente=147,@Filtros=@p2,@Lenguaje='es'


	select	ug.Latitud
			,ug.Longitud
			,ug.IdUsuario
			,null
			,0
			,u.apellido + ', ' + u.nombre collate database_default
			,ug.Fecha
			,'usuarioGeo'
	from UsuarioGeo ug
	inner join Usuario u on u.idUsuario=ug.IdUsuario
	where	isnull(ug.Latitud,0)<>0
			and isnull(ug.Longitud,0)<>0
			and ug.IdUsuario=2710
			and CONVERT(DATE, fecha) = CONVERT(DATE, '20180316')
	order by ug.fecha
