SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report_Mattel360_1_3_CompetitorsOPP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Report_Mattel360_1_3_CompetitorsOPP] AS' 
END
GO
ALTER procedure [dbo].[Report_Mattel360_1_3_CompetitorsOPP] 	
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

	
	create table #reportesMesPdv
	(
		idEmpresa int,
		idCadena int,
		mes varchar(8),
		idReporte int
	)

		create table #reportesMesPdvPeriodoAnterior
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
		idproducto int,
		precio decimal (9,3)
	)


	-------------------------------------------------------------------- END (Temps)
	
	insert #reportesMesPdv (idEmpresa, idCadena, mes, idReporte)
	select r.IdEmpresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6), max(r.IdReporte)
	from Checkpos_Arg_Microsoft.dbo.Reporte r
	inner join Checkpos_Arg_Microsoft.dbo.PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Checkpos_Arg_Microsoft.dbo.Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=6
			--and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			--and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			--and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			--and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			--and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			--and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
			and pdv.IdTipo is not null
	group by r.IdEmpresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6)

	create table #sugerido
	(
		idProducto int,
		Precio decimal(9,3),
		SKU varchar(15)
	)


			insert #sugerido (idProducto, Precio, SKU) values (199,4990,'DMM06')
			insert #sugerido (idProducto, Precio, SKU) values (198,4990,'T7439')
			insert #sugerido (idProducto, Precio, SKU) values (201,6990,'T7580')
			insert #sugerido (idProducto, Precio, SKU) values (200,5990,'T7584')
			insert #sugerido (idProducto, Precio, SKU) values (268,3990,'DHD57')
			insert #sugerido (idProducto, Precio, SKU) values (270,2990,'Y8621')
			insert #sugerido (idProducto, Precio, SKU) values (241,9990,'CDM61')
			insert #sugerido (idProducto, Precio, SKU) values (272,9990,'DRT61')
			insert #sugerido (idProducto, Precio, SKU) values (205,8990,'DLB34')
			insert #sugerido (idProducto, Precio, SKU) values (204,5990,'DTK49')
			insert #sugerido (idProducto, Precio, SKU) values (217,5990,'K7167')
			insert #sugerido (idProducto, Precio, SKU) values (232,5490,'1806')
			insert #sugerido (idProducto, Precio, SKU) values (230,1090,'C4982')
			insert #sugerido (idProducto, Precio, SKU) values (231,3290,'K5904')
			insert #sugerido (idProducto, Precio, SKU) values (273,3990,'DPF00')
			insert #sugerido (idProducto, Precio, SKU) values (215,8990,'W3618')
			insert #sugerido (idProducto, Precio, SKU) values (214,14990,'BLW15')
			insert #sugerido (idProducto, Precio, SKU) values (213,11990,'CBL61')
			insert #sugerido (idProducto, Precio, SKU) values (267,11990,'DJB12')
			insert #sugerido (idProducto, Precio, SKU) values (240,9990,'DJG08')
			insert #sugerido (idProducto, Precio, SKU) values (239,5990,'Y5572')
			insert #sugerido (idProducto, Precio, SKU) values (238,7990,'Y5573')
			insert #sugerido (idProducto, Precio, SKU) values (225,9990,'CNH09')
			insert #sugerido (idProducto, Precio, SKU) values (226,21990,'DCH63/DCH62')
			insert #sugerido (idProducto, Precio, SKU) values (227,14990,'DKX58')
			insert #sugerido (idProducto, Precio, SKU) values (228,23990,'DKX60')
			insert #sugerido (idProducto, Precio, SKU) values (271,14990,'DMX50')
			insert #sugerido (idProducto, Precio, SKU) values (206,8990,'DKY17')
			insert #sugerido (idProducto, Precio, SKU) values (203,5990,'DNV65')
			insert #sugerido (idProducto, Precio, SKU) values (209,3990,'CBW79')
			insert #sugerido (idProducto, Precio, SKU) values (210,3990,'CFP20')
			insert #sugerido (idProducto, Precio, SKU) values (211,6990,'CFY28')
			insert #sugerido (idProducto, Precio, SKU) values (212,8990,'CMG40')
			insert #sugerido (idProducto, Precio, SKU) values (208,1990,'K7704')


	

	insert #datos(idempresa, idcadena, idproducto, precio)
	select r.idEmpresa, r.idCadena, rp.IdProducto, isnull(rp.Precio,0) from #reportesMesPdv r
	inner join Checkpos_Arg_Microsoft.dbo.ReporteProducto rp on rp.IdReporte = r.idReporte
	where isnull(rp.Precio,0)>0

	insert #datos (idempresa, idcadena, idproducto, precio)
	select r.idEmpresa, r.idCadena, rp.IdProducto, isnull(rp.Precio,0) from #reportesMesPdv r
	inner join Checkpos_Arg_Microsoft.dbo.ReporteProductoCompetencia rp on rp.IdReporte = r.idReporte
	where isnull(rp.Precio,0)>0

	create table #datosRes
	(
		id int identity(1,1),
		idcadena varchar (200),
		cadena varchar (100),
		idproducto int,
		producto varchar (100),
		sugerido decimal (10,2),
		precio decimal (10,2),
		valor varchar (20)
	)

	insert #datosRes (idcadena, cadena, idproducto, producto, sugerido, precio, valor)
	select 'col'+cast(d.idcadena as varchar(8)), replace(c.Nombre,' ',''), d.idproducto, ltrim(rtrim(p.nombre)), s.Precio, d.precio, d.precio from #datos d
	left join #sugerido s on d.idproducto = s.idProducto
	inner join Checkpos_Arg_Microsoft.dbo.Cadena c on c.IdCadena = d.idcadena
	inner join Checkpos_Arg_Microsoft.dbo.Producto p on p.IdProducto = d.idproducto

	insert #datosRes (idcadena, cadena, idproducto, producto, sugerido, precio, valor)
	select 'col'+cast(d.idcadena as varchar(8))+'_p', replace(c.Nombre,' ','') + '_p', d.idproducto, ltrim(rtrim(p.nombre)), s.Precio, d.precio, LEFT(cast((d.precio*100.0/s.Precio)-100.0 as varchar),5) + '%' from #datos d
	left join #sugerido s on d.idproducto = s.idProducto
	inner join Checkpos_Arg_Microsoft.dbo.Cadena c on c.IdCadena = d.idcadena
	inner join Checkpos_Arg_Microsoft.dbo.Producto p on p.IdProducto = d.idproducto

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idcadena as varchar(500)) + ']','[' + cast(idcadena as varchar(500)) + ']'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena

	DECLARE @PivotColumnHeadersFields VARCHAR(MAX)
	SELECT @PivotColumnHeadersFields = 
	  COALESCE(
		@PivotColumnHeadersFields + ',isnull([' + cast(idcadena as varchar(500)) + '],' + char(39) + '-' + char(39) + ') as [' + cast(idcadena as varchar(500)) + ']','isnull([' + cast(idcadena as varchar(500)) + '],' + char(39) + '-' + char(39) + ') as [' + cast(idcadena as varchar(500)) + ']'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idProducto int'
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

	insert #DatosPivot([idProducto],'+@PivotColumnHeaders+')
	SELECT [idProducto],'+@PivotColumnHeaders+'
	  FROM (
		Select idCadena, idProducto, valor from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(valor)
		FOR idcadena IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable
		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idProducto],'+@PivotColumnHeaders+')
	select [idProducto],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'

	declare @maxpag int

	if('+cast(@TamañoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamañoPagina as varchar)+') from #DatosPivotFinal

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(m.nombre)) as Marca, ltrim(rtrim(p.nombre)) as ProductoMattel, ltrim(rtrim(s.SKU)) as SKU, s.Precio as Precio, ltrim(rtrim(mc.nombre)) as MarcaCompetencia, ltrim(rtrim(pc2.Nombre)) as ProductoCompetencia, '+@PivotColumnHeadersFields+'
			from #DatosPivotFinal d
			inner join Checkpos_Arg_Microsoft.dbo.producto p on p.idproducto=d.idproducto
			inner join #sugerido s on s.idproducto = d.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.marca m on m.idmarca = p.idmarca
			inner join Checkpos_Arg_Microsoft.dbo.ProductoCompetencia pc on pc.idproducto = p.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.Producto pc2 on pc2.idproducto = pc.idproductocompetencia
			inner join Checkpos_Arg_Microsoft.dbo.Marca mc on mc.idmarca=pc2.idmarca
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(m.nombre)) as Marca, ltrim(rtrim(p.nombre)) as ProductoMattel, ltrim(rtrim(s.SKU)) as SKU, s.Precio as Precio, ltrim(rtrim(mc.nombre)) as MarcaCompetencia, ltrim(rtrim(pc2.Nombre)) as ProductoCompetencia, '+@PivotColumnHeadersFields+'
			from #DatosPivotFinal d
			inner join Checkpos_Arg_Microsoft.dbo.producto p on p.idproducto=d.idproducto
			inner join #sugerido s on s.idproducto = d.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.marca m on m.idmarca = p.idmarca
			inner join Checkpos_Arg_Microsoft.dbo.ProductoCompetencia pc on pc.idproducto = p.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.Producto pc2 on pc2.idproducto = pc.idproductocompetencia
			inner join Checkpos_Arg_Microsoft.dbo.Marca mc on mc.idmarca=pc2.idmarca
			where d.id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(m.nombre)) as Marca, ltrim(rtrim(p.nombre)) as ProductoMattel, ltrim(rtrim(s.SKU)) as SKU, s.Precio as Precio, ltrim(rtrim(mc.nombre)) as MarcaCompetencia, ltrim(rtrim(pc2.Nombre)) as ProductoCompetencia, '+@PivotColumnHeadersFields+'
			from #DatosPivotFinal d
			inner join Checkpos_Arg_Microsoft.dbo.producto p on p.idproducto=d.idproducto
			inner join #sugerido s on s.idproducto = d.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.marca m on m.idmarca = p.idmarca
			inner join Checkpos_Arg_Microsoft.dbo.ProductoCompetencia pc on pc.idproducto = p.idproducto
			inner join Checkpos_Arg_Microsoft.dbo.Producto pc2 on pc2.idproducto = pc.idproductocompetencia
			inner join Checkpos_Arg_Microsoft.dbo.Marca mc on mc.idmarca=pc2.idmarca
	'	
	EXEC sp_executesql @PivotTableSQL

end
GO
