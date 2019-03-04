IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EPSON_PSISimulation_T19'))
   exec('CREATE PROCEDURE [dbo].[EPSON_PSISimulation_T19] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EPSON_PSISimulation_T19] 	
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
	create table #Categoria
	(
		idCategoria int
	)

	CREATE TABLE #TipoCadena
	(
		idTipoCadena INT
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
	declare @cCategoria varchar(max)
	DECLARE @cTipoCadena			INT

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
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT

	INSERT INTO #TipoCadena (idTipoCadena) SELECT clave AS idTipoCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoCadena'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoCadena = @@ROWCOUNT	
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	

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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	--Cosas de Epson.
	IF ISNULL(@cFamilia,0) = 0 AND ISNULL(@cProductos,0) = 0 AND @idCliente = 187 BEGIN
		INSERT INTO #Familia
		SELECT idFamilia FROM Familia WHERE idFamilia IN (871,872)
		SET @cFamilia = @@ROWCOUNT
	END

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end
	-------------------------------------------------------------------- TEMPS (Filtros)

	create table #datos
	(
		id int identity(1,1),
		mes datetime,
		salesin int,
		salesout int,
		stockinicial int,
		channelinv int,
		doci int
	)

	SELECT distinct 
	cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date) as Fecha
	INTO #months
	FROM Forecasting f WHERE
	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
	AND CONVERT(DATE,f.fecha) <= DATEADD(MONTH,1,CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END)

	insert #datos (mes, salesin, salesout, stockinicial,channelinv,doci)
	SELECT cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date) as Fecha
		,sum(isnull(f.[SalesIn],0)) as SalesIn
		,sum(isnull(f.[SalesOut],0)) as SalesOut
		,sum(isnull(f.StockInicial,0)) as StockInicial
		,sum(isnull(f.ChannelInv,0)) as ChannelInv
		--,ISNULL(CONVERT(INT,(CONVERT(NUMERIC(18,2),sum(isnull(f.ChannelInv,0))) / NULLIF(CONVERT(NUMERIC(18,2),sum(isnull(f.[SalesOut],0))),0))  * 30.416),0) as DOCI
		,NULL as DOCI
	FROM [dbo].[Forecasting] f
	inner join Cadena c on c.idcadena = f.idcadena
	inner join TipoCadena tc on tc.IdTipoCadena = c.IdTipoCadena
	inner join Producto p on p.idproducto = f.idproducto
	inner join Familia fam on fam.idfamilia=p.idfamilia
	where	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
			AND CONVERT(DATE,f.fecha) <= DATEADD(MONTH,2,CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = TC.IdTipoCadena))
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND P.idMarca != 2905
	group by cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date)
	order by cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date)

	insert #datos (mes, salesin, salesout, stockinicial,channelinv,doci)
	select distinct fecha,0,0,0,0,0 from #months m left join #datos d on m.fecha = d.mes where isnull(d.mes,'') = ''

	UPDATE D SET DOCI = ISNULL(CONVERT(NUMERIC(18,2),D.ChannelInv) / 
	((
	(SELECT SalesOut FROM #Datos WHERE mes = D.mes)
	+
	NULLIF((SELECT SalesOut FROM #Datos WHERE mes = dateadd(month,1,D.mes)),0)
	)
	/2) * 30.416,0)
	FROM #Datos D



	--DELETE FROM #Datos 

	create table #ejesConfiguracion
	(
		[title] varchar(50),
		[type] varchar(50),
		[unit] varchar(50),
		[yaxis] int,
		[opposite] int,
		[showLabel] int,
		[color] varchar(7)
	)

	insert #ejesConfiguracion values ('Inventory', 'column', '', 0, 0, 0,'#B3BFB3')
	insert #ejesConfiguracion values ('Sell In', 'spline', '', 0, 0, 0,'#44575D')
	insert #ejesConfiguracion values ('Sell Out', 'spline', '', 0, 0, 0,'#FFFF00')
	insert #ejesConfiguracion values ('Doci', 'spline', '', 3, 1, 0,'#F29F41')
	insert #ejesConfiguracion values ('Sell Out PY', 'spline', '', 0, 0, 0,'#8E598E')

	select [title], [type], [unit], isnull([yaxis],0) as yaxis, [opposite] as opposite, [showLabel] as showLabel, [color] from #ejesConfiguracion

	select top 13 right(CONVERT(VARCHAR(11),convert(datetime,mes),6),6) as mes, channelinv from #datos 
	select top 13 right(CONVERT(VARCHAR(11),convert(datetime,mes),6),6) as mes, salesin from #datos 
	select top 13 right(CONVERT(VARCHAR(11),convert(datetime,mes),6),6) as mes, salesout from #datos
	select top 13 right(CONVERT(VARCHAR(11),convert(datetime,mes),6),6) as mes, doci from #datos 
	

	SELECT cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date) as Fecha
		,sum(isnull(f.[SalesOut],0)) as SalesOutPY
	FROM [dbo].[Forecasting] f
	inner join Cadena c on c.idcadena = f.idcadena
	inner join TipoCadena tc on tc.IdTipoCadena = c.IdTipoCadena
	inner join Producto p on p.idproducto = f.idproducto
	inner join Familia fam on fam.idfamilia=p.idfamilia
	where	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 2) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 2) + '0401' END
			AND CONVERT(DATE,f.fecha) <= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0331' END
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = TC.IdTipoCadena))
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND P.idMarca != 2905
	group by cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date)
	order by cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date)
end
go
