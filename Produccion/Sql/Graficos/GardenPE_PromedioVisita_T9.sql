IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GardenPE_PromedioVisita_T9'))
   exec('CREATE PROCEDURE [dbo].[GardenPE_PromedioVisita_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[GardenPE_PromedioVisita_T9]
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

	create table #tempReporte
	(
		id int identity(1,1),
		IdReporte int,
		año int,
		mes int,
		dia int,
		idPuntoDeVenta int,
		idUsuario int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------


	insert #tempReporte (IdReporte, año,mes,dia,idPuntoDeVenta,idUsuario)
	select max(r.idReporte),
		   datepart(year,r.fechaCreacion),
		   datepart(month,r.fechaCreacion),
		   datepart(day,r.fechaCreacion),
		   r.idPuntoDeVenta,
		   u.idUsuario
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	inner join usuario u on u.idUsuario = r.idUsuario
	where   c.idCliente= @IdCliente
			and r.fechaCreacion between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and isnull(u.escheckpos,0) = 0
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and  isnull(u.esCheckPos,0)=0
	group by	
		   datepart(year,r.fechaCreacion),
		   datepart(month,r.fechaCreacion),
		   datepart(day,r.fechaCreacion),
	r.idPuntoDeVenta	, u.idUsuario
	
	create table #DatosParcial
	(
		idUsuario int,
		dia int,
		mes int,
		año int,
		Cantidad int
	)
	
	insert #datosParcial(idUsuario,dia,mes,año,cantidad)
	select idUsuario,dia,mes,año,count(idReporte)
	from #tempreporte
	group by idUsuario,dia,mes,año
		
	create table #datosfinal(
		id int identity
		,idUsuario int
		--tipo varchar(10), --VISITA/OBJETIVO
		,Fecha varchar(20)
		--cantidad decimal(13,2).
		,visita decimal(13,2)
		,objetivo decimal(13,2)
	)
	
	insert #datosFinal(idUsuario,fecha,visita,objetivo)
	select dp.idusuario,
	datename(month,convert(date,cast(dp.año as varchar) + right('00' + cast(dp.mes as varchar),2) + '01'))
	+ ' ' +	
	cast(dp.año as varchar)
	, (sum(dp.cantidad)*1.0)/20,cast(pv.visitas as int)*1.0
	from #datosParcial dp
	inner join gardenPE_PromedioVisitaDiaria pv
	on pv.idZona = dp.idUsuario
	and pv.Mes = dp.Mes
	and pv.año = dp.año
	group by dp.idUsuario,dp.mes,dp.año,pv.visitas
	order by dp.año,dp.idUsuario

	declare @maxpag int
		if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #DatosFinal
	select @maxpag

	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		orden int,
	)

	insert #columnasDef (name, title, width, orden) 
		values ('Fecha','Fecha', 15, 1)
	insert #columnasDef (name, title, width, orden) 
		values ('Usuario','Zona', 10, 2)
	insert #columnasDef (name, title, width, orden) 
		values ('Objetivo','Objetivo', 10, 3)
	insert #columnasDef (name, title, width, orden) 
		values ('Visita','Logrado', 10, 4)

	select name, title, width from #columnasDef order by orden, name
	
	if(@NumeroDePagina>0)
		select u.Usuario,d.Fecha,d.Visita,d.Objetivo 
		from #datosFinal d
		inner join usuario u on u.idUsuario = d.idUsuario
		where d.id between ((@NumeroDePagina- 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	if(@NumeroDePagina=0)
		select u.Usuario,d.Fecha,d.Visita,d.Objetivo
		from #datosFinal d
		inner join usuario u on u.idUsuario = d.idUsuario
		where d.id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
	if(@NumeroDePagina<0)
		select u.Usuario,d.Fecha,d.Visita,d.Objetivo
		from #datosFinal d
		inner join usuario u on u.idUsuario = d.idUsuario

	/*
	insert #datosFinal(idUsuario,tipo,Fecha,cantidad)
	select dp.idUsuario,'VISITA',convert(date,cast(dp.año as varchar) + right('00' + cast(dp.mes as varchar),2) + '01'),
	(sum(dp.cantidad)*1.0)/ 20
		--DAY(DATEADD(DD,-1,DATEADD(MM,DATEDIFF(MM,-1,
		--	convert(date,cast(dp.año as varchar) + right('00' + cast(dp.mes as varchar),2) + '01')
		--),0)))
	from #datosParcial dp	
	group by dp.idUsuario,dp.mes,dp.año
	union 
	select pv.idZona,'OBJETIVO',convert(date,cast(pv.año as varchar) + right('00' + cast(pv.mes as varchar),2) + '01')
	,cast(visitas as int)*1.0
	from gardenPE_PromedioVisitaDiaria pv
	where exists (select 1 from #tempreporte where idUsuario = pv.idZona
				and mes = pv.mes and año = pv.año)


	
	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(Fecha as varchar(500)) + ']','[' + cast(Fecha as varchar(500)) + ']'
	  )
	FROM (select distinct Fecha from #datosFinal) x order by Fecha

	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(Fecha as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(Fecha as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct Fecha from #datosFinal) x order by Fecha

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idUsuario int,tipo varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',[' + cast(Fecha as varchar(500)) + '] varchar(max)','['+cast(Fecha as varchar(500)) + '] varchar(max)'
	  )
	FROM (select distinct Fecha from #datosFinal) x order by Fecha

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idUsuario],[tipo],'+@PivotColumnHeaders+')
	SELECT [idUsuario],[tipo],'+@PivotColumnHeaders+'
	  FROM (
		Select idUsuario,tipo,Fecha, Cantidad from #DatosFinal
		) AS PivotData
	  PIVOT (
		max(Cantidad)
		FOR Fecha IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
	

	

	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idUsuario],[tipo],'+@PivotColumnHeaders+')
	select [idUsuario],[tipo],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
	order by idUsuario,tipo
	

	declare @maxpag int
		if('+cast(@TamañoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamañoPagina as varchar)+') from #DatosPivotFinal
	select @maxpag

	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		orden int,
		esclave bit,
		mostrar bit,
		esagrupador bit
	)

	insert #columnasDef (name, title, width, orden, esclave, mostrar, esagrupador) 
		values ('+char(39)+'idUsuario'+char(39)+','+char(39)+'Zona'+char(39)+', 150, 1, 0, 0, 1)
	insert #columnasDef (name, title, width, orden, esclave, mostrar, esagrupador) 
		values ('+char(39)+'tipo'+char(39)+','+char(39)+'Cobertura'+char(39)+', 150, 2, 0, 1, 0)

	
	insert #columnasDef (name, title, width, orden, esclave, mostrar, esagrupador)
	select distinct cast(i.Fecha as varchar) as name, 
		   datename(month,convert(datetime,i.Fecha,120)) +'' ''+ cast(year(i.Fecha) as varchar) as title,
		    40 as width,
			5 as orden,
			0 as esclave,
			1 as mostrar,
			0 as esagrupador
	from #DatosFinal i

	select name, title, width, esclave, mostrar, esagrupador from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select u.usuario as idUsuario,d.tipo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join usuario u on u.idUsuario = d.idUsuario
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		

		if('+cast(@NumeroDePagina as varchar)+'=0)
			select u.usuario as idUsuario,d.tipo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join usuario u on u.idUsuario = d.idUsuario
			where d.id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select u.usuario as idUsuario,d.tipo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d	
			inner join usuario u on u.idUsuario = d.idUsuario
	'	
	
	EXEC sp_executesql @PivotTableSQL
--select @pivottablesql

*/
end
--GardenPE_PromedioVisita_T9 81
--select * from reportingObjeto where idFamiliaObjeto= 256