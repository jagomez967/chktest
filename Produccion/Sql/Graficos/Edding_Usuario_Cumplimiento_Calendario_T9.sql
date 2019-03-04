IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_Usuario_Cumplimiento_Calendario_T9'))
   exec('CREATE PROCEDURE [dbo].[Edding_Usuario_Cumplimiento_Calendario_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Edding_Usuario_Cumplimiento_Calendario_T9]
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


	if(@FechaDesde = @FechaHasta)
		set @FechaHasta = dateadd(second,-1,dateadd(day,1,@FechaDesde))
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	create table #tempCalendario
	(	idCliente int,
		idPuntoDeVenta int, 
		idUsuario int,
		fechaInicio datetime
	)
	
	create table #tempReporte
	(
		idPuntoDeVenta int,
		idUsuario int,
		fechaCreacion datetime
	)
	
	create table #tempReporte_PRE
	(
		idPuntoDeVenta int,
		idUsuario int,
		fechaCreacion datetime
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------
	
	insert #tempCalendario (idCliente,idPuntoDeVenta,idUsuario,fechaInicio)
	select cal.idCliente,
		   cal.idPuntoDeVenta,
		   cal.idUsuario,
		   cal.FechaInicio
	from calendario cal
	inner join puntodeventa p on p.idPuntoDeVenta = cal.idPuntoDeVenta
	inner join localidad l on l.idLocalidad = p.idLocalidad
	where exists(select 1 from #clientes where idCliente = cal.idCliente) 
	and cal.FechaInicio between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = cal.IdUsuario)) and cal.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=cal.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=cal.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))

	
	insert #tempreporte_PRE (idPuntoDeVenta,idUsuario,fechaCreacion)
	select  
		   p.idPuntoDeVenta,
		   r.idUsuario,
		   r.FechaCreacion
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where  exists(select 1 from #clientes where idCliente = c.idCliente) 
			and
			r.FechaCreacion between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))


	insert into #tempreporte (idPuntoDeVenta,idUsuario,fechaCreacion)
	select idPuntoDeVenta,idUsuario,MinFechaCreacion
	from (select idPuntoDeVenta,idUsuario,convert(char(8),fechaCreacion,112) as dia,min(fechaCreacion) as minFechaCreacion	
	from #tempreporte_PRE
	group by idPuntoDeVenta,idUsuario,convert(char(8),fechaCreacion,112)
	)x

	
	create table #datosFinal
	(
		id int identity(1,1),
		Usuario varchar(max),
		FechaEvento varchar(max),
		Tarea varchar(max),
		Cumplimiento varchar(max),
		HoraCumplimiento varchar(max) 
	)
	
	insert #datosFinal (Usuario,FechaEvento,Tarea,Cumplimiento,HoraCumplimiento)
	select u.Apellido + ', ' + u.Usuario collate database_default as Usuario,
		convert(char(10),tc.FechaInicio,103) + ' ' + convert(char(8),tc.FechaInicio,108) as 'FechaEvento',
		pdv.Nombre as 'Target',
	    (case when t.FechaCreacion is null then '<div style="text-align:center"><span class="text-danger"><i class="fa fa-times-circle fa-2x" style="padding:0"></i></span></div>'
		     else '<div style="text-align:center"><span class="text-success"><i class="fa fa-check-circle fa-2x" style="padding:0"></i></span></div>' end)  as 'Cumplimiento',
		  convert(char(8),t.FechaCreacion,108)  +
		' (' +
		      (case when datediff(hour,tc.FechaInicio,t.FechaCreacion) < 0
			   then convert(varchar(10),datediff(hour,tc.FechaInicio,t.FechaCreacion))
			    +':'+ RIGHT('0'+convert(varchar(10),ABS(datediff(mi,tc.FechaInicio,t.FechaCreacion)%60)),2)
			   else ('+'+convert(varchar(10),datediff(hour,tc.FechaInicio,t.FechaCreacion)))
			    +':'+ RIGHT('0'+convert(varchar(10),ABS(datediff(mi,tc.FechaInicio,t.FechaCreacion)%60)),2)
			  end)
				   + ')'as 'HoraCumplimiento'
	from #tempCalendario tc
	inner join usuario u on u.idUsuario = tc.idUsuario
	inner join puntoDeVenta pdv on pdv.idPuntoDeVenta = tc.idPuntoDeVenta
	left join #tempReporte t --on t.idCliente = tc.idCliente 
		  on t.idPuntoDeVenta = tc.idPuntoDeVenta
		  and t.idUsuario = Tc.idUsuario 
		  and convert(char(10),t.FechaCreacion,103) = convert(char(10),tc.FechaInicio,103)
	where isnull(u.esCheckPos,0)=0
	order by usuario,'FechaEvento','Target'

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
		insert #columnasConfiguracion ( name, title, width) 
		values ('Usuario',         'Usuario',				 5), 
			   ('FechaEvento',     'Fecha hora evento',		 5),
			   ('Tarea',           'Target',					 5),
			   ('Cumplimiento',    'Cumplimiento',			 5),
			   ('HoraCumplimiento','Hora cumplimiento (DIF)',5)


	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) 
		values ('Usuario',         'User',				5), 
			   ('FechaEvento',     'Date of event',		5),
			   ('Tarea',           'Target',				5),
			   ('Cumplimiento',    'Accomplishment',	5),
			   ('HoraCumplimiento','Task time (DIFF)',	5)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select Usuario,FechaEvento,Tarea,Cumplimiento,HoraCumplimiento from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Usuario,FechaEvento,Tarea,Cumplimiento,HoraCumplimiento from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select Usuario,FechaEvento,Tarea,Cumplimiento,HoraCumplimiento from #datosFinal
end
go
