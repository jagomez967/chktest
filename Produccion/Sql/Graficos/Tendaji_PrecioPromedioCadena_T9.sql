IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Tendaji_PrecioPromedioCadena_T9'))
   exec('CREATE PROCEDURE [dbo].[Tendaji_PrecioPromedioCadena_T9] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].Tendaji_PrecioPromedioCadena_T9
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

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idCadena int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		id int identity(1,1),
		idempresa int,
		idcadena int,
		idProducto int,
		sugerido decimal(18,2),
		precio decimal (18,2)
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idCadena, mes, idReporte)
	select r.idempresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6), r.IdReporte
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))

	insert #datos (idempresa, idcadena, idProducto, sugerido, precio)
	select r.idEmpresa, r.idCadena, rp.idProducto, ts.Sugerido, avg(isnull(rp.Precio,0)) from #reportesMesPdv r
	inner join ReporteProducto rp on rp.IdReporte = r.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join TendajiSugerido ts on ts.idProducto = rp.idProducto
	where isnull(rp.Precio,0)>0
	group by r.idEmpresa, r.idCadena, rp.IdProducto, ts.Sugerido


	create table #datosRes
	(
		idcadena varchar (8),
		cadena varchar (100),
		idProducto int,
		sugerido decimal (18,2),
		precio varchar(max)
	)

	insert #datosRes (idcadena, cadena, idproducto, sugerido, precio)
	select 'col'+cast(d.idcadena as varchar(8)), ltrim(rtrim(c.Nombre)), d.idProducto, d.Sugerido,
		case when @NumeroDePagina>=0 then
			case when d.Sugerido > d.Precio then cast(d.precio as varchar(max))+' <img src="images/circuloRojo.png" width="16" height="16"/>'
			when d.Sugerido < d.Precio then cast(d.precio as varchar(max))+' <img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
			when d.Sugerido = d.Precio then cast(d.precio as varchar(max))+' <img src="images/circuloVerde.png" width="16" height="16"/>' end
			else cast(d.precio as varchar(max)) end
	from #datos d
	inner join Cadena c on c.idCadena = d.idCadena


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idcadena as varchar(500)) + ']','[' + cast(idcadena as varchar(500)) + ']'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idProducto int, sugerido decimal(18,2)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(idcadena as varchar(500)) + ' varchar(max)',cast(idcadena as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena



	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idProducto],[sugerido],'+@PivotColumnHeaders+')
	SELECT [idProducto],[sugerido],'+@PivotColumnHeaders+'
	  FROM (
		Select idProducto, sugerido, idCadena, precio from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(precio)
		FOR idcadena IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable


	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idProducto],[sugerido],'+@PivotColumnHeaders+')
	select [idProducto], [sugerido],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'

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

	
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'producto'+char(39)+','+char(39)+'Producto'+char(39)+', 5, 0)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'sugerido'+char(39)+','+char(39)+'Precio Sugerido'+char(39)+', 5, 1)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idcadena as varchar) as name, i.cadena as title, 5 as width, 7 as orden
	from #DatosRes i

	select name, title, width from #columnasDef


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(p.Nombre)) as producto, d.Sugerido as sugerido, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			
			
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(p.Nombre)) as producto, d.Sugerido as sugerido, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(p.Nombre)) as producto, d.Sugerido as sugerido, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			

	'	

	EXEC sp_executesql @PivotTableSQL


end