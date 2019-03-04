IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_POSReportShare_T9'))
   exec('CREATE PROCEDURE [dbo].[Mattel_POSReportShare_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Mattel_POSReportShare_T9
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
		idPuntodeventa int,
		espropio bit
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

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte)
	select distinct r.IdPuntoDeVenta, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), r.IdReporte
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and p.IdTipo is not null
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), r.IdReporte

	insert #datos(idempresa, idPuntodeventa, idproducto, valor, espropio)
	select r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto, sum(isnull(rp.precio,0)), 1
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	where isnull(rp.precio,0)>0
	group by  r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto

	insert #datos (idempresa, idPuntodeventa, idproducto, valor, espropio)
	select m.idempresa, r.idPuntoDeVenta, rp.IdProducto, sum(isnull(rp.precio,0)), 0
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.precio,0)>0
	group by  m.idempresa, r.idPuntoDeVenta, rp.IdProducto

	create table #totalporpdv
	(
		idpdv int,
		qty numeric(10,2)
	)
	insert #totalporpdv (idpdv, qty)
	select idPuntodeventa, sum(valor) from #datos group by idPuntodeventa order by idPuntodeventa

	create table #datosRes
	(
		id int identity(1,1),
		idempresa varchar(50),
		empresa varchar(100),
		idpuntodeventa int,
		pdv varchar (100),
		total numeric(10,2),
		share numeric(10,2)
	)

	insert #datosRes(idempresa, empresa, idpuntodeventa, pdv, total, share)
	select 'col'+cast(d.idempresa as varchar), ltrim(rtrim(e.Nombre)) , d.idpuntodeventa, ltrim(rtrim(pdv.Nombre)), sum(d.valor), cast(sum(d.valor)*100.0/t.qty as numeric(10,2)) from #datos d
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.idPuntodeventa
	inner join Empresa e on e.IdEmpresa = d.idempresa
	inner join #totalporpdv t on t.idpdv = d.idPuntodeventa
	group by d.idempresa, e.Nombre, d.idPuntodeventa, pdv.Nombre, t.qty
	order by e.Nombre, pdv.Nombre

	--select p.Nombre, d.valor from #datos d
	--inner join Producto p on p.IdProducto = d.idproducto
	--where d.idPuntodeventa = 1458 and d.espropio = 1
	--select * from #datosRes where idpuntodeventa = 1458
	

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idempresa as varchar(500)) + ']','[' + cast(idempresa as varchar(500)) + ']'
	  )
	FROM (select distinct idempresa from #datosRes) x order by idempresa
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idempresa as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idempresa as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idempresa from #datosRes) x order by idempresa

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idPuntoDeVenta int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(idempresa as varchar(500)) + ' varchar(max)',cast(idempresa as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct idempresa from #datosRes) x order by idempresa


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idPuntoDeVenta],'+@PivotColumnHeaders+')
	SELECT [idPuntoDeVenta],'+@PivotColumnHeaders+'
	  FROM (
		Select idPuntoDeVenta, idEmpresa, share from #DatosRes
	  ) AS PivotData
	  PIVOT (
		sum(share)
		FOR idempresa IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idPuntoDeVenta],'+@PivotColumnHeaders+')
	select [idPuntoDeVenta],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  
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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idPuntoDeVenta'+char(39)+','+char(39)+'Punto de Venta'+char(39)+', 150, 1)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idempresa as varchar) as name, i.empresa as title, 40 as width, 5 as orden
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(pdv.nombre)),'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join puntodeventa pdv on pdv.idpuntodeventa=d.idpuntodeventa
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(pdv.nombre)),'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join puntodeventa pdv on pdv.idpuntodeventa=d.idpuntodeventa
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(pdv.nombre)),'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join puntodeventa pdv on pdv.idpuntodeventa=d.idpuntodeventa

	'	

	EXEC sp_executesql @PivotTableSQL

	--select @PivotColumnHeaders
	--select @PivotWhereCondition
	--select @ColDef

	--declare @maxpag int
	--select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datosRes
	--select @maxpag

	----Configuracion de columnas
	--create table #columnasConfiguracion
	--(
	--	name varchar(50),
	--	title varchar(50),
	--	width int
	--)
	--insert #columnasConfiguracion (name, title, width) values ('idpuntodeventa','PDV',30),('idempresa','ID Empresa',40),('total', 'Total',20),('share', '%',20)
	--select name, title, width from #columnasConfiguracion

	----Datos
	--if(@NumeroDePagina>0)
	--	select pdv, empresa, total, share from #datosRes where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina) order by idpuntodeventa, idempresa, total	
	
	--if(@NumeroDePagina=0)
	--	select pdv, empresa, total, share from #datosRes where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina) order by idpuntodeventa, idempresa, total	
		
	--if(@NumeroDePagina<0)
	--	select pdv, empresa, total, share from #datosRes  order by idpuntodeventa, idempresa, total	


	--exec Mattel_POSReportShare_T9 4,'M,20160301,20160331'
end