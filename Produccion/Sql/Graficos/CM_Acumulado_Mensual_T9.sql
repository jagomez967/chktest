IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.CM_Acumulado_Mensual_T9'))
   exec('CREATE PROCEDURE [dbo].[CM_Acumulado_Mensual_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].CM_Acumulado_Mensual_T9
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
	create table #Categoria
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
	declare @cCategoria varchar(max)
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
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	
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
		IdPuntoDeVenta int,
		usuario int,
		idReporte int,
		Fecha varchar(8)
	)

	create table #datos
	(
		id int identity(1,1),
		idreporte int,
		pdv int,
		usuario int,
		valor nvarchar (max),
		fecha varchar(20)
	)

	create table #PuntajePdvs
	(
		idReporte int,
		pdv int,
		puntaje int,
		acumulado numeric(18,2),
		fecha varchar(20)
	)

	
	
	
	

	-------------------------------------------------------------------- END (Temps)


	insert #reportesMesPdv (IdPuntoDeVenta, Usuario, idReporte, Fecha)
	select r.IdPuntoDeVenta, r.idUsuario, r.IdReporte, left(convert(varchar,r.fechacreacion,112),6)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	
	

	insert #datos (idreporte, pdv, usuario, valor,fecha)
	select	r.idReporte,
			r.idPuntoDeVenta,
			r.Usuario,
			case when isnull(mdr.Valor2,0) = 1 then 0
			when isnull(mdr.Valor1,0) = 1 and mdr.idItem in (8512,8511,8515) then 3
			when isnull(mdr.Valor1,0) = 1 and mdr.idItem in (8510,8513) then 6
			when isnull(mdr.Valor1,0) = 1 and mdr.idItem = 8514 then 9
			when isnull(mdr.Valor3,0) = 1 and mdr.idItem in (8512,8511,8515) then 1
			when isnull(mdr.Valor3,0) = 1 and mdr.idItem in (8510,8513) then 2
			when isnull(mdr.Valor3,0) = 1 and mdr.idItem = 8514 then 3 end,			
			left(convert(varchar,r.fecha,112),6)
	from #reportesMesPdv r
	inner join MD_ReporteModuloItem mdr on mdr.idReporte = r.idReporte
	inner join MD_Item mi on mi.idItem = mdr.idItem
	inner join MD_ModuloMarcaItem mmi on mmi.idItem = mi.idItem
	where mi.idModulo = 2084


	insert #PuntajePdvs (idReporte, pdv, puntaje, acumulado,fecha)
	select idReporte, pdv, sum(convert(int, valor)), CEILING(sum(convert(int, valor)*100)/30),fecha
	from #datos
    group by idReporte, pdv, fecha
	order by fecha


	insert #PuntajePdvs (idReporte, pdv, puntaje, acumulado,fecha)
	select idReporte, pdv, sum(convert(int, valor)), CEILING(sum(convert(int, valor)*100)/90),
	left(fecha,4) + 'Q' + datename(QUARTER,convert(datetime,fecha +'01'))
	from #datos
    group by idReporte, pdv, left(fecha,4) + 'Q' + datename(QUARTER,convert(datetime,fecha +'01'))
	order by left(fecha,4) +'Q' + datename(QUARTER,convert(datetime,fecha +'01'))


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	DECLARE @Pivot_Acumulado VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		
		@PivotColumnHeaders + ',[' + cast(fecha as varchar(8)) + ']','[' + cast(fecha as varchar(8)) + ']'
	  )
	FROM (select distinct fecha from #PuntajePdvs) x 
	order by fecha
	
	SELECT @Pivot_Acumulado = 
	  COALESCE(
		@Pivot_Acumulado + ',[' + cast(fecha as varchar(8)) + 'ACUM]','[' + cast(fecha as varchar(8)) + 'ACUM]'
	  )
	FROM (select distinct fecha from #PuntajePdvs) x 
	order by fecha
	
	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='pdv varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',[' + cast(fecha as varchar(8)) + ']  varchar(max)','[' + cast(fecha as varchar(8)) + '] varchar(max)'
	  )
	FROM (select distinct fecha from #PuntajePdvs) x
	order by fecha

	DECLARE @ColDef_2 VARCHAR(MAX)
	set @ColDef_2 ='pdv_2 varchar(max)'
	SELECT @ColDef_2 = 
	  COALESCE(
		@ColDef_2 + ',[' + cast(fecha as varchar(8)) + 'ACUM]  varchar(max)','[' + cast(fecha as varchar(8)) + 'ACUM] varchar(max)'
	  )
	FROM (select distinct fecha  from #PuntajePdvs) y
	order by fecha


	DECLARE @PivotTableSQL_Pre NVARCHAR(4000)
	SET @PivotTableSQL_Pre = N'
	
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+',
		'+@ColDef_2+'		
	)

      insert #DatosPivot([pdv],'+@PivotColumnHeaders+' ,[pdv_2],'+@Pivot_Acumulado+')
	  SELECT * FROM
	  (
			SELECT [pdv],'+@PivotColumnHeaders+'
			FROM (
					Select pdv,puntaje,fecha
					from #PuntajePdvs
			) AS PivotData
			PIVOT (
				sum(puntaje)
				FOR fecha IN ('+ @PivotColumnHeaders + ')
			)AS PivotTable 
	 )AS Puntajes	
	inner join 
	(		SELECT [pdv],'+@PivotColumnHeaders+'
			FROM( 
					Select pdv,acumulado,Fecha 
					from #PuntajePdvs 
				) AS PivotData
				PIVOT (
					 sum(acumulado) 
					FOR Fecha IN ('+ @PivotColumnHeaders + ')
				)AS PivotTable
	)AS Acumulados		
   on Acumulados.pdv= Puntajes.pdv
  
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+',
	    '+@ColDef_2+'
	) 

	insert #DatosPivotFinal ([pdv],'+@PivotColumnHeaders+','+@Pivot_Acumulado+')
	select [pdv],'+@PivotColumnHeaders+','+@Pivot_Acumulado+'
	from #DatosPivot 
	'

	DECLARE @PivotTableSQL NVARCHAR(4000)
	SET @PivotTableSQL = N'

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

    insert #columnasDef (name, title, width, orden) values ('+char(39)+'Nombre'+char(39)+','+char(39)+'Punto de venta'+char(39)+', 80, 0)
	
	insert #columnasDef (name, title, width, orden)
	select i.fecha + '''' as name, ''Puntaje '' + datename(MONTH,convert(datetime,i.fecha + ''01'')) as title, 40 as width, ROW_NUMBER() OVER (Order by i.fecha) * 10 
	from (select fecha from #PuntajePdvs group by fecha) i
	WHERE ISNUMERIC(I.FECHA) = 1

	insert #columnasDef (name, title, width, orden)
	select i.fecha + ''ACUM'' as name, ''Acumulado '' + datename(MONTH,convert(datetime,i.fecha + ''01'')) as title, 40 as width,ROW_NUMBER() OVER (Order by i.fecha) * 10 + 1
	from (select fecha from #PuntajePdvs group by fecha) i
	WHERE ISNUMERIC(I.FECHA) = 1
		
	insert #columnasDef (name, title, width, orden)
	select i.fecha + ''ACUM'' as name, ''Acumulado '' + i.fecha as title, 40 as width,ROW_NUMBER() OVER (Order by i.fecha) * 30 + 1
	from (select fecha from #PuntajePdvs group by fecha) i
	WHERE ISNUMERIC(I.FECHA) = 0
	UNION
	select i.fecha + '''' as name, ''Puntaje '' + i.fecha as title, 40 as width,ROW_NUMBER() OVER (Order by i.fecha) * 30 + 2
	from (select fecha from #PuntajePdvs group by fecha) i
	WHERE ISNUMERIC(I.FECHA) = 0

	select name, title, width,orden from #columnasDef order by orden, name
	
	if('+cast(@NumeroDePagina as varchar)+'>0)
			
			select pdv.Nombre, '+@PivotColumnHeaders+','+ @Pivot_Acumulado+' 
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv			
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select pdv.Nombre, '+@PivotColumnHeaders+','+ @Pivot_Acumulado+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select pdv.Nombre, '+@PivotColumnHeaders+','+ @Pivot_Acumulado+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv		
'
	EXEC (@PivotTableSQL_PRE +@PivotTableSQL)
	
end

GO