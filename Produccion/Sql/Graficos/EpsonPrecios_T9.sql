IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonPrecios_T9'))
   exec('CREATE PROCEDURE [dbo].[EpsonPrecios_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[EpsonPrecios_T9] 	
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
		idMarca int
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

	create table #CategoriaProducto
	(
		idCategoriaProducto int
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
	declare @cCategoriaProducto varchar(max)

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

	insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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

	insert #CategoriaProducto (idCategoriaProducto) select clave as CategoriaProducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoriaProducto'),',') where isnull(clave,'')<>''
	set @cCategoriaProducto = @@ROWCOUNT
	
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

	select @fechaDesde = DATEADD(week, -2, @fechaDesde)
	select @fechaHasta = DATEADD(week, 2, @fechaHasta)
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #datos
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		dia date,
		minimo numeric(18,5),
		maximo numeric(18,5),
		promedio numeric(18,2)
	)
		
	-------------------------------------------------------------------- END (Temp)

	insert #datos (idEmpresa, idMarca, idProducto, dia, minimo, maximo, promedio)
	select r.idEmpresa, m.idMarca, rp.IdProducto, cast(r.fechaCreacion as date),min(isnull(rp.precio,0)), max(isnull(rp.precio,0)), avg(isnull(rp.precio,0))
	from Reporte r
	inner join ReporteProducto rp on rp.IdReporte = r.IdReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa = r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
			and isnull(rp.precio,0)>0
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias pro where pro.idProvincia in(select idProvincia from localidad loc where loc.idLocalidad = pdv.idLocalidad)))
			and p.Reporte = 1
	group by r.idEmpresa, m.idMarca, rp.IdProducto, cast(r.fechaCreacion as date)

	
		
	alter table #datos
	add semana int

	update #datos
	set semana = datepart(week,dia)

	
	DECLARE @startnum INT
	DECLARE @endnum INT
	create table #semanas(semana int)

	select @startNum = min(semana),
		   @endnum = max(semana) from #datos

	;
	WITH gen AS (
		SELECT @startnum AS num
		UNION ALL
		SELECT num+1 FROM gen WHERE num+1<=@endnum
	)
	insert #semanas(semana)
	select num from gen
	option (maxrecursion 10000)

	create table #productos_pre(idMarca int ,idProducto int)

	insert #productos_pre(idMarca,idProducto)
	select distinct idMarca,idProducto from #datos

	insert #datos(idMarca, idProducto,semana,promedio)
	select p.idMarca,p.idProducto,s.semana,null
	from 
	#semanas s
	cross apply 
	#productos_pre p
	where not exists(select 1 from #datos where idMarca = p.idMarca and idProducto = p.idProducto and semana = s.semana)

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(semana as varchar(10)) + ']','[' + cast(semana as varchar(10)) + ']'
	  )
	FROM (select distinct semana from #datos) x order by semana
	

	DECLARE @PivotColumnHeaders2 VARCHAR(MAX)
	SELECT @PivotColumnHeaders2 = 
	  COALESCE(
		@PivotColumnHeaders2 + ',''$''+[' + cast(semana as varchar(10)) + '] as [' + cast(semana as varchar(10)) + ']','''$''+[' + cast(semana as varchar(10)) + '] as [' + cast(semana as varchar(10)) + ']'
	  )
	FROM (select distinct semana from #datos) x order by semana
	

	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(semana as varchar(10)) + ',0)<>'+char(39)+char(39),'isnull('+cast(semana as varchar(10)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct semana from #datos) x order by semana

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idmarca varchar(max),idproducto varchar(max),promedio varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(semana as varchar(10)) + '" varchar(max)',cast(semana as varchar(10)) + '" varchar(max)'
	  )
	FROM (select distinct semana from #datos) x order by semana


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)
	

	insert #DatosPivot([idmarca],[idproducto],'+@PivotColumnHeaders+')
	SELECT [idmarca],[idproducto],'+@PivotColumnHeaders+'
	  FROM (
		Select idMarca, idProducto,promedio,semana from #Datos
	  ) AS PivotData
	  PIVOT (
		max(promedio)
		FOR semana IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable
	

	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idmarca],[idproducto],'+@PivotColumnHeaders+')
	select [idmarca],[idproducto],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  

	declare @maxpag int
		if('+cast(@TamañoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamañoPagina as varchar)+') from #DatosPivotFinal
	/*select @maxpag*/
	
	select 1

	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		esclave bit,
		mostrar bit,
		esagrupador bit
	)

	insert #columnasDef (name, title, width, esClave,mostrar,esAgrupador) 
	values ('+char(39)+'idMarca'+char(39)+','+char(39)+'Brand'+char(39)+', 1, 0, 0 , 1)
	insert #columnasDef (name, title, width, esClave,mostrar,esAgrupador) 
	values ('+char(39)+'idProducto'+char(39)+','+char(39)+'Producto'+char(39)+', 15, 0, 1, 0)
	
	insert #columnasDef (name, title, width, esClave,Mostrar,esAgrupador)
	select cast(i.semana as varchar) as name, 
		''Semana '' + ltrim(rtrim(cast(i.semana as varchar))) as title, 
		0 as width, 
		0,
		1,
		0
	from #Datos i
	group by i.semana
	order by i.semana asc

	select name,title,width,esclave,mostrar,esagrupador  from #columnasDef
	
	
	/*if('+cast(@NumeroDePagina as varchar)+'>0)
			select cast(DENSE_RANK() OVER   
					(order by d.idMarca asc) as varchar(10))
					 +'' - ''+ m.nombre as idMarca,  
					p.nombre as idProducto ,'+@PivotColumnHeaders2+'
			from #DatosPivotFinal d
			inner join marca m on d.idMarca = m.idMarca
			inner join producto p on p.idProducto = d.idProducto
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select cast(DENSE_RANK() OVER   
					(order by d.idMarca asc) as varchar(10))
					 +'' - ''+ m.nombre as idMarca,  
					  p.nombre as idProducto ,'+@PivotColumnHeaders2+'
			from #DatosPivotFinal d
			inner join marca m on d.idMarca = m.idMarca
			inner join producto p on p.idProducto = d.idProducto
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'<0)	*/
			select cast(DENSE_RANK() OVER   
					(order by m.idSubMarca asc) as varchar(10))
					 +'' - ''+ m.nombre as idMarca,  
					  p.nombre as idProducto ,'+@PivotColumnHeaders2+'
			from #DatosPivotFinal d
				inner join producto p on p.idProducto = d.idProducto
				inner join submarca_producto sp on sp.idProducto = p.idProducto
				inner join SubMarca m on sp.idSubmarca = m.idSubmarca
				and m.idMarca = p.idMarca 
			order by m.idSubMarca
	'	

	EXEC sp_executesql @PivotTableSQL

end

Go



EpsonPrecios_T9 178




