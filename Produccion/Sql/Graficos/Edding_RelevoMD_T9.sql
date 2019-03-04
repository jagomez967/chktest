IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_RelevoMD_T9'))
   exec('CREATE PROCEDURE [dbo].[Edding_RelevoMD_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Edding_RelevoMD_T9
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

	create table #reportesMesPdv
	(
		IdPuntoDeVenta int,
		usuario int,
		idReporte int,
		Fecha varchar(8)
	)

	create table #datos
	(
		id int identity(1,1),
		pdv int,
		usuario int,
		valor varchar (max),
		iditem int,
		preg varchar(max),
		orden int,
		modulo int
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (IdPuntoDeVenta, Usuario, idReporte, Fecha)
	select r.IdPuntoDeVenta, r.idUsuario, r.IdReporte, left(convert(varchar,r.fechacreacion,112),6)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	
	
	insert #datos (pdv, usuario, valor, iditem, preg, orden, modulo)
	select r.IdPuntoDeVenta, r.usuario, isnull(mi.LabelCampo1,'')+' - '+mdr.Valor4 as valor, mi.IdItem, mi.Nombre, mi.Orden as preg, mm.idModulo from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	where isnull(mdr.valor1,0) > 0

	insert #datos (pdv, usuario, valor, iditem, preg, orden, modulo)
	select r.IdPuntoDeVenta, r.usuario, isnull(mi.LabelCampo2,'')+' - '+mdr.Valor4 as valor, mi.IdItem, mi.Nombre, mi.Orden as preg, mm.idModulo from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	where isnull(mdr.Valor2,0) > 0

	insert #datos (pdv, usuario, valor, iditem, preg, orden, modulo)
	select r.IdPuntoDeVenta, r.usuario, isnull(mi.LabelCampo3,'')+' - '+mdr.Valor4 as valor, mi.IdItem, mi.Nombre, mi.Orden as preg, mm.idModulo from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	where isnull(mdr.Valor3,0) > 0

	--insert #datos (pdv, usuario, valor, iditem, preg, orden, modulo)
	--select r.IdPuntoDeVenta, r.usuario, NULL as valor, mi.IdItem, mi.Nombre, mi.Orden as preg, mm.idModulo from MD_ReporteModuloItem mdr
	--inner join MD_Item mi on mi.IdItem = mdr.IdItem
	--inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	--inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte


	--Acá debería sumar los PDVs que no relevaron items con columnas vacías

	--insert #datos (pdv, usuario, valor, iditem, preg, orden)
	--select rmp.IdPuntoDeVenta, rmp.usuario, NULL as valor, mi.IdItem, mi.Nombre, mi.Orden as preg from #reportesMesPdv rmp, MD_ReporteModuloItem mdr
	--inner join MD_Item mi on mi.IdItem = mdr.IdItem
	--inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	--inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	--where rmp.IdPuntoDeVenta in (select distinct idPuntoDeVenta from #asignados where idPuntoDeVenta not in (select pdv from #datos))


	create table #datosRes
	(
		id int identity(1,1),
		idreporte int,
		iditem int,
		preg varchar(100),
		pdv varchar(max),
		modulo varchar(max),
		usuario varchar(max),
		valor varchar(max)
	)


	insert #datosRes (iditem, preg, pdv, modulo, usuario, valor)
	select orden, preg, pdv, modulo, usuario, valor from #datos order by orden


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(iditem as varchar(500)) + ']','[' + cast(iditem as varchar(500)) + ']'
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idreporte varchar(max), pdv varchar(max), usuario varchar(max), modulo varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(iditem as varchar(500)) + '" varchar(max)',cast(iditem as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idreporte],[pdv],[usuario], [modulo],'+@PivotColumnHeaders+')
	SELECT [idreporte],[pdv],[usuario], [modulo],'+@PivotColumnHeaders+'
	  FROM (
		Select idreporte, iditem, pdv, usuario, modulo, valor from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(valor)
		FOR iditem IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable

		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([pdv],[usuario], [modulo],'+@PivotColumnHeaders+')
	select [pdv],[usuario], [modulo],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  

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
	)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idPdv'+char(39)+','+char(39)+'idPdv'+char(39)+', 80, -4)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Nombre'+char(39)+','+char(39)+'PDV'+char(39)+', 80, -3)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Usuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 80, -2)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Modulo'+char(39)+','+char(39)+'Marca'+char(39)+', 80, -1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Item'+char(39)+','+char(39)+'Producto'+char(39)+', 80, 0)
	

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.iditem as varchar) as name, i.preg as title, 40 as width, i.iditem
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name
	

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select d.pdv as idPdv, pdv.Nombre, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Modulo, mdm.Nombre as Item,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join MD_Modulo mdm on mdm.idModulo = d.modulo
			inner join MD_ModuloMarca mm on mm.idModulo = d.modulo
			inner join Marca m on m.idMarca = mm.idMarca
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			order by mdm.Nombre

		if('+cast(@NumeroDePagina as varchar)+'=0)
			select d.pdv as idPdv, pdv.Nombre, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Modulo, mdm.Nombre as Item,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join MD_Modulo mdm on mdm.idModulo = d.modulo
			inner join MD_ModuloMarca mm on mm.idModulo = d.modulo
			inner join Marca m on m.idMarca = mm.idMarca
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			order by mdm.Nombre

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select d.pdv as idPdv, pdv.Nombre, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Modulo, mdm.Nombre as Item,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join MD_Modulo mdm on mdm.idModulo = d.modulo
			inner join MD_ModuloMarca mm on mm.idModulo = d.modulo
			inner join Marca m on m.idMarca = mm.idMarca
			order by mdm.Nombre

	'	

	EXEC sp_executesql @PivotTableSQL


end