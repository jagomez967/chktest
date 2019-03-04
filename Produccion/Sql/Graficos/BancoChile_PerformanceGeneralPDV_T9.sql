--[BancoChile_performanceGeneralPDV_T9] 3

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_performanceGeneralPDV_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_performanceGeneralPDV_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_performanceGeneralPDV_T9]
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
		idPDV int,
		NombrePDV varchar(500),
		mes varchar(20),
		NombreMes varchar(100),
		qty numeric(18,2),
		result varchar(200)
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
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
			and (isnull(@cJefeGestion,0) = 0 or exists(select 1 from #JefeGestion where idJefeGestion in (select isnull(id,0) from extData_bancochile_filtroBI where idPuntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cJefeZonal,0) = 0 or exists(select 1 from #JefeZonal where idJefeZonal in (select isnull(idZonal,0) from extData_bancochile_filtroBI where idPUntoDeVenta = p.idPuntoDeVenta)))
	group by r.IdEmpresa, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	
	--select * from #tempreporte
	--SI EL MODULO O ITEM NO LLEGA A CUBIR EL 100%, ENTONCES TENGO QUE ACTUALIZAR LAS PONDERACIONES.
	exec BancoChile_Calculo_Ponderacion

	
	insert #datosFinal (idPDV, NombrePDV, mes,NombreMes, qty)
	SELECT temp.idPuntoDeVenta as IdPDV 
		  ,pdv.Nombre as NombrePDV
		  ,left(temp.mes,6) as mes
		  ,Datename(mm,temp.mes) + ' ' + Datename(yy,temp.mes) as NombreMes
		  , round((sum((t.Valor * t.PonderacionItem / 100.0)* (t.PonderacionModulo /100.0) * (t.PonderacionMarca / 100.0))/count(distinct t.idReporte))*100.0,2)
			as Performance
	FROM #tempReporte temp
	inner join #tablaPonderaciones t on t.IdReporte = temp.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=temp.IdPuntoDeVenta
	GROUP BY temp.idPuntoDeVenta, pdv.Nombre, temp.mes, Datename(mm,temp.mes) + ' ' + Datename(yy,temp.mes)
	
	--select * from #tablaponderaciones
	--select * from md_reporteModuloItem where idReporte = 460152
	--select * from reporte where idReporte = 460152

	--update #datosFinal
	--set qty = round(qty,2)

	update #datosFinal
	set qty = 100.0
	where qty > 100.0
	
	update #datosFinal 
	set Result = case when 
					qty >= 0.0 and qty < 70.0 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
				 when 
					qty >= 70.0 and qty < 85.0 then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
				 when 
					qty >= 85.0 and qty <= 100.0 then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
				 end 
				 +' '+ cast(qty as varchar(100)) + ' %'	
		
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
		insert #columnasConfiguracion (name, title, width) values ('PuntoDeVenta','Punto De Venta',5)
	
	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('PuntoDeVenta','Point of sale',5)

	insert #columnasConfiguracion (name,title, width)
	select  cast(datename(month, x.mes+'01')+cast(year(x.mes+'01') as varchar) as varchar) as name 
		   ,cast(datename(month, x.mes+'01')+' '+cast(year(x.mes+'01') as varchar) as varchar) as title
			,10 as width
    from (select distinct mes from #datosFinal) x 
	order by x.mes

	select name,title,width from #columnasConfiguracion
	
	

	--Datos
	declare @PivotWhere varchar(max)
	if(@NumeroDePagina>0)
	select @PivotWhere = ' where id between (('+convert(varchar(100),@NumeroDePagina)+' - 1) * '+convert(varchar(MAX),@TamañoPagina)+' + 1) and ('+convert(varchar(100),@NumeroDePagina)+' * '+convert(varchar(MAX),@TamañoPagina)+')'
	
	if(@NumeroDePagina=0)
	select @PivotWhere = ' where id between (('+convert(varchar(100),@maxpag)+' - 1) * '+convert(varchar(MAX),@TamañoPagina)+' + 1) and ('+convert(varchar(100),@maxpag)+' * '+convert(varchar(MAX),@TamañoPagina)+')'
	
	if(@NumeroDePagina<0)
    select @PivotWhere = ' '


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar) + ']',
		'[' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar)+ ']'
	  )
	FROM (select distinct mes from #DatosFinal) x
	order by mes asc

	DECLARE @ColDef VARCHAR(MAX)
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar)+ ' nvarchar(4000)',
		cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar) + ' nvarchar(4000)'
	  )
	FROM (select distinct mes from #DatosFinal) x order by mes asc


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	  CREATE TABLE #tablaPivot 
	  ( id int identity(1,1),
	    PuntoDeVenta varchar(max),
		'+ @ColDef +'
	  )

	  insert #tablaPivot (PuntoDeVenta,'+@PivotColumnHeaders+')
	  SELECT [PuntoDeVenta],'+@PivotColumnHeaders+'
	  FROM (
		SELECT
		  NombrePDV as PuntoDeVenta,
		  datename(month, mes+'+char(39)+'01'+char(39)+')+cast(year(mes+'+char(39)+'01'+char(39)+') as varchar) as mes,
		  /*cast(Qty as numeric(18,2)) as cantidad*/
		  result as resultado
		FROM #DatosFinal 

		) AS PivotData
	  PIVOT (
		MAX(resultado)
		FOR Mes IN (
		  ' + @PivotColumnHeaders + ')
		) AS PivotTable
	

	select [PuntoDeVenta],'+@PivotColumnHeaders+'
	from #tablaPivot
	 '+ @PivotWhere 

	EXECUTE(@PivotTableSQL)
end
go