IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_accountPlanPerformance_garbarino_T12'))
   exec('CREATE PROCEDURE [dbo].[Epson_accountPlanPerformance_garbarino_T12] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Epson_accountPlanPerformance_garbarino_T12]
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
/*select * from reportingObjeto order by 1 desc
	
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
		idMarca int
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
	create table #Pais
	(
		idPais int
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
	declare @cPais varchar(max)

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

	insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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
	
	insert #Pais (IdPais) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPais'),',') where isnull(clave,'')<>''
	set @cPais = @@ROWCOUNT
	

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

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses = @fechaDesde
	set @fechaHastaMeses = @fechaHasta

	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select left(convert(varchar, @fechaDesdeMeses,112),6)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		fechaCreacion datetime
	)


	-------------------------------------------------------------------- END (Temps)
	
	insert #reportesMesPdv (idReporte,fechaCreacion)
	select  r.idreporte,r.fechaCreacion
	from ReporteDemoEpson r
	where	@IdCliente=181 and idCadena = 4227
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			--and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = r.IdCadena))
			and (isnull(@cPais,0) = 0 or exists(select 1 from #Pais where idPais = r.idPais))
	
	create table #Resultados
	(
		id int identity(1,1), --FORECAST o ACTUAL
		Objetivo varchar(max),
		qty numeric(18,5),
		RealObjetivo numeric(18,5)
	)

	declare @TotalReal int

	select @TotalReal = sum(isnull(rde.valor,0))
	from #reportesMesPdv r
	inner join ReporteDemoEpson rde on rde.idReporte = r.idReporte
	
--	insert #Resultados (Objetivo, qty)
--	select 'Performance', SUM(isnull(rde.valor,0))
--	from #reportesMesPdv r
--	inner join ReporteDemoEpson rde on rde.idReporte = r.idReporte
	
	insert #Resultados (objetivo, qty,RealObjetivo)
	select 'Period', (@TotalReal * 100.0) / SUM(isnull(r.valor,0))*1.0,sum(r.valor) 
	from ReporteDemoEpson_objetivos r
	where convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = r.IdCadena))
	and (isnull(@cPais,0) = 0 or exists(select 1 from #Pais where idPais = r.idPais))
	and r.idCadena = 4227

	declare @TotalMes int

	select @TotalMes = sum(isnull(rde.valor,0))
	from #reportesMesPdv r
	inner join ReporteDemoEpson rde on rde.idReporte = r.idReporte
	where month(rde.fechaCreacion) = month(@fechaDesde)
	and year(rde.FechaCreacion) = year(@fechaDesde)

	insert #Resultados (objetivo, qty,RealObjetivo)
	select 'Month' +': '+ datename(month,@fechaDesde), (@TotalMes * 100.0) /SUM(isnull(r.valor,0))*1.0,sum(r.valor)
	from ReporteDemoEpson_objetivos r
	where month(r.FechaCreacion) = month(@fechaDesde)
	and year(r.FechaCreacion) = year(@fechaDesde)
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = r.IdCadena))
	and (isnull(@cPais,0) = 0 or exists(select 1 from #Pais where idPais = r.idPais))
	and r.idCadena = 4227

	declare @TotalQ int

	select @TotalQ = sum(isnull(rde.valor,0))
	from #reportesMesPdv r
	inner join ReporteDemoEpson rde on rde.idReporte = r.idReporte
	where datepart(Quarter,rde.fechaCreacion) = datepart(Quarter,@fechaDesde)
	and year(rde.FechaCreacion) = year(@fechaDesde)


	insert #Resultados (objetivo, qty,RealObjetivo)
	select 'Quarter: ' +'Q' + datename(quarter,@fechaDesde), (@TotalQ * 100.0)/SUM(isnull(r.valor,0))*1.0,sum(r.valor)
	from ReporteDemoEpson_objetivos r
	where datepart(QUARTER,r.FechaCreacion) = datepart(QUARTER,@fechaDesde)
	and year(r.FechaCreacion) = year(@fechaDesde)
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = r.IdCadena))
	and (isnull(@cPais,0) = 0 or exists(select 1 from #Pais where idPais = r.idPais))
	and r.idCadena = 4227


	declare @TotalYear int

	select @TotalYear = sum(isnull(rde.valor,0))
	from #reportesMesPdv r
	inner join ReporteDemoEpson rde on rde.idReporte = r.idReporte
	where year(rde.FechaCreacion) = year(@fechaDesde)


	insert #Resultados (objetivo, qty,RealObjetivo)
	select 'Year' + ': ' + cast(year(@fechaDesde) as varchar),  (@TotalYear * 100.0)/SUM(isnull(r.valor,0))*1.0,sum(r.valor)
	from ReporteDemoEpson_objetivos r
	where year(r.FechaCreacion) = year(@fechaDesde)
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = r.IdCadena))
	and (isnull(@cPais,0) = 0 or exists(select 1 from #Pais where idPais = r.idPais))
	and r.idCadena = 4227
	
	create table #datos
	(
		id int identity(1,1),
		Valor decimal(10,2),
		nombre varchar(max),
		RealObjetivo numeric(18,5)
	)

	insert #datos(valor,nombre,realObjetivo)
	select qty,objetivo,realObjetivo
	from  #Resultados
	order by id


	select d.id as id,  
	case when d.Valor < 60	then 'ea1e1e'
		when d.Valor >= 60 and d.valor <80	then 'ffff38'
		when d.Valor >= 80 and d.valor <=100	then '68A568'	
		when d.Valor > 100	then '5047f7'
	end
	as color, 
	null as logo,
	0 as nivel, 
	d.valor as valor,
	d.realObjetivo as varianza, 
	0 as parentId,
	d.nombre as nombre,
	169 as empresa
	from #datos d
	where valor is not null
	order by  d.id

end
go



/*
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20150401,20171231')

exec Epson_accountPlanPerformance_garbarino_T12 @IdCliente=61,@Filtros=@p2,@NumeroDePagina=0,@Lenguaje='es',@IdUsuarioConsulta=827,@TamañoPagina=8

declare @p3 dbo.FiltrosReporting
insert into @p3 values(N'fltFechaReporte',N'M,20150401,20171231')

exec [EpsonObjetivoVentas_T12] @IdCliente=61,@Filtros=@p3,@NumeroDePagina=0,@Lenguaje='es',@IdUsuarioConsulta=827,@TamañoPagina=8

*/



--[Epson_accountPlanPerformance_garbarino_T12] 181