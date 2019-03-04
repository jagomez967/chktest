--BancoChile_SucursalesAuditadas_T9 89
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_SucursalesAuditadas_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_SucursalesAuditadas_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_SucursalesAuditadas_T9]
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

	create table #tempReporte
	(
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #TotalModulos 
	(
		IdReporte int,
		IdMarca int,
		TotalModulos Decimal(18,8)
	) 

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (IdPuntoDeVenta, mes ,idReporte)
	select	r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cBancos,0) = 0 or exists(select 1 from #Bancos where idBanco = p.IdCadena))
			and (isnull(@cTipoSucursal,0) = 0 or exists(select 1 from #tipoSucursal where idTipoSucursal = p.idtipo))
			and (isnull(@cSucursal,0) = 0 or exists(select 1 from #Sucursal where idSucursal = p.IdPuntoDeVenta))
			and (isnull(@cJefeGestion,0) = 0 or exists(select 1 from #JefeGestion where idJefeGestion in (select isnull(id,0) from extData_bancochile_filtroBI where idPuntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cJefeZonal,0) = 0 or exists(select 1 from #JefeZonal where idJefeZonal in (select isnull(idZonal,0) from extData_bancochile_filtroBI where idPUntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
		group by r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	
		
	--idPdv / nombre pdv / Direccion / Zona / auditor / Ultimo reporte dd/mm/aaaa

	create table #datosFinal
	(	idpdv int ,
		nombrePdv nvarchar(255),
		direccion varchar(500),
		zona varchar(100),
		auditor nvarchar(255),
		fechaReporte char(10)
	)

	insert #datosFinal(idPdv,nombrePdv,direccion,zona,auditor,fechaReporte)
	select t.IdPuntoDeVenta,
		   p.nombre,
		   p.direccion,
		   z.nombre,
		   isnull(u.nombre collate database_default + ' ' + u.apellido collate database_default,' '),
		   convert(char(10),r.FechaCreacion,103)
	from #tempReporte t
	inner join puntoDeVenta p on p.idPuntoDeVenta = t.idPuntoDeVenta
	inner join reporte r on r.idReporte = t.idReporte 
	inner join zona z on z.idZona = p.idZona
	left join extData_BancoChile_FiltroBI BI on BI.idPuntoDeVenta = t.idPuntoDeVenta
	left join usuario u on u.idUsuario = r.idUsuario

	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal

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
		insert #columnasConfiguracion (name, title, width) values ('idPdv',' idPDV', 5)
		insert #columnasConfiguracion (name, title, width) values ('nombrePdv','Punto de Venta', 5)
		insert #columnasConfiguracion (name, title, width) values ('direccion','Direccion', 5)
		insert #columnasConfiguracion (name, title, width) values ('zona','Zona', 5)
		insert #columnasConfiguracion (name, title, width) values ('auditor','Auditor(a)', 5)
		insert #columnasConfiguracion (name, title, width) values ('fechaReporte','Ult. Reporte', 5)
	end
	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width) values ('idPdv',' idPDV', 5)
		insert #columnasConfiguracion (name, title, width) values ('nombrePdv','Point of sale', 5)
		insert #columnasConfiguracion (name, title, width) values ('direccion','Address', 5)
		insert #columnasConfiguracion (name, title, width) values ('zona','Area', 5)
		insert #columnasConfiguracion (name, title, width) values ('auditor','Auditor', 5)
		insert #columnasConfiguracion (name, title, width) values ('fechaReporte','Last Report', 5)
	end

	select name,title,width from #columnasConfiguracion
		
	select idPdv,nombrePdv,direccion,zona,auditor,fechaReporte
	from #datosFinal

end
	
go
