IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_Cumplimiento_Calendario_T8'))
   exec('CREATE PROCEDURE [dbo].[Edding_Cumplimiento_Calendario_T8] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Edding_Cumplimiento_Calendario_T8] 	
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
	
	insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''
	set @cFamilia = @@ROWCOUNT
	
	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT
	
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
	where  exists(select 1 from #clientes where idCliente = cal.idCliente)
	and cal.FechaInicio between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = cal.IdUsuario))  and cal.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=cal.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=cal.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		
	--and cal.idPuntoDeVenta in (select idPuntoDeVenta from PuntoDeVenta where idCliente = uc.IdCliente)
	

	insert #tempreporte_PRE (idPuntoDeVenta,idUsuario,fechaCreacion)
	select  
		   p.idPuntoDeVenta,
		   r.idUsuario,
		   r.FechaCreacion
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	inner join usuario u on u.idUsuario = r.idUsuario
	where   exists(select 1 from #clientes where idCliente = c.idCliente)
			and r.FechaCreacion between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and isnull(u.escheckpos,0) = 0
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and isnull(u.esCheckPos,0)=0
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
				
	insert into #tempreporte (idPuntoDeVenta,idUsuario,fechaCreacion)
	select idPuntoDeVenta,idUsuario,MinFechaCreacion
	from (select idPuntoDeVenta,idUsuario,convert(char(8),fechaCreacion,112) as dia,min(fechaCreacion) as minFechaCreacion	
	from #tempreporte_PRE
	group by idPuntoDeVenta,idUsuario,convert(char(8),fechaCreacion,112)
	)x
	

	create table #datosFinal
	(idDia    char(8),
	idUsuario int,
	visitado  int,
	idPdv     int)


	insert #datosFinal(idDia, idUsuario, visitado, idPdv)
	select convert(char(8),tc.FechaInicio,112) as idDia,
		   tc.idUsuario,
		   case when tr.idPuntoDeVenta is null then 0
		   else 1
		   end,
		   tc.idPuntoDeVenta
	from #tempCalendario tc
	left join #tempreporte tr on tr.idPuntoDeVenta = tc.idPuntoDeVenta
			and tr.idUsuario = tc.idUsuario
			and convert(char(8),tr.FechaCreacion,112) = convert(char(8),tc.FechaInicio,112)
					  

	create table #resultadoPorDia
	(idDia char(8),
	 qty int,
	 EstadoVisita int
	 )
	
	
	insert #resultadoPorDia (idDia,qty,EstadoVisita)
	select idDia as idDia,
		   count(idPdv) ,--QTY
		   visitado
	from #datosFinal
	where visitado = 1
	group by idDia, right(idDia,2) +' ' +left(datename(month,idDia),3) + ' ' + right(left(idDia,4),2) ,visitado
	union
		select idDia as idDia,
		count(idPdv) ,--QTY
		visitado
	from #datosFinal
	where visitado = 0
	group by idDia, right(idDia,2) +' ' +left(datename(month,idDia),3) + ' ' + right(left(idDia,4),2) ,visitado

	create table #DiasEstadoVisita
	(	idDia char(8),
		NombreDia char(11), --'dd mmm yyyy'
		etiquetaVisita nvarchar(20) collate database_default, --'Relevado'/'No relevado'
		EstadoVisita int
	 )	
	
	insert #DiasEstadoVisita(idDia ,nombreDia,EtiquetaVisita,EstadoVisita)
	select idDia,
		   right(idDia,2) +' ' +left(datename(month,idDia),3) + ' ' + right(left(idDia,4),2),
		   'No Cumplio',
		    0
	from #resultadoPorDia
	union
	select idDia,
		   right(idDia,2) +' ' +left(datename(month,idDia),3) + ' ' + right(left(idDia,4),2),
		   'Cumplio',
		   1 
	from #resultadoPorDia


	select distinct e.idDia,e.nombreDia,e.etiquetaVisita,isnull(r.qty,0),e.estadoVisita as visitado 
	from #diasEstadoVisita e
 	left join #resultadoPordia r on r.idDia = e.idDia and r.EstadoVisita = e.EstadoVisita
	order by e.idDia

/*--------------------------------------------------------------------------------------------------*/
/*----------------------------------Query 2 --------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------*/

	create table #resultadoPorUsuario
	(idDia char(8),
	 idUsuario int,
	 qty int,
	 EstadoVisita int
	 )
		 

	insert #resultadoPorUsuario(idDia,idUsuario,qty,estadoVisita)
	select d.idDia as idDia,
		   d.idUsuario, --idUsuario,
		   count(d.idPdv) ,--QTY
		   d.visitado 
	from #datosFinal d
	where d.visitado = 1
	group by d.idDia
			 ,d.idUsuario
			 ,d.visitado 
	union
		select d.idDia as idDia,
			   d.idUsuario, --idUsuario,
			   count(d.idPdv) ,--QTY 
			   d.visitado
	from #datosFinal d
	where d.visitado = 0
	group by d.idDia
			 ,d.idUsuario
	         ,d.visitado


	create table #UsuarioEstadoVisita
	(	idDia char(8),
	    idUsuario int,
		nombreUsuario nvarchar(max) collate database_default
	 )	
	
	insert #UsuarioEstadoVisita(idDia ,idUsuario,NombreUsuario)
	select r.idDia,
		   r.idUsuario,
		   u.Apellido + ', ' + u.Usuario
	from #resultadoPorUsuario r
	inner join usuario u on u.idUsuario = r.idUsuario


	select distinct e.idDia,e.nombreDia,u.idUsuario,u.NombreUsuario,e.etiquetaVisita,isnull(r.qty,0),e.estadoVisita as visitado 
	from #diasEstadoVisita e
	inner join #usuarioEstadoVisita u on e.idDia = u.idDia
 	left join #resultadoPorUsuario r on r.idDia = e.idDia and r.EstadoVisita = e.EstadoVisita and r.idUsuario = u.idUsuario			
	



end

go
