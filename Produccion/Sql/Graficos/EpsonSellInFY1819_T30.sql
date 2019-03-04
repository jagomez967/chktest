IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonSellInFY1819_T30'))
   exec('CREATE PROCEDURE [dbo].[EpsonSellInFY1819_T30] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EpsonSellInFY1819_T30]
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
	declare @fechaDesdeAnterior varchar(30)
	declare @fechaHastaAnterior varchar(30)

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

	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)
	
	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)

	insert #Zonas(idZona)
	select z.idZona 
	from Zona z
	inner join
	(select nombre from Zona
	where idZona in (select idZona from #Zonas))pdx
	on pdx.nombre = z.nombre
	where z.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Zonas where idZona = z.idZona)

	insert #Localidades(idLocalidad)
	select l.idLocalidad
	from Localidad l
	inner join
	(select nombre from Localidad
	where idLocalidad in (select idLocalidad from #Localidades))pdx
	on pdx.nombre = l.nombre
	inner join Provincia p on p.idProvincia = l.idProvincia
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Localidades where idLocalidad = l.idLocalidad)

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
	
	declare @currentYear int = right(year(getdate()),2)
	

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses = @fechaDesde
	set @fechaHastaMeses = @fechaHasta

	create table #Meses
	(
		id int,
		label varchar(50),
		mes datetime
	)

	set @fechaDesdeMeses = convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401')
	set @fechaHastaMeses = convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) + 1) + '0331')

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(id, mes, label) select 1, left(convert(varchar, @fechaDesdeMeses,112),6)+'01','Proposal FY'+ltrim(rtrim(str(@currentYear)))+'/'+ltrim(rtrim(str(@currentYear+1)))
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	--Cosas de Epson.
	IF ISNULL(@cFamilia,0) = 0 AND ISNULL(@cProductos,0) = 0 AND @idCliente = 187 BEGIN
		INSERT INTO #Familia
		SELECT idFamilia FROM Familia WHERE idFamilia IN (871,872)
		SET @cFamilia = @@ROWCOUNT
	END

	create table #datos
	(
		id int,
		label varchar(50),
		mes datetime,
		qty numeric(18,5)
	)

	-------------------------------------------------------------------- END (Temps)
	--Sell IN
	insert #datos(id, label, mes, qty)
	select	
			1,
			'Sell-in',
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.SalesIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	where	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
			AND CONVERT(DATE,f.fecha) <= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END
			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	insert #datos(id, label, mes, qty)
	select 1, 'Sell-in', mes, 0 from #meses 

	--Sell IN RETAIL
	insert #datos(id, label, mes, qty)
	select	
			2,
			'Sell-in | RETAIL',
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.SalesIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	inner join cadena cad on cad.idcadena=f.idcadena
	inner join tipocadena tc on tc.idtipocadena = cad.idtipocadena
	where	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
			AND CONVERT(DATE,f.fecha) <= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END
			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			and tc.identificador='RET'
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	insert #datos(id, label, mes, qty)
	select 2, 'Sell-in | RETAIL', mes, 0 from #meses 

	
	--Sell IN DISTY
	insert #datos(id, label, mes, qty)
	select	
			3,
			'Sell-in | DISTY',
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.SalesIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	inner join cadena cad on cad.idcadena=f.idcadena
	inner join tipocadena tc on tc.idtipocadena = cad.idtipocadena
		where CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
			AND CONVERT(DATE,f.fecha) <= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END
			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			and tc.identificador='DIST'
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	insert #datos(id, label, mes, qty)
	select 3, 'Sell-in | DISTY', mes, 0 from #meses 
	

	IF @idCliente = 183 BEGIN

		--Sell IN IQU
		insert #datos(id, label, mes, qty)
		select	
				5,
				'Sell-in | IQU',
				CONVERT(nvarchar(6), f.fecha, 112)+'01',
				sum(isnull(f.SalesIn,0))
		from forecasting f
		inner join cliente c on c.idcliente=f.idcliente
		inner join producto p on p.idproducto = f.idproducto
		inner join cadena cad on cad.idcadena=f.idcadena
		inner join tipocadena tc on tc.idtipocadena = cad.idtipocadena
		where	CONVERT(DATE,f.fecha) >= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
				AND CONVERT(DATE,f.fecha) <= CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0331' END
				and exists(select 1 from #clientes where idCliente = f.idCliente)
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
				and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
				and tc.identificador='IQU'
				AND F.idCliente = @idCliente
				--Oculto Consumibles
				AND p.idMarca != 2905
		group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
		order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

		insert #datos(id, label, mes, qty)
		select 5, 'Sell-in | IQU', mes, 0 from #meses 
	END

	declare @totalsellin int
	select @totalsellin = sum(qty) from #datos where id=1
		
	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders =	
	  COALESCE(
		@PivotColumnHeaders + ',[' + convert(char(3), mes, 0) + ']','[' + convert(char(3), mes, 0) + ']'
	  )
	FROM (select distinct mes from #meses) x order by mes	

	DECLARE @PivotColumnHeadersValuesFormat VARCHAR(MAX)
	SELECT @PivotColumnHeadersValuesFormat = 
	  COALESCE(
		@PivotColumnHeadersValuesFormat + ',REPLACE(CONVERT(VARCHAR,CONVERT(MONEY,[' + lower(convert(char(3), mes, 0)) + ']),1), '+char(39)+'.00'+char(39)+','+char(39)+char(39)+')','REPLACE(CONVERT(VARCHAR,CONVERT(MONEY,[' + lower(convert(char(3), mes, 0)) + ']),1), '+char(39)+'.00'+char(39)+','+char(39)+char(39)+')'
	  )
	FROM (select distinct mes from #meses) x order by mes	

	DECLARE @RowTotalColumns VARCHAR(MAX)
	SELECT @RowTotalColumns = 
	  COALESCE(
		@RowTotalColumns + '+[' + lower(convert(char(3), mes, 0)) + ']','[' + lower(convert(char(3), mes, 0)) + ']'
	  )
	FROM (select distinct mes from #meses) x order by mes	

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='label varchar(50)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + lower(convert(char(3), mes, 0)) + '" int', lower(convert(char(3), mes, 0)) + '" int'
	  )
	FROM (select distinct mes from #meses) x order by mes	

	DECLARE @ColDefStr VARCHAR(MAX)
	set @ColDefStr='label varchar(50)'
	SELECT @ColDefStr = 
	  COALESCE(
		@ColDefStr + ',"' + lower(convert(char(3), mes, 0)) + '" varchar(50)', lower(convert(char(3), mes, 0)) + '" varchar(50)'
	  )
	FROM (select distinct mes from #meses) x order by mes	
	

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+',total int,channel numeric(10,2)
	)

	CREATE TABLE #DatosPivotFinal
	(
		'+@ColDefStr+',total varchar(50),channel varchar(50)
	)
	
	insert #DatosPivot(label,'+@PivotColumnHeaders+',total,channel)
	SELECT [label],' + @PivotColumnHeaders + ', '+@RowTotalColumns+ ' as total, 100.0*('+@RowTotalColumns+ ')/isnull('+ltrim(rtrim(str(@totalsellin)))+',1) as channel
	  FROM (
		select label as [label],convert(char(3), mes, 0)as [mes], qty as [qty] FROM #datos
	  ) AS PivotData
	  PIVOT (
		sum(qty)
		FOR [mes] IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable
	


	insert #DatosPivotFinal(label,'+@PivotColumnHeaders+',total,channel)
	select label as Items, '+@PivotColumnHeadersValuesFormat+', case when total>100 then REPLACE(CONVERT(VARCHAR,CONVERT(MONEY,total),1), '+char(39)+'.00'+char(39)+','+char(39)+char(39)+') else '+char(39)+char(39)+' end as [TTL FY], case when channel<100 and channel>0 then REPLACE(CONVERT(VARCHAR,CONVERT(MONEY,channel),1), '+char(39)+'.00'+char(39)+','+char(39)+char(39)+') + '+char(39)+'%'+char(39)+' else '+char(39)+char(39)+' end as Channel from #DatosPivot
	
	declare @maxpag int
		if('+cast(@TamañoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamañoPagina as varchar)+') from #DatosPivotFinal

	select label Items,'+@PivotColumnHeaders+',total [TTL-FY] from #DatosPivotFinal'

	EXEC sp_executesql @PivotTableSQL
end