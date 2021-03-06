IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Colgram_ObjCobertura_T9'))
   exec('CREATE PROCEDURE [dbo].[Colgram_ObjCobertura_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Colgram_ObjCobertura_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamaņoPagina		int = 0
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #Relevados
	(
		idUsuario int
		,Fecha varchar(7)
		,semana varchar(9)
		,qty int
	)


	-------------------------------------------------------------------- TEMPS (Filtros)		
		
	insert #Relevados (idUsuario, Fecha, semana, qty)
	select	r.IdUsuario
			,'W'+convert(varchar,datepart(wk,FechaCreacion))
			,'col'+convert(varchar,datepart(wk,FechaCreacion))
			,count(r.idPuntoDeVenta)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join ReporteMarcaPropiedad rmp on rmp.idReporte = r.idReporte
	where convert(date,r.FechaCreacion) between convert(date,@fechadesde) and convert(date,@fechahasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))	
	and isnull(rmp.idMarcaPropiedad,0) = 6383
	group by r.IdUsuario,'W'+convert(varchar,datepart(wk,FechaCreacion)),'col'+convert(varchar,datepart(wk,FechaCreacion))


	create table #VisitasMes
	(
		idUsuario int,
		total int,
		objetivoMes int,
		objetivoSemana int,
		cumplimiento numeric(18,2)
	)
	
	insert #VisitasMes (idUsuario, total, objetivoMes, objetivoSemana, cumplimiento)
	select r.idUsuario, sum(isnull(qty,0)), oc.mensual, oc.semanal, sum(isnull(qty,0))*100.0/oc.mensual from #Relevados r
	inner join ObjetivosColgram oc on r.idUsuario = oc.idUsuario
	group by r.idUsuario, oc.mensual, oc.semanal


	create table #datosRes
	(
		idUsuario int,
		semana varchar(9),
		qty int,
	)

	insert #datosRes (idUsuario, semana, qty)
	select idUsuario, semana, qty from #Relevados



	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(semana as varchar(500)) + ']','[' + cast(semana as varchar(500)) + ']'
	  )
	FROM (select distinct semana from #datosRes) x order by semana

	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(semana as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(semana as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct semana from #datosRes) x order by semana

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idusuario int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(semana as varchar(500)) + ' varchar(max)',cast(semana as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct semana from #datosRes) x order by semana

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idusuario], '+@PivotColumnHeaders+')
	SELECT [idusuario], '+@PivotColumnHeaders+'
	  FROM (
		Select idusuario, semana, qty from #DatosRes
		) AS PivotData
	  PIVOT (
		max(qty)
		FOR semana IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable


	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idusuario],'+@PivotColumnHeaders+')
	select [idusuario],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
	

	declare @maxpag int
		if('+cast(@TamaņoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamaņoPagina as varchar)+') from #DatosPivotFinal
	select @maxpag

	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		orden int
	)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Usuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 150, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Objetivo Semanal'+char(39)+','+char(39)+'Objetivo Semanal'+char(39)+', 150, 96)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Total'+char(39)+','+char(39)+'Total'+char(39)+', 150, 97)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Objetivo Mensual'+char(39)+','+char(39)+'Objetivo Mensual'+char(39)+', 150, 98)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Cumplimiento'+char(39)+','+char(39)+'Cumplimiento'+char(39)+', 150, 99)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.semana as varchar) as name, left(i.Fecha,7) as title, 40 as width, 5 as orden
	from #Relevados i

	select name, title, width, orden from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario,'+@PivotColumnHeaders+', vm.objetivoSemana as [Objetivo Semanal], vm.total as Total, vm.objetivoMes as [Objetivo Mensual], vm.cumplimiento as Cumplimiento
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #VisitasMes vm on vm.idUsuario = d.idUsuario
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamaņoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamaņoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario,'+@PivotColumnHeaders+', vm.objetivoSemana as [Objetivo Semanal], vm.total as Total, vm.objetivoMes as [Objetivo Mensual], vm.cumplimiento as Cumplimiento
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #VisitasMes vm on vm.idUsuario = d.idUsuario
			where id between ((@maxpag - 1) * '+cast(@TamaņoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamaņoPagina as varchar)+')

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario,'+@PivotColumnHeaders+', vm.objetivoSemana as [Objetivo Semanal], vm.total as Total, vm.objetivoMes as [Objetivo Mensual], vm.cumplimiento as Cumplimiento
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #VisitasMes vm on vm.idUsuario = d.idUsuario
			
	'	
	
	EXEC sp_executesql @PivotTableSQL


end
go