IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_SegmentoSOSShare_T9'))
   exec('CREATE PROCEDURE [dbo].[Mattel_SegmentoSOSShare_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Mattel_SegmentoSOSShare_T9
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
	declare @difDias int
	declare @strFDesdePeriodoAnterior varchar(30)
	declare @strFHastaPeriodoAnterior varchar(30)
	
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


	set @difDias = DATEDIFF(DAY, @fechaDesde, @fechaHasta)
	set @strFDesdePeriodoAnterior = CONVERT(varchar,dateadd(day,-@difDias-1,@fechaDesde),112)
	set @strFHastaPeriodoAnterior = convert(varchar,dateadd(day,-@difDias-1,@fechaHasta),112)

	-------------------------------------------------------------------- END (Filtros)


	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idCadena int,
		idReporte int
	)

		create table #reportesMesPdvPeriodoAnterior
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idCadena int
	)

	create table #datos
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int,
		idproducto int,
		idmarca int,
		idPuntodeventa int,
		idcadena int
	)

	create table #datosPeriodoAnterior
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int,
		idcadena int
	)

	create table #datosResultados
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int,
		idcadena int
	)
	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idCadena, idReporte)
	select r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), pdv.IdCadena, max(r.IdReporte)
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
			and pdv.IdTipo is not null
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), pdv.IdCadena

	insert #datos(idempresa, idPuntodeventa, idproducto, idmarca, valor, idcadena)
	select r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto, p.IdMarca, sum(isnull(rp.precio,0)), r.idCadena
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	where isnull(rp.precio,0)>0
	group by  r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto, p.IdMarca, r.idCadena

	insert #datos (idempresa, idPuntodeventa, idproducto, idmarca, valor, idcadena)
	select m.idempresa, r.idPuntoDeVenta, rp.IdProducto, m.IdMarca, sum(isnull(rp.precio,0)), r.idCadena
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join ProductoCompetencia pc on pc.IdProductoCompetencia=rp.IdProducto
	inner join Producto p on p.IdProducto = pc.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.precio,0)>0
	group by  m.idempresa, r.idPuntoDeVenta, rp.IdProducto, m.IdMarca, r.idCadena

	create table #totalpormarca
	(
		idcadena int,
		idmarca int,
		qty numeric(10,2)
	)
	insert #totalpormarca (idcadena, idmarca, qty)
	select d.idcadena, d.idmarca, sum(d.valor) from #datos d
	group by d.idcadena, d.idmarca
	order by 2

	create table #datosRes
	(
		id int identity(1,1),
		idcadena varchar (50),
		cadena varchar(100),
		idempresa int,
		empresa varchar (100),
		idproducto int,
		producto varchar (100),
		total numeric(10,2),
		share numeric(10,2)
	)

	insert #datosRes(idcadena, cadena, idempresa, empresa, idproducto, producto, total, share)
	select 'col'+cast(d.idcadena as varchar), ltrim(rtrim(c.Nombre)),e.IdEmpresa, e.Nombre, d.idproducto, ltrim(rtrim(p.Nombre)), sum(d.valor), cast(sum(d.valor)*100.0/temp.qty as numeric(10,2)) from #datos d
	inner join Cadena c on c.IdCadena = d.idcadena
	inner join Producto p on p.IdProducto = d.idproducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join Empresa e on e.IdEmpresa = m.IdEmpresa
	inner join #totalpormarca temp on temp.idmarca = d.idmarca and temp.idcadena = d.idcadena
	group by d.idcadena, c.Nombre, e.IdEmpresa, e.Nombre, d.idproducto, p.Nombre, temp.qty



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
		Select idProducto, idCadena, share from #DatosRes
	  ) AS PivotData
	  PIVOT (
		sum(share)
		FOR idcadena IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
		 
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
	select @maxpag


	create table #columnasDef
	(
		name varchar(100),
		title varchar(100),
		width int,
		orden int
	)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idEmpresa'+char(39)+','+char(39)+'Fabricante'+char(39)+', 50, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idProducto'+char(39)+','+char(39)+'Producto'+char(39)+', 50, 1)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idcadena as varchar) as name, i.cadena as title, 40 as width, 5 as orden
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(e.nombre)) as idEmpresa, ltrim(rtrim(p.nombre)) as idProducto,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join producto p on p.idproducto = d.idproducto
			inner join marca m on m.idmarca = p.idmarca
			inner join empresa e on e.idempresa = m.idempresa
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(e.nombre)) as idEmpresa, ltrim(rtrim(p.nombre)) as idProducto,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join producto p on p.idproducto = d.idproducto
			inner join marca m on m.idmarca = p.idmarca
			inner join empresa e on e.idempresa = m.idempresa
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(e.nombre)) as idEmpresa, ltrim(rtrim(p.nombre)) as idProducto,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join producto p on p.idproducto = d.idproducto
			inner join marca m on m.idmarca = p.idmarca
			inner join empresa e on e.idempresa = m.idempresa

	'	

	EXEC sp_executesql @PivotTableSQL

	
end