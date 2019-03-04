IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Buhl_DistZonas_T9'))
   exec('CREATE PROCEDURE [dbo].[Buhl_DistZonas_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Buhl_DistZonas_T9]
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
	
	create table #Clientes
	(
		idCliente int
	)

	create table #Categorias
	(
		idCategoria int
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
	declare @cClientes varchar(max)
	declare @cCategorias varchar(max)

	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		

	insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	set @cMarcas = @@ROWCOUNT

	insert #Categorias (idCategoria) select clave as idCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategorias = @@ROWCOUNT
	
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
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end
	
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
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		idEmpresa int,
		Empresa varchar(500),
		idZona int,
		qty int
	)

	create table #datosRes
	(
		id int identity(1,1),
		idEmpresa varchar(100),
		Empresa varchar(500),
		idZona int,
		qty numeric(18,2)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte)
	select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategorias,0) = 0 or exists(select 1 from #Categorias where idCategoria = p.idCategoria))
	group by r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6)


	create table #RelevadosZona
	(
		idZona int,
		qty int
	)

	insert #RelevadosZona (qty, idZona)
	select count(distinct r.idPuntoDeVenta), pdv.idZona from #reportesMesPdv r
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
	group by pdv.idZona


	insert #datos (idEmpresa, Empresa, idZona, qty)
	select m.idEmpresa, e.Nombre, pdv.idZona, count(distinct r.idPuntoDeVenta) from #reportesMesPdv r
	inner join ReporteProducto rp on rp.idReporte = r.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
	inner join Empresa e on e.idEmpresa = m.idEmpresa
	where isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0) > 0
	group by m.idEmpresa, e.Nombre, pdv.idZona


	insert #datos (idEmpresa, Empresa, idZona, qty)
	select m.idEmpresa, m.Nombre, pdv.idZona, count(distinct r.idPuntoDeVenta) from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.idReporte = r.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
	where isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0) > 0
	group by m.idEmpresa, m.Nombre, pdv.idZona


	create table #totalEmpresa
	(
		idEmpresa varchar(10),
		total numeric(18,2)
	)


	insert #datosRes (d.idEmpresa, Empresa, d.idZona, qty)
	select 'col'+cast(d.idEmpresa as varchar(100)), d.Empresa, d.idZona, avg(d.qty*100.0/rz.qty) from #datos d
	inner join #RelevadosZona rz on rz.idZona = d.idZona
	group by d.idEmpresa, d.Empresa, d.idZona

	insert #totalEmpresa (idEmpresa, total)
	select idEmpresa, sum(qty)/(select count(distinct idZona) from #datos) from #datosRes
	group by idEmpresa



	alter table #datosRes
	alter column qty varchar(100)
	alter table #totalEmpresa
	alter column total varchar(100)

	update #datosRes set qty = qty+' %'
	update #totalEmpresa set total = total+' %'


	
	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idEmpresa as varchar(500)) + ']','[' + cast(idEmpresa as varchar(500)) + ']'
	  )
	FROM (select distinct idEmpresa from #datosRes) x order by idEmpresa
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idEmpresa as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idEmpresa as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idEmpresa from #datosRes) x order by idEmpresa

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idZona varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(idEmpresa as varchar(500)) + '" varchar(max)',cast(idEmpresa as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct idEmpresa from #datosRes) x order by idEmpresa



	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idZona],'+@PivotColumnHeaders+')
	SELECT [idZona],'+@PivotColumnHeaders+'
	  FROM (
		Select idEmpresa, idZona, qty from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(qty)
		FOR idEmpresa IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable



	CREATE TABLE #totalRow
	(
		[total] varchar(100),
		'+@ColDef+'
	)

	insert #totalRow ([total], '+@PivotColumnHeaders+')
	select ''TotalPdv'', '+@PivotColumnHeaders+' from (
			select idEmpresa, total from #totalEmpresa
			) as x
		PIVOT (
			max(total) for idEmpresa in (
					'+@PivotColumnHeaders+',
					[totalRow]
								) 
							)as PivotSum
	
		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idZona],'+@PivotColumnHeaders+')
	select [idZona],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  

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

	
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Zona'+char(39)+','+char(39)+'Zona'+char(39)+', 80, -1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'TotalPdv'+char(39)+','+char(39)+'TotalPdv'+char(39)+', 80, 0)
	

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idEmpresa as varchar) as name, i.Empresa as title, 40 as width, 5
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name
	

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select z.Nombre as Zona, rz.qty as TotalPdv, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Zona z on z.idZona = d.idZona
			inner join #RelevadosZona rz on rz.idZona = d.idZona
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			union all
			select total collate database_default as Zona, (select sum(qty) from #RelevadosZona) as TotalPdv, '+@PivotColumnHeaders+' from #totalRow
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select z.Nombre as Zona, rz.qty as TotalPdv, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Zona z on z.idZona = d.idZona
			inner join #RelevadosZona rz on rz.idZona = d.idZona
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			union all
			select total collate database_default as Zona, (select sum(qty) from #RelevadosZona) as TotalPdv, '+@PivotColumnHeaders+' from #totalRow
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select z.Nombre as Zona, rz.qty as TotalPdv, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Zona z on z.idZona = d.idZona
			inner join #RelevadosZona rz on rz.idZona = d.idZona
			union all
			select total collate database_default as Zona, (select sum(qty) from #RelevadosZona) as TotalPdv, '+@PivotColumnHeaders+' from #totalRow

	'	

	EXEC sp_executesql @PivotTableSQL


end