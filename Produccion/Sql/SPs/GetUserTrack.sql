SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUserTrack]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUserTrack] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetUserTrack]
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


	declare @IdUsuario int
	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		



	select @IdUsuario = cast(Valores as int) from @Filtros where IdFiltro = 'IdUsuario'

	select @strFDesde = fecha from #fechaCreacionReporte where id = 2
	select @strFHasta = fecha from #fechaCreacionReporte where id = 3

	if(@strFDesde='00010101' or @strFDesde is null)
		set @fechaDesde=GETDATE()
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2


		
	create table #Clientes (idCliente int)

	insert  #clientes(idCliente)
	select idCliente 
	From familiaClientes 
	where familia in (
		select familia 
		from familiaclientes 
		where idCliente  = @idCliente  
			and activo = 1 )
	if @@ROWCOUNT = 0
	insert #clientes(idCliente)
	values(@idCliente)

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
	inner join puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
	inner join Usuario u on u.IdUsuario=r.IdUsuario
	where c.IdCliente in (select idCliente from #clientes)
			and CONVERT(DATE, FechaCreacion) = CONVERT(DATE, @fechaDesde)
			and r.IdUsuario=@IdUsuario		
			and coalesce(r.latitud, p.latitud) is not null	
			and coalesce(r.longitud, p.longitud) is not null
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
	
	select id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,layer,operacion ,Categoria
	from
		(select id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion, 'reportes'as categoria
		from #MarcadoresReportes
		union all
		select null as id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion,'estados'as categoria
		from #MarcadoresEstados
		union all
		select null as id,lat,lng,idUsuario,icon,idReporte,usuario,fecha,tipo,'seguimiento' as layer,operacion,'logs' as categoria
		from #MarcadoresLogInOut) x
	order by fecha, tipo, id

	declare @difH int 
	select @difH = isnull(DiferenciaHora,0) from cliente where IdCliente = @IdCliente

	declare @maxFecharep datetime, @minFechaRep datetime
	select @maxFechaRep = max(fecha) , @minFechaRep = min(fecha)
	from #MarcadoresReportes

	create table #tmpGeoLatLong(lat decimal(11,8),lng decimal(11,8),id varchar(max))

	;with UsuarioGeoPos as(
		select avg(latitud) lat , avg(longitud) lng, datepart(hour,dateadd(HOUR,@difH,fechaRecepcion)) as hh, datepart(minute,fechaRecepcion) as mm,
		datepart(second,fechaRecepcion) ss
		from usuarioGeo where CONVERT(DATE, fechaRecepcion) = CONVERT(DATE, @fechaDesde)
		and idUsuario = @idUsuario
		group by datepart(hour,dateadd(HOUR,@difH,fechaRecepcion)) , datepart(minute,fechaRecepcion), datepart(second,fechaRecepcion)
	)
	insert #tmpGEOLatLong (lat,lng,id)
	select distinct lat,lng , cast(hh as varchar(3)) +':'+ right('0'+ cast(mm as varchar(3)),2)as id  from usuarioGeopos up

	select t.* from #tmpGeoLatLong t
	where not exists(select 1 from #tmpGeoLatLong where round(lat/2,4) = round(t.lat/2,4) and round(lng/2,4) = round(t.lng/2,4)
					 and not(id=t.id))

end

GO
