IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_PerformanceDetallePDV_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_PerformanceDetallePDV_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_PerformanceDetallePDV_T9]
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
		idEmpresa int,
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


	create table #datosFinal
	(
		id int identity(1,1),
		idMarca int,
		idModulo int,
		iditem int,
		Valor1 bit,
		Valor2 bit
	)	


	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idEmpresa, IdPuntoDeVenta, mes, idReporte)
	select	r.idEmpresa
			,r.IdPuntoDeVenta
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
	group by r.IdEmpresa, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	
	declare @meses int
	select @meses = count(1) from #tempreporte 

	--if @meses > 1 
	--begin
	--	return 0
	--end
	
	insert #datosFinal (idMarca, idModulo, idItem , Valor1, Valor2)
	select rmi.idMarca,i.idModulo,rmi.idItem,rmi.Valor1,rmi.Valor2
	from #tempReporte t
	inner join md_reporteModuloItem RMI on RMI.idReporte = t.idReporte
	inner join md_item I on i.idItem = RMI.idItem
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #Marcas where idMarca = rmi.IdMarca))
	
		 	   		
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
		width int,
		esclave bit,
		mostrar bit,
		esagrupador bit
	)

	if(@lenguaje = 'es')
	begin
		--insert #columnasConfiguracion (name, title, width) values ('Marca','Marca',2)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Modulo',	'Modulo',	4, 0, 0, 1)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Item',	'Item',		4, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Valor1',	'Cumple',	1, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Valor2',	'No Cumple',1, 0, 1, 0)
	end

	if(@lenguaje='en')
	begin
		--insert #columnasConfiguracion (name, title, width) values ('Marca','Brand',5)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Modulo','Module',5 ,0, 0, 1)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Item','Item',5, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Valor1','Accomplished',5, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Valor2','Unachieved',5, 0, 1, 0)
	end
	
	select name,title,width,esclave,mostrar,esagrupador from #columnasConfiguracion
		
	--Datos
	create table #datosFinal2 
	(id int identity(1,1),
	Modulo varchar(max),
	Item varchar(max),
	Valor1 varchar(max),
	Valor2 varchar(max))

	insert #datosFinal2(Modulo,Item,Valor1,Valor2)
	 select --MA.nombre collate database_default as Marca,
		    MA.nombre + ': ' + MO.Nombre collate database_default as Modulo, 
			I.Nombre collate database_default as Item, 
			CASE WHEN @NumeroDePagina != -1 THEN 
				case when d.Valor1 = 1 then '<p align=center><b>X</b></p>' 
				else ' ' 
				end  
			ELSE 
				case when d.Valor1 = 1 then 'X' 
				else ' ' 
				end  
			END as Valor1,
			CASE WHEN @NumeroDePagina != -1 THEN 
				case when d.Valor2 = 1 then '<p align=center><b>X</b></p>' 
				else ' ' 
				end
			ELSE 
				case when d.Valor2 = 1 then 'X' 
				else ' ' 
				end
			END as Valor2
	 from #datosFinal d
	 inner join marca MA on Ma.idMarca = d.idMarca
	 inner join md_modulo MO on MO.idModulo = d.idModulo
	 inner join md_item I on I.idItem = d.idItem



	if(@NumeroDePagina>0)
		select Modulo,Item,Valor1,Valor2 from #datosFinal2
		where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Modulo,Item,Valor1,Valor2 from #datosFinal2 
		where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
	if(@NumeroDePagina<0)
		select Modulo,Item,Valor1,Valor2 from #datosFinal2 

END
GO
