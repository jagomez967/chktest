use checkpos_unificada_final_2
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.BancoChile_PerformanceElementosCriticos_T9'))
   exec('CREATE PROCEDURE [dbo].[BancoChile_PerformanceElementosCriticos_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[BancoChile_PerformanceElementosCriticos_T9]
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

	create table #marcas
	(
		idMarca int
	)

	create table #bancos
	(
		idBanco int
	)


	create table #Sucursal
	(
		idSucursal int
	)

	create table #TipoSucursal
	(
		idTipoSucursal int
	)

	create table #JefeGestion
	(
		idJefeGestion int
	)

	create table #JefeZonal
	(
		idJefeZonal int
	)

	create table #usuarios
	(
		idUsuario int
	)

	declare @cZonas varchar(max)
	declare @cMarcas varchar(max)
	declare @cBancos varchar(max)
	declare @cTipoSucursal varchar(max)
	declare @cJefeGestion varchar(max)
	declare @cJefeZonal varchar(max)
	declare @cSucursal varchar(max)
	declare @cUsuarios varchar(max)
	
	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		

	insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''
	set @cZonas = @@ROWCOUNT

	insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	set @cMarcas = @@ROWCOUNT
	
	insert #bancos (idBanco) select clave as idBanco from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltBanco'),',') where isnull(clave,'')<>''
	set @cBancos = @@ROWCOUNT
	
	insert #TipoSucursal (idTipoSucursal) select clave as idTipoSucursal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoSucursal'),',') where isnull(clave,'')<>''
	set @cTipoSucursal = @@ROWCOUNT

	insert #JefeGestion (idJefeGestion) select clave as idJefeGestion from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltJefeGestion'),',') where isnull(clave,'')<>''
	set @cJefeGestion = @@ROWCOUNT

	insert #JefeZonal (idJefeZonal) select clave as idJefeZonal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltJefeZonal'),',') where isnull(clave,'')<>''
	set @cJefeZonal = @@ROWCOUNT

	insert #Sucursal (idSucursal) select clave as idSucursal from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSucursal'),',') where isnull(clave,'')<>''
	set @cSucursal = @@ROWCOUNT

	insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	set @cUsuarios = @@ROWCOUNT

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

	create table #tempReporte
	(
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------
	/*
	update  #Sucursal
	set idsucursal = p2.idPuntoDeVenta
	--select s.idSucursal, p1.idPuntodeVenta, p2.idPuntoDeVenta
	from #Sucursal s
	inner join puntodeVenta p1 on p1.idPuntoDeVenta = s.idSucursal
	left join puntodeventa p2 on p1.codigo = p2.codigo
	where p1.idCliente = @idCliente
	and p2.idCliente = @idCliente - 1
	
	update #zonas
	set idZona = z2.idZona
	from #zonas z
	inner join zona z1 on z1.idZona = z.idZona
	inner join zona z2 on z2.nombre = z1.nombre
	where z1.idCliente = @idCliente
	and z2.idCliente = @idCliente - 1

	update #bancos
	set idBanco = c2.idCadena
	from #bancos b
	inner join cadena c1 
		on c1.idCadena = b.idBanco
	inner join cadena c2
		on c2.nombre = c1.nombre
	where c1.idNegocio = 81
	and c2.idNegocio = 80

	update #tipoSucursal
	set idTipoSucursal = t2.idTipo
	from #tipoSucursal t
	inner join tipo t1
		on t1.idTipo = t.idTipoSucursal
	inner join tipo t2 on t2.nombre = t1.nombre
	where t1.idNegocio= 81
	and c2.idnegocio = 80
	
	*/

	insert #tempReporte (IdPuntoDeVenta, mes, idReporte)
	select	r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and p.idCliente = @idCliente--1
	--		and r.idEmpresa = 468 --ELEMENTOS CRITICOS
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cBancos,0) = 0 or exists(select 1 from #Bancos where idBanco = p.IdCadena))
			and (isnull(@cTipoSucursal,0) = 0 or exists(select 1 from #tipoSucursal where idTipoSucursal = p.idtipo))
			and (isnull(@cSucursal,0) = 0 or exists(select 1 from #Sucursal where idSucursal = p.IdPuntoDeVenta))
			and (isnull(@cJefeGestion,0) = 0 or exists(select 1 from #JefeGestion where idJefeGestion in (select isnull(id,0) from extData_bancochile_filtroBI where idPuntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cJefeZonal,0) = 0 or exists(select 1 from #JefeZonal where idJefeZonal in (select isnull(idZonal,0) from extData_bancochile_filtroBI where idPUntoDeVenta = p.idPuntoDeVenta)))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
	group by r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	

	create table #datosFinal
	(
		id int identity(1,1),
		idPuntoDeVenta int,
		PuntoDeVenta varchar(200),
		Tipo char(4),--BIEN/MAL
		FechaCreacion char(10),
		idProducto int,
		NombreProducto varchar(100),
		Cantidad int
	)
	

	insert #datosFinal (idPuntoDeVenta,idProducto,PuntoDeVenta,Tipo,FechaCreacion,NombreProducto,Cantidad)
	select p.idPuntoDeVenta,prd.idProducto,p.nombre,'BIEN',convert(char(10),r.FechaCreacion,103), prd.Nombre, 
	rp.cantidad --Cantidad = BIEN
	from #tempReporte t 
	inner join reporteProducto rp 
		on rp.idReporte = t.idReporte
	inner join reporte r 
		on r.idReporte = t.idReporte
	inner join puntodeventa p	
		on p.idPuntoDeVenta = t.idPuntoDeVenta
	inner join producto prd
		on prd.idProducto = rp.idProducto
	UNION
	select p.idPuntoDeVenta,prd.idProducto,p.nombre,'MAL',convert(char(10),r.FechaCreacion,103), prd.Nombre, 
	rp.cantidad2 --Cantidad = BIEN
	from #tempReporte t 
	inner join reporteProducto rp 
		on rp.idReporte = t.idReporte
	inner join reporte r 
		on r.idReporte = t.idReporte
	inner join puntodeventa p	
		on p.idPuntoDeVenta = t.idPuntoDeVenta
	inner join producto prd
		on prd.idProducto = rp.idProducto
	order by p.idPuntoDeVenta,prd.idProducto,prd.nombre,convert(char(10),r.FechaCreacion,103)

	
	--Cantidad2 = MAL
	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(100),
		title varchar(100),
		width int,
		esclave bit,
		mostrar bit,
		esagrupador bit
	)
	
	if(@lenguaje = 'es')
	Begin
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('PuntoDeVenta','Punto De Venta',10, 0, 0, 1)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('FechaCreacion','Fecha USO',10, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Tipo',' ',10, 0, 1, 0)
		--insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('NombreProducto','Item',10, 0, 1, 0)		
	End

	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('PuntoDeVenta','Point of sale',10, 0, 0, 1)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('FechaCreacion','Date',10, 0, 1, 0)
		insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('Tipo',' ',10, 0, 1, 0)
		--insert #columnasConfiguracion (name, title, width, esclave, mostrar, esagrupador) values ('NombreProducto','Item',10, 0, 1, 0)
	end
	insert #columnasConfiguracion (name,title, width,esclave,mostrar,esagrupador)
	select  'a' + cast(idProducto as varchar) name 
		   ,cast(idProducto as varchar) + ' - ' + NombreProducto as title
			,10 as width
			,0
			,1
			,0
    from (select distinct idProducto,NombreProducto from #datosFinal) x
	order by x.idProducto

	select name,title,width, esclave, mostrar, esagrupador from #columnasConfiguracion
	
	
	--Datos

	declare @PivotWhere varchar(max)
	if(@NumeroDePagina>0)
	select @PivotWhere = ' where id between (('+convert(varchar(100),@NumeroDePagina)+' - 1) * '+convert(varchar(MAX),@TamañoPagina)+' + 1) and ('+convert(varchar(100),@NumeroDePagina)+' * '+convert(varchar(MAX),@TamañoPagina)+')'
	
	if(@NumeroDePagina=0)
	select @PivotWhere = ' where id between (('+convert(varchar(100),@maxpag)+' - 1) * '+convert(varchar(MAX),@TamañoPagina)+' + 1) and ('+convert(varchar(100),@maxpag)+' * '+convert(varchar(MAX),@TamañoPagina)+')'
	
	if(@NumeroDePagina<0)
    select @PivotWhere = ' '


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[a' + cast(idProducto as varchar) + ']',
		'[a' + cast(idProducto as varchar) + ']'
	  )
	FROM (select distinct idProducto,nombreProducto from #DatosFinal) x
	order by x.idProducto

	DECLARE @ColDef VARCHAR(MAX)
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',[a' + cast(idProducto as varchar) + '] varchar(max)',
		'[a' + cast(idProducto as varchar)+ '] varchar(max)'
	  )
	FROM (select distinct idProducto, nombreProducto from #DatosFinal) x order by x.idProducto asc

--select * from #datosFinal
	--idPuntoDeVenta,idProducto,PuntoDeVenta,Tipo,FechaCreacion,NombreProducto,Cantidad
	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	  CREATE TABLE #tablaPivot 
	  ( id int identity(1,1),
	    PuntoDeVenta varchar(max),
		FechaCreacion varchar(max),
		Tipo char(4),
		'+ @ColDef +'
	  )

	  insert #tablaPivot (PuntoDeVenta,FechaCreacion,Tipo,'+@PivotColumnHeaders+')
	  SELECT [PuntoDeVenta],FechaCreacion,Tipo,'+@PivotColumnHeaders+'
	  FROM (
		SELECT
		  PuntoDeventa,
		  Tipo,
		  FechaCreacion,
		  NombreProducto,
		  cast(Cantidad as int) as cantidad
		FROM #DatosFinal 
		) AS PivotData
	  PIVOT (
		SUM(cantidad)
		FOR NombreProducto IN (
		  ' + @PivotColumnHeaders + ')
		) AS PivotTable
	order by PuntoDeVenta,FechaCreacion,tipo


	select [PuntoDeVenta],FechaCreacion,Tipo,'+@PivotColumnHeaders+'
	from #tablaPivot
	 '+ @PivotWhere 

	EXECUTE(@PivotTableSQL)
--	select @pivotTableSql


end
go