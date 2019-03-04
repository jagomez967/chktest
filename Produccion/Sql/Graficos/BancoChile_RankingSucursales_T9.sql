IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_RankingSucursales_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_RankingSucursales_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_RankingSucursales_T9]
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



	create table #datosFinal_pre
	(
		id int identity(1,1),
		idPDV int,
		mes varchar(20),
		qty numeric(18,5)
	)	

		create table #tablaPonderaciones
	(	idReporte int,
		idMarca int,
		ponderacionMarca decimal(9,5),
		idModulo int,
		ponderacionModulo decimal(9,5),
		idItem int,
		PonderacionItem decimal(9,5),
		Valor bit
	)
	CREATE NONCLUSTERED INDEX IX_reporte  
	ON #tablaPonderaciones (idReporte)  
	INCLUDE ([PonderacionMarca]);  
 


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
		and exists (select 1 from md_reporteModuloitem where idReporte = r.idReporte)
		group by r.IdEmpresa, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	--jefe gestion / cod + nombre PDV / Cumplimiento % (avg meses aplicados)

	--SI EL MODULO O ITEM NO LLEGA A CUBIR EL 100%, ENTONCES TENGO QUE ACTUALIZAR LAS PONDERACIONES.
	exec BancoChile_Calculo_Ponderacion
	

	insert #datosFinal_pre (idPDV, mes, qty)
	SELECT temp.idPuntoDeVenta as IdPDV 
		  ,left(temp.mes,6) as mes
		  , round((sum((t.Valor * t.PonderacionItem / 100.0)* (t.PonderacionModulo /100.0) * (t.PonderacionMarca / 100.0))/count(distinct t.idReporte))*100.0,2)
			as Performance
	FROM #tempReporte temp
	inner join #tablaPonderaciones t on t.IdReporte = temp.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=temp.IdPuntoDeVenta
	GROUP BY temp.idPuntoDeVenta, temp.mes	
	--Agrupo por mes para cada punto de venta

	
	create table #datosFinal
	(	id int identity,
		jefeGestion nvarchar(255),
		nombrePDV nvarchar(255),
		cumplimiento decimal(18,2)
	)


	if @mejores = 0
	begin
		insert #datosFinal(jefeGestion,nombrePDV,cumplimiento)
		select top 10 isnull(BI.jefeGestion,'') 'jefeGestion',
			   convert(varchar(20),pdv.codigoadicional) + ' - ' + isnull(BI.NombreOficina,pdv.nombre) 'nombrePDV',
			   round(avg(d.qty),2) 'Cumplimiento'
		from #datosFinal_pre d
		left join extData_BancoChile_FiltroBI BI on BI.idPuntoDeVenta = d.idPDV
		inner join puntodeventa pdv on pdv.idpuntodeventa = d.idpdv
		group by BI.jefeGestion, convert(varchar(20),pdv.codigoadicional) + ' - ' + isnull(BI.NombreOficina,pdv.nombre) 
		order by cumplimiento desc
	end
	else
	begin
	insert #datosFinal(jefeGestion,nombrePDV,cumplimiento)
		select top 10 isnull(BI.jefeGestion,'') 'jefeGestion',
			   convert(varchar(20),pdv.codigoadicional) + ' - ' + isnull(BI.NombreOficina,pdv.nombre) 'nombrePDV',
			   round(avg(d.qty),2) 'Cumplimiento'
		from #datosFinal_pre d
		left join extData_BancoChile_FiltroBI BI on BI.idPuntoDeVenta = d.idPDV
		inner join puntodeventa pdv on pdv.idpuntodeventa = d.idpdv
		group by BI.jefeGestion, convert(varchar(20),pdv.codigoadicional) + ' - ' + isnull(BI.NombreOficina,pdv.nombre)
		order by cumplimiento asc
	end
			   		
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
		insert #columnasConfiguracion (name, title, width) values ('Posicion','Posicion', 5)
		insert #columnasConfiguracion (name, title, width) values ('jefeGestion','Jefe Gestion', 5)
		insert #columnasConfiguracion (name, title, width) values ('nombrePDV','Cod - Nombre PDV', 5)
		insert #columnasConfiguracion (name, title, width) values ('cumplimiento','Cumplimiento', 5)
	end
	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width) values ('Posicion','Posicion', 5)
		insert #columnasConfiguracion (name, title, width) values ('jefeGestion','Jefe Gestion', 5)
		insert #columnasConfiguracion (name, title, width) values ('nombrePDV','Cod - Nombre PDV', 5)
		insert #columnasConfiguracion (name, title, width) values ('cumplimiento','Cumplimiento', 5)
	end		

	select name,title,width from #columnasConfiguracion
		
	--Datos
	if @mejores = 0
	begin
		select top 10 row_number() OVER(ORDER BY cumplimiento DESC) AS Posicion,jefeGestion,nombrePDV,cumplimiento from #datosFinal
		order by cumplimiento desc
	end
	else
	begin
		select top 10 row_number() OVER(ORDER BY cumplimiento ASC) AS Posicion,jefeGestion,nombrePDV,cumplimiento from #datosFinal
		order by cumplimiento asc
	end

end
	
go
