IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Garden_CuotaClDirectos_T9'))
   exec('CREATE PROCEDURE [dbo].[Garden_CuotaClDirectos_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Garden_CuotaClDirectos_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@Tama�oPagina		int = 0
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

	create table #datosRes
	(
		idzona int,
		zona varchar(max),
		cumplimiento int,
		Fecha varchar(max),
		FechaT varchar(max)
	)


	insert #datosRes (IdZona, Zona, Cumplimiento, Fecha, FechaT)
	select	vg.IdZona,
			zv.Descripcion as Zona,
			Cumplimiento,
			'col'+convert(varchar(10),convert(date,cast(vg.a�o as varchar) + right('00' + cast(vg.mes as varchar),2) + '01'),112) as Fecha,
			convert(date,cast(vg.a�o as varchar) + right('00' + cast(vg.mes as varchar),2) + '01') as FechaT
	from ETL_CumplimientoVentasGarden vg
	inner join ETL_ZonasVentas zv on zv.IdZona = vg.idZona
	where convert(date,cast(vg.a�o as varchar) + right('00' + cast(vg.mes as varchar),2) + '01') between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	order by Fecha, vg.IdZona
	
	declare @cantMeses int
	select @cantMeses = count(distinct Fecha) from #datosRes
	
	declare @cantZonas int
	select @cantZonas = count(distinct idZona) from #datosRes
	
	create table #totalesZona
	(
		idZona int,
		total numeric
	)

	insert #totalesZona
	select IdZona, isnull(sum(Cumplimiento),0)/@cantMeses from #datosRes
	group by IdZona

	create table #totalesMeses
	(
		mes varchar(100),
		total numeric
	)
	
	insert #totalesMeses
	select Fecha, sum(isnull(Cumplimiento,0))/@cantZonas from #datosRes
	group by Fecha
	union all
	select 'totalRow',sum(total)/@cantZonas from #totalesZona
	
	declare @minRojo int=0, @maxRojo int=64
	declare @minAmarillo int=65, @maxAmarillo int=89
	declare @minVerde int=90

	alter table #totalesZona
	alter column total varchar(100)
	alter table #totalesMeses
	alter column total varchar(100)
	alter table #datosRes
	alter column Cumplimiento varchar(100)
	
	update #datosRes set Cumplimiento = case when Cumplimiento between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when Cumplimiento between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when Cumplimiento >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(Cumplimiento as varchar(100)) + ' %'
	
	update #totalesZona set total = case when total between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when total between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when total >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(total as varchar(100)) + ' %'

	update #totalesMeses set total = case when total between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when total between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when total >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(total as varchar(100)) + ' %'


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(Fecha as varchar(500)) + ']','[' + cast(Fecha as varchar(500)) + ']'
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha

	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(Fecha as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(Fecha as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idZona int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(Fecha as varchar(500)) + ' varchar(max)',cast(Fecha as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idZona],'+@PivotColumnHeaders+')
	SELECT [idZona],'+@PivotColumnHeaders+'
	  FROM (
		Select idZona, Fecha, Cumplimiento from #DatosRes
		) AS PivotData
	  PIVOT (
		max(Cumplimiento)
		FOR Fecha IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
	

	CREATE TABLE #totalRow
	(
		'+@ColDef+',
		totalZ varchar(100)
	)

	insert #totalRow ('+@PivotColumnHeaders+', [totalZ])
	select * from (
			select mes, total as Total from #totalesMeses
			) as x
		PIVOT (
			max(total) for mes in (
					'+@PivotColumnHeaders+',
					[totalRow]
								) 
							)as PivotSum


	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+',
		total varchar(100)
	) 

	insert #DatosPivotFinal ([idZona],'+@PivotColumnHeaders+')
	select [idZona],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
	update #DatosPivotFinal set total = t.total from (select idZona, total from #totalesZona) t where t.idZona = #DatosPivotFinal.idZona
	
	declare @maxpag int
		if('+cast(@Tama�oPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@Tama�oPagina as varchar)+') from #DatosPivotFinal
	select @maxpag

	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		orden int
	)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idZona'+char(39)+','+char(39)+'Zona'+char(39)+', 150, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'total'+char(39)+','+char(39)+'Total'+char(39)+', 150, 13)

	
	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.Fecha as varchar) as name, datename(month,convert(datetime,i.FechaT,120)) +'' ''+ cast(year(i.FechaT) as varchar) as title, 40 as width, 5 as orden
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select char(32) + ltrim(rtrim(zv.Descripcion)) as idZona,'+@PivotColumnHeaders+', tz.total as total
			from #DatosPivotFinal d
			inner join ETL_ZonasVentas zv on zv.IdZona = d.IdZona
			inner join #totalesZona tz on tz.IdZona = d.idZona
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@Tama�oPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@Tama�oPagina as varchar)+')
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select char(32) + ltrim(rtrim(zv.Descripcion)) as idZona,'+@PivotColumnHeaders+', tz.total as total
			from #DatosPivotFinal d
			inner join ETL_ZonasVentas zv on zv.IdZona = d.IdZona
			inner join #totalesZona tz on tz.IdZona = d.idZona
			where id between ((@maxpag - 1) * '+cast(@Tama�oPagina as varchar)+' + 1) and (@maxpag * '+cast(@Tama�oPagina as varchar)+')
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select char(32) + ltrim(rtrim(zv.Descripcion)) as idZona,'+@PivotColumnHeaders+', tz.total as total
			from #DatosPivotFinal d
			inner join ETL_ZonasVentas zv on zv.IdZona = d.IdZona
			inner join #totalesZona tz on tz.IdZona = d.idZona
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow
						
			
	'	
	
	EXEC sp_executesql @PivotTableSQL

	--select @PivotColumnHeaders
	--select @PivotWhereCondition
	--select @ColDef

	----Cantidad de p�ginas
	--declare @maxpag int
	--select @maxpag = ceiling(count(*)*1.0/@Tama�oPagina) from #datosFinal
	--select @maxpag

	----Configuracion de columnas
	--create table #columnasConfiguracion
	--(
	--	name varchar(50),
	--	title varchar(50),
	--	width int
	--)

	--if(@lenguaje = 'es')
	--	insert #columnasConfiguracion (name, title, width) values ('Zona','Zona',40),('Real','Real',50),('Cuota','Cuota',60),('Cumplimiento','%',30)

	--if(@lenguaje = 'en')
	--	insert #columnasConfiguracion (name, title, width) values ('Zona','Zone',10),('Real','Real',10),('Cuota','Quota',60),('Cumplimiento','%',30)

	--select name, title, width from #columnasConfiguracion

	----Datos
	--if(@NumeroDePagina>0)
	--	select Zona,Real,Cuota,Cumplimiento from #datosFinal where id between ((@NumeroDePagina - 1) * @Tama�oPagina + 1) and (@NumeroDePagina * @Tama�oPagina)
	
	--if(@NumeroDePagina=0)
	--	select Zona,Real,Cuota,Cumplimiento from #datosFinal where id between ((@maxpag - 1) * @Tama�oPagina + 1) and (@maxpag * @Tama�oPagina)
		
	--if(@NumeroDePagina<0)
	--	select Zona,Real,Cuota,Cumplimiento from #datosFinal
	
	

	--exec Garden_CuotaClDirectos_T9 null,'M,20160101,20160505'

	
	end