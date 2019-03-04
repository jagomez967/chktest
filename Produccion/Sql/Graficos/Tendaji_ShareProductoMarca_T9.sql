IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Tendaji_ShareProductoMarca_T9'))
   exec('CREATE PROCEDURE [dbo].[Tendaji_ShareProductoMarca_T9] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].Tendaji_ShareProductoMarca_T9
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
		idPuntoDeVenta int,
		idUsuario int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		Producto varchar(500),
		Familia varchar(500),
		idMarca int,
		cantidad decimal(18,2)
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, idUsuario, mes, idReporte)
	select r.idempresa, r.idPuntoDeVenta, r.idUsuario, left(convert(varchar,r.fechacreacion,112),6), max(r.IdReporte)
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
	group by r.idempresa, r.idPuntoDeVenta, r.idUsuario, left(convert(varchar,r.fechacreacion,112),6)


	insert #datos (idMarca, Familia, Producto, cantidad)
	select m.idMarca, replace(left(f.Nombre+' ', charindex(' ',f.Nombre+' ')),' ',''), left(p.Nombre, charindex('-',p.Nombre)), sum(isnull(rp.Precio,0)) from #reportesMesPdv r
	inner join ReporteProducto rp on rp.IdReporte = r.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join Familia f on f.idFamilia = p.idFamilia
	where isnull(rp.Precio,0) > 0
	group by m.idMarca, left(p.Nombre, charindex('-',p.Nombre)), replace(left(f.Nombre+' ', charindex(' ',f.Nombre+' ')),' ','')

	insert #datos (idMarca, Familia, Producto, cantidad)
	select m.idMarca, replace(left(f.Nombre+' ', charindex(' ',f.Nombre+' ')),' ',''), left(p2.Nombre, charindex('-',p2.Nombre)), sum(isnull(rp.Precio,0)) from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte = r.idReporte
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p on p.idProducto = pc.idProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join Producto p2 on p2.idProducto = pc.idProductoCompetencia
	inner join Familia f on f.idFamilia = p2.idFamilia
	where isnull(rp.Precio,0) > 0
	group by m.idMarca, left(p2.Nombre, charindex('-',p2.Nombre)), replace(left(f.Nombre+' ', charindex(' ',f.Nombre+' ')),' ','')


	create table #datosRes
	(
		idmarca varchar (8),
		marca varchar (100),
		Familia varchar(500),
		Producto varchar(500),
		share decimal(18,2)
	)

	insert #datosRes (idmarca, marca, Familia, Producto, share)
	select 'col'+cast(d.idMarca as varchar(8)), ltrim(rtrim(m.Nombre)), UPPER(ltrim(rtrim(d.Familia))), ltrim(rtrim(d.Producto)), d.cantidad
	from #datos d
	inner join Marca m on m.idMarca = d.idMarca


	create table #totalRow
	(
		idmarca varchar (8),
		marca varchar (100),
		Familia varchar(500),
		Producto varchar(500),
		share decimal(18,2)
	)

	insert #totalRow (idMarca, marca, Familia, share)
	select 'col'+cast(d.idMarca as varchar(8)), ltrim(rtrim(m.Nombre)), 'Total', sum(cantidad) from #datos d
	inner join Marca m on m.idMarca = d.idMarca
	group by 'col'+cast(d.idMarca as varchar(8)), ltrim(rtrim(m.Nombre))



	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idmarca as varchar(500)) + ']','[' + cast(idmarca as varchar(500)) + ']'
	  )
	FROM (select distinct idmarca from #datosRes) x order by idmarca
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idmarca as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idmarca as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idmarca from #datosRes) x order by idmarca

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='Familia varchar(max), Producto varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(idmarca as varchar(500)) + ' varchar(max)',cast(idmarca as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct idmarca from #datosRes) x order by idmarca



	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([Familia],[Producto],'+@PivotColumnHeaders+')
	SELECT [Familia],[Producto],'+@PivotColumnHeaders+'
	  FROM (
		Select Familia, Producto, idMarca, share from #DatosRes
	  ) AS PivotData
	  PIVOT (
		sum(share)
		FOR idmarca IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable


	insert #DatosPivot([Familia],[Producto],'+@PivotColumnHeaders+')
	SELECT [Familia],[Producto],'+@PivotColumnHeaders+'
	  FROM (
		Select Familia, Producto, idMarca, share from #totalRow
	  ) AS PivotData
	  PIVOT (
		sum(share)
		FOR idmarca IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable


	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([Familia],[Producto],'+@PivotColumnHeaders+')
	select [Familia],[Producto],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'

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

	
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'familia'+char(39)+','+char(39)+'Familia'+char(39)+', 5, 0)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'producto'+char(39)+','+char(39)+'Producto'+char(39)+', 5, 1)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idmarca as varchar) as name, i.marca as title, 5 as width, 1 as orden
	from #DatosRes i

	select name, title, width from #columnasDef


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(d.Familia)) as familia,ltrim(rtrim(d.Producto)) as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(d.Familia)) as familia,ltrim(rtrim(d.Producto)) as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(d.Familia)) as familia,ltrim(rtrim(d.Producto)) as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d

	'	

	EXEC sp_executesql @PivotTableSQL


end