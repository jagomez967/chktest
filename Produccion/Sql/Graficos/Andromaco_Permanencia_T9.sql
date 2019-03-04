IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Andromaco_Permanencia_T9'))
   exec('CREATE PROCEDURE [dbo].[Andromaco_Permanencia_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Andromaco_Permanencia_T9]
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


	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		Fecha date,
		idReporte int,
		InicioReporte datetime,
		FinReporte datetime
	)

	create table #datosFinal
	(
		id int identity(1,1),
		idUsuario int,
		usuario varchar(max),
		fecha varchar(15),
		HoraInicio varchar(5),
		HoraFin varchar(5),
		DuracionRuta varchar(8),
		mismoDia int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, Fecha, idReporte,InicioReporte,FinReporte)	
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(date,r.Fechacreacion) 
			,max(r.idReporte)
			,r.FechaCreacion
			,r.FechaCierre
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
	and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	group by c.IdCliente ,r.IdUsuario ,r.IdPuntoDeVenta ,r.Fechacreacion,r.fechaCierre
	

	insert #datosFinal (idUsuario,Usuario,Fecha,HoraInicio,HoraFin,mismoDia)
	select	u.idUsuario,
			u.Nombre+', '+u.Apellido collate database_default,
			t.fecha,
			substring(convert(varchar, min(t.InicioReporte),108),1,5),
			substring(convert(varchar, max(t.FinReporte),108),1,5),
			1
	from #TempReporte t
	inner join Usuario u on u.idUsuario = t.idusuario
	group by u.idUsuario,u.nombre,u.apellido,t.fecha
	having  day(min(t.inicioReporte)) = day(max(t.finReporte))

	insert #datosFinal (idUsuario,Usuario,Fecha,HoraInicio,HoraFin,mismoDia)
	select	u.idUsuario,
			u.Nombre+', '+u.Apellido collate database_default,
			t.fecha,
			substring(convert(varchar, min(t.InicioReporte),108),1,5),
			'24:00',
			1
	from #TempReporte t
	inner join Usuario u on u.idUsuario = t.idusuario
	group by u.idUsuario,u.nombre,u.apellido,t.fecha
	having  day(min(t.inicioReporte)) <> day(max(t.finReporte))


	--SET TIEMPO EN PDV
	update #datosFinal
	set DuracionRuta =  
	right('00'+cast(
			datediff(second,0,
				cast('20160101 00:'+ cast(HoraFin as varchar) as datetime)-
				cast('20160101 00:'+ cast(HoraInicio as varchar) as datetime))%3600/60
			as varchar)
	,2)
	+':'+
	right('00'+cast(
			datediff(second,0,
				cast('20160101 00:'+ cast(HoraFin as varchar)  as datetime)-
				cast('20160101 00:'+ cast(HoraInicio as varchar) as datetime))%3600%60
			as varchar)
	,2)
	from #datosFinal
	where HoraInicio is not null
	and HoraFin is not null
	and HoraInicio <= HoraFin
	and mismoDia = 1
	
	update #datosFinal
	set DuracionRuta = '-'
	where HoraInicio is not null
	and HoraFin is not null
	and HoraInicio > HoraFin
	
	update #datosFinal
	set DuracionRuta = '-'
	where HoraFin = '24:00'

	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal
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
	


	if(@lenguaje = 'es')
		insert #columnasConfiguracion (esclave,mostrar,name, title, width) 
		values 
			(1,0,'idUsuario','Id',5),
			(0,1,'usuario','Usuario',50),
			(0,1,'fecha','Fecha',30),
			(0,1,'HoraInicio','Hora Inicio',30),
			(0,1,'HoraFin','HoraFin',30),
			(0,1,'DuracionRuta','Duracion Ruta',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (esclave,mostrar,name, title, width) 
		values
			(1,0,'idUsuario','Id',5), 
			(0,1,'usuario','User',50),
			(0,1,'fecha','Date',30),
			(0,1,'HoraInicio','Init',30),
			(0,1,'HoraFin','End',30),
			(0,1,'DuracionRuta','Daily Hour',30)


	select esclave,mostrar,name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select cast(idUsuario as varchar) + ';'+ cast(fecha as varchar) as idUsuario,usuario,fecha,HoraInicio,		
		CASE when HoraFin = '24:00' then '<b style="color:red">' + 'Finalizado luego de 24hs' + '</b>'
		ELSE HoraFin
		END as HoraFin,
		DuracionRuta 
		from #datosFinal 
		where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select cast(idUsuario as varchar) + ';'+ cast(fecha as varchar) as idUsuario,usuario,fecha,HoraInicio,
		CASE when HoraFin = '24:00' then '<b style="color:red">' + 'Finalizado luego de 24hs' + '</b>'
		ELSE HoraFin
		END as HoraFin,
		DuracionRuta 
		from #datosFinal 
		where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select cast(idUsuario as varchar) + ';'+ cast(fecha as varchar) as idUsuario,usuario,fecha,HoraInicio,HoraFin,DuracionRuta 
		from #datosFinal 
		order by usuario
end
GO

