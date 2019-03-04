IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonHistoricoVsActual_T28'))
   exec('CREATE PROCEDURE [dbo].[EpsonHistoricoVsActual_T28] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EpsonHistoricoVsActual_T28]
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

	--Cosas de Epson.
	IF ISNULL(@cFamilia,0) = 0 AND ISNULL(@cProductos,0) = 0 AND @idCliente = 187 BEGIN
		INSERT INTO #Familia
		SELECT idFamilia FROM Familia WHERE idFamilia IN (871,872)
		SET @cFamilia = @@ROWCOUNT
	END

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


	SELECT @fechaDesdeMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 2) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 2) + '0401' END
	SELECT @fechaHastaMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0430' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0430' END

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(id, mes, label) select 1, left(convert(varchar, @fechaDesdeMeses,112),6)+'01','PY'
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end


	SELECT @fechaDesdeMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
	SELECT @fechaHastaMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430' END

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(id, mes, label) select 3, left(convert(varchar, @fechaDesdeMeses,112),6)+'01','BP/FC '+ltrim(rtrim(str(@currentYear-1)))+'-'+ltrim(rtrim(str(@currentYear)))
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	SELECT @fechaDesdeMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0401' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) -1) + '0401' END
	SELECT @fechaHastaMeses = CASE WHEN DATEPART(MONTH,GETDATE()) >= 4 THEN CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430' ELSE CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430' END

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(id, mes, label) select 2, left(convert(varchar, @fechaDesdeMeses,112),6)+'01','ACTUAL / Consensus'
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #datos
	(
		id int,
		mes datetime,
		qty numeric(18,5)
	)

	-------------------------------------------------------------------- END (Temps)
	
	insert #datos(id, mes, qty)
	select	
			2,
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.SalesIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	INNER JOIN Cadena ca on f.idCadena = ca.idCadena
	where	f.fecha between convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())-1) + '0401') and convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430')

			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = Ca.IdTipoCadena))
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	insert #datos(id, mes, qty)
	select	
			1,
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.SalesIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	INNER JOIN Cadena ca on f.idCadena = ca.idCadena
	where	f.fecha between convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 2) + '0401') and convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()) - 1) + '0430')
			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = Ca.IdTipoCadena))
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	insert #datos(id, mes, qty)
	select	
			3,
			CONVERT(nvarchar(6), f.fecha, 112)+'01',
			sum(isnull(f.PlanOriginalSellIn,0))
	from forecasting f
	inner join cliente c on c.idcliente=f.idcliente
	inner join producto p on p.idproducto = f.idproducto
	INNER JOIN Cadena ca on f.idCadena = ca.idCadena
	where	f.fecha between convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())-1) + '0401') and convert(date,CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) + '0430')
			and exists(select 1 from #clientes where idCliente = f.idCliente)
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = f.IdCadena))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = f.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idfamilia = p.idFamilia))
			AND (ISNULL(@cTipoCadena,0) = 0 OR EXISTS(SELECT 1 FROM #TipoCadena WHERE idTipoCadena = Ca.IdTipoCadena))
			AND F.idCliente = @idCliente
			--Oculto Consumibles
			AND p.idMarca != 2905
	group by CONVERT(nvarchar(6), f.fecha, 112)+'01'
	order by CONVERT(nvarchar(6), f.fecha, 112)+'01'

	select	m.id,
			m.mes,
			DATENAME(MONTH,M.mes) Point,
			m.label SerieName,
			isnull(d.qty,0) value,
			CASE m.id WHEN 2 THEN '#44575D' WHEN 1 THEN '#FF0000' WHEN 3 THEN '#FF7B00' END Color,
			1 Line,
			isnull(d.qty,0) Text
	into #data
	from #meses m
	inner join #datos d on d.mes=m.mes
		and d.id=m.id
	where m.id != 3 and d.id!=3
	union
	select	m.id,
			m.mes,
			DATENAME(MONTH,M.mes) Point,
			m.label SerieName,
			isnull(d.qty,0) value,
			CASE m.id WHEN 2 THEN '#44575D' WHEN 1 THEN '#FF0000' WHEN 3 THEN '#FF7B00' END Color,
			1 Line,
			isnull(d.qty,0) Text
	from #meses m
	inner join #datos d on d.mes=m.mes
		and d.id=m.id
	where m.id = 3 and d.id=3
	
	delete from #data where Seriename in (SELECT DISTINCT SerieName FROM #DATA WHERE id = 1 group by SerieName having count(1) <= 1) and id = 1
	
	insert into #data
	select distinct m.id,m.mes,DATENAME(MONTH,M.mes) + CASE WHEN CONVERT(DATE,M.mes) = '20180401' OR CONVERT(DATE,M.mes) = '20190401' THEN 'X' ELSE '' END Point,m.label SerieName,0 value,CASE m.id WHEN 2 THEN '#44575D' WHEN 1 THEN '#FF0000' WHEN 3 THEN '#FF7B00' END Color, 1 Line,0 Text from #meses m
	left join #data d on m.mes = d.mes 
	where isnull(d.mes,'') = ''
	
	
	--SELECT * FROM #data
	

	SELECT 'Monthly Sales Performance | Sell-in' SerieName,'' Perc, 0 Stack, 0 ShowText, 1 PersistTooltip
	select  CASE WHEN  datediff(month,mes,getdate()) = 0 AND SerieName = 'FY '+RIGHT(CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(YEAR,-1,GETDATE())),112),2)+'/'+RIGHT(CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()),112),2) THEN ABS(datediff(month,DATEADD(YEAR,1,mes),getdate())) ELSE datediff(month,mes,getdate()) END Y ,Point,SerieName,value,Color,Line,Text, '' ShowPerc INTO #FDATA from #data 

	order by CASE WHEN SerieName = 'Consensus FC' THEN 1 ELSE 0 END DESC,
	id,
	CASE WHEN  datediff(month,mes,getdate()) = 0 AND SerieName = 'FY '+RIGHT(CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(YEAR,-1,GETDATE())),112),2)+'/'+RIGHT(CONVERT(VARCHAR,DATEPART(YEAR,GETDATE()),112),2) THEN ABS(datediff(month,DATEADD(YEAR,1,mes),getdate())) ELSE datediff(month,mes,getdate()) END DESC
	 

	-- Lo lamento:
	UPDATE #FDATA SET Point = Point + ' ' WHERE Y = 10 AND SerieName = 'PY'
	UPDATE #FDATA SET Point = Point + ' ' WHERE Y = -2 AND SerieName = 'ACTUAL / Consensus'
	UPDATE #FDATA SET Point = Point + ' ' WHERE Y = -2 AND SerieName = 'BP/FC 18-19'

	SELECT * FROM #FDATA	

	drop table #data
end
