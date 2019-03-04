IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_SucursalesAsignadas_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_SucursalesAsignadas_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_SucursalesAsignadas_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
	,@mejores           bit = 0
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

	create table #marcas
	(
		idMarca int
	)

	create table #bancos
	(
		idBanco int
	)


	create table #Sucursal
	(
		idSucursal int
	)

	create table #TipoSucursal
	(
		idTipoSucursal int
	)

	create table #JefeGestion
	(
		idJefeGestion int
	)

	create table #JefeZonal
	(
		idJefeZonal int
	)

	create table #usuarios
	(
		idUsuario int
	)

	declare @cZonas varchar(max)
	declare @cMarcas varchar(max)
	declare @cBancos varchar(max)
	declare @cTipoSucursal varchar(max)
	declare @cJefeGestion varchar(max)
	declare @cJefeZonal varchar(max)
	declare @cSucursal varchar(max)
	declare @cUsuarios varchar(max)

	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		

	insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''
	set @cZonas = @@ROWCOUNT

	insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	set @cMarcas = @@ROWCOUNT
	
	insert #bancos (idBanco) select clave as idBanco from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltBanco'),',') where isnull(clave,'')<>''
	set @cBancos = @@ROWCOUNT
	
	insert #TipoSucursal (idTipoSucursal) select clave as idTipoSucursal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoSucursal'),',') where isnull(clave,'')<>''
	set @cTipoSucursal = @@ROWCOUNT

	insert #JefeGestion (idJefeGestion) select clave as idJefeGestion from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltJefeGestion'),',') where isnull(clave,'')<>''
	set @cJefeGestion = @@ROWCOUNT

	insert #JefeZonal (idJefeZonal) select clave as idJefeZonal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltJefeZonal'),',') where isnull(clave,'')<>''
	set @cJefeZonal = @@ROWCOUNT

	insert #Sucursal (idSucursal) select clave as idSucursal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSucursal'),',') where isnull(clave,'')<>''
	set @cSucursal = @@ROWCOUNT

	insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	set @cUsuarios = @@ROWCOUNT


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

	Create table #PuntosDeVenta(
		id int identity,
		idPuntoDeVenta int,
		email varchar(255),
		idUsuario int,
		nombrePuntoDeVenta varchar(255)
	)

	Create table #PuntosDeVenta_pre(
		idPuntoDeVenta int,
		email varchar(255),
		idUsuario int,
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #PuntosDeVenta_pre(idPuntodeventa,email,idUsuario)
	select distinct
	substring(rt.filtrosBloqueados,
				
			charindex('"idItem"', 
					rt.filtrosBloqueados,
					charindex('"fltSucursal"',
							rt.filtrosBloqueados,
							0))
						+ len('"idItem"') + 2,
							charindex('"Descripcion"',
				rt.filtrosBloqueados,
				charindex('"fltSucursal"',
					rt.filtrosBloqueados,
					0))
			-
			charindex('"idItem"', 
			rt.filtrosBloqueados,
			charindex('"fltSucursal"',
					rt.filtrosBloqueados,
					0)) 
					-len('"IdItem":"",')
			) as puntodeventa,
			u.email,
			u.idUsuario
		From reportingTablero rt 
		inner join reportingTableroUsuario tu
		on tu.idTablero = rt.id
		inner join usuario u
		on u.idUsuario = tu.idUsuario
		where rt.idUsuario = 1625			
	
	insert #PuntosDeVenta(idPuntodeventa,email,idUsuario,nombrePuntoDeVenta)
	select distinct p.idPuntoDeVenta,u.email,u.idUsuario,pdv.nombre
	from #PuntosDeVenta_pre p
	inner join puntodeventa pdv on pdv.idPuntoDeVenta = p.idPuntoDeVenta
	inner join usuario u on u.idUsuario = p.idUsuario
	where   pdv.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cBancos,0) = 0 or exists(select 1 from #Bancos where idBanco = pdv.IdCadena))
			and (isnull(@cTipoSucursal,0) = 0 or exists(select 1 from #tipoSucursal where idTipoSucursal = pdv.idtipo))
			and (isnull(@cSucursal,0) = 0 or exists(select 1 from #Sucursal where idSucursal = pdv.IdPuntoDeVenta))
			and (isnull(@cJefeGestion,0) = 0 or exists(select 1 from #JefeGestion where idJefeGestion in (select isnull(id,0) from extData_bancochile_filtroBI where idPuntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cJefeZonal,0) = 0 or exists(select 1 from #JefeZonal where idJefeZonal in (select isnull(idZonal,0) from extData_bancochile_filtroBI where idPUntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = u.IdUsuario))
	order by u.email,u.idUsuario

	declare @maxpag int
	
	set @TamañoPagina = @TamañoPagina - 1

	if(@TamañoPagina=-1)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #PuntosDeVenta

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
	begin
		insert #columnasConfiguracion (name, title, width) values ('nombrePuntoDeVenta','Nombre Sucursal', 5)
		insert #columnasConfiguracion (name, title, width) values ('idPuntoDeVenta','ID Sucursal', 10)
		insert #columnasConfiguracion (name, title, width) values ('email','E-Mail', 10)
	end
	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width) values ('nombrePuntoDeVenta','Nombre Sucursal', 5)
		insert #columnasConfiguracion (name, title, width) values ('idPuntoDeVenta','ID Sucursal', 10)
		insert #columnasConfiguracion (name, title, width) values ('email','E-Mail', 10)
	end		

	select name,title,width from #columnasConfiguracion
		

	if(@NumeroDePagina>0)
		select nombrePuntoDeVenta collate database_default as nombrePuntoDeVenta,idPuntoDeVenta,email collate database_default as email from #PuntosDeVenta where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select nombrePuntoDeVenta collate database_default as nombrePuntoDeVenta,idPuntoDeVenta,email collate database_default as email from #PuntosDeVenta where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select nombrePuntoDeVenta collate database_default as nombrePuntoDeVenta,idPuntoDeVenta,email collate database_default as email from #PuntosDeVenta
end
	
go
