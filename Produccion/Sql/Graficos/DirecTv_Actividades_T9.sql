IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.DirecTv_Actividades_T9'))
   exec('CREATE PROCEDURE [dbo].[DirecTv_Actividades_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure dbo.DirecTv_Actividades_T9
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #datos
	(
		idReporte int,
		idItem varchar(100),
		Observaciones varchar(max),
		item int
	)
	
	insert #datos(idReporte, idItem, Observaciones, item)
	select r.idReporte, 'col'+cast(i.IdItem as varchar), mrep.Valor4, i.IdItem
	from MD_ReporteModuloItem mrep
	inner join Reporte r on r.IdReporte=mrep.IdReporte
	inner join PuntoDeVenta P on P.IdPuntoDeVenta = r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join MD_Item i on i.IdItem=mrep.IdItem
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and i.IdModulo=92
	order by i.iditem

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(iditem as varchar(500)) + ']','[' + cast(iditem as varchar(500)) + ']'
	  )
	FROM (select distinct iditem from #Datos) x order by iditem
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct iditem from #Datos) x order by iditem

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idReporte int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(iditem as varchar(500)) + ' varchar(max)',cast(iditem as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct iditem from #Datos) x order by iditem
	
	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idReporte],'+@PivotColumnHeaders+')
	SELECT [idReporte],'+@PivotColumnHeaders+'
	  FROM (
		Select idReporte, idItem, Observaciones from #Datos
	  ) AS PivotData
	  PIVOT (
		max(Observaciones)
		FOR iditem IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idReporte],'+@PivotColumnHeaders+')
	select [idReporte],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  
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
			orden int
		)'

		if(@lenguaje='es')
		begin
			set @PivotTableSQL = @PivotTableSQL + 'insert #columnasDef (name, title, width, orden) values ('+char(39)+'idReporte'+char(39)+','+char(39)+'Reporte'+char(39)+', 50, 1)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'fechaCreacion'+char(39)+','+char(39)+'Fecha'+char(39)+', 50, 2)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'pdv'+char(39)+','+char(39)+'Punto de Venta'+char(39)+', 50, 3)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'rtm'+char(39)+','+char(39)+'Usuario'+char(39)+', 50, 4)'
		end
		
		if(@lenguaje='en')
		begin
			set @PivotTableSQL = @PivotTableSQL + 'insert #columnasDef (name, title, width, orden) values ('+char(39)+'idReporte'+char(39)+','+char(39)+'Report'+char(39)+', 50, 1)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'fechaCreacion'+char(39)+','+char(39)+'Date'+char(39)+', 50, 2)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'pdv'+char(39)+','+char(39)+'Point of Sale'+char(39)+', 50, 3)
					insert #columnasDef (name, title, width, orden) values ('+char(39)+'rtm'+char(39)+','+char(39)+'User'+char(39)+', 50, 4)'
		end

		set @PivotTableSQL = @PivotTableSQL + '
		insert #columnasDef (name, title, width, orden)
		select '+char(39)+'col'+char(39)+'+cast(i.iditem as varchar) as name, i.nombre as title, 100 as width, 5 as orden
		from MD_Item i
		where IdModulo=92 and Activo=1
		and exists(select 1 from #Datos where #Datos.item=i.iditem)

		select name, title, width from #columnasDef order by orden, name

		if('+cast(@NumeroDePagina as varchar)+'>0)
			select r.idReporte, r.FechaCreacion as fechaCreacion,ltrim(rtrim(pdv.nombre)) as pdv, u.Apellido+'+char(39)+', '+char(39)+'+u.Nombre collate database_default as rtm,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join reporte r on r.idreporte = d.idreporte
			inner join puntodeventa pdv on pdv.idpuntodeventa=r.idpuntodeventa
			inner join Usuario u on u.idusuario = r.idusuario
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select r.idReporte, r.FechaCreacion as fechaCreacion,ltrim(rtrim(pdv.nombre)) as pdv, u.Apellido+'+char(39)+', '+char(39)+'+u.Nombre collate database_default as rtm,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join reporte r on r.idreporte = d.idreporte
			inner join puntodeventa pdv on pdv.idpuntodeventa=r.idpuntodeventa
			inner join Usuario u on u.idusuario = r.idusuario
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select r.idReporte, r.FechaCreacion as fechaCreacion,ltrim(rtrim(pdv.nombre)) as pdv, u.Apellido+'+char(39)+', '+char(39)+'+u.Nombre collate database_default as rtm,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join reporte r on r.idreporte = d.idreporte
			inner join puntodeventa pdv on pdv.idpuntodeventa=r.idpuntodeventa
			inner join Usuario u on u.idusuario = r.idusuario
	  '	

	EXEC sp_executesql @PivotTableSQL
end