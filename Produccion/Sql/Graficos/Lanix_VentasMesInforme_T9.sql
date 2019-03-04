IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_VentasMesInforme_T9'))
   exec('CREATE PROCEDURE [dbo].[Lanix_VentasMesInforme_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Lanix_VentasMesInforme_T9]
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
		create table #TipoEntrega
	(
		idTipoEntrega int
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
	declare @cClientes varchar(max)
	declare @cTipoEntrega varchar(max)

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

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT

	
	insert #TipoEntrega (IdTipoEntrega) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoEntrega'),',') where isnull(clave,'')<>''
	set @cTipoEntrega = @@ROWCOUNT
	
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where fc.familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values (@idCliente) 
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

	insert #Productos(idProducto)
	select p.idProducto 
	from Producto p
	inner join
	(select nombre from Producto 
	where idProducto in (select idProducto from #productos))pdx
	on pdx.nombre = p.nombre
	where p.idMarca in(select idMarca from marca where idEmpresa in(select idEmpresa from cliente where idCliente in(select idCliente from #clientes)))
	and not exists (select 1 from #Productos where idProducto = p.idProducto)
	
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
		idCliente int,
		idReporte int,
		Fecha varchar(7),
		semana varchar(9),
	)

	create table #datos
	(
		id int identity(1,1),
		idreporte int,
		pdv int,
		usuario int,
		valor varchar (max),
		iditem int,
		preg varchar(max),
		orden int
	)

	-------------------------------------------------------------------- END (Temps)
	create table #datosStock
	(
		idPuntodeventa int,
		NombrePDV varchar(max),
		fecha varchar(7),
		semana varchar(9),
		qty numeric(18,0),
		idProducto int,
		idMarca int
	)



	create table #datosRes
	(
		idPuntoDeVenta int,
		NombrePDV varchar(max),
		Fecha varchar(7),
		semana varchar(9),
		qty numeric(18,0),
		idProducto int,
		idMarca int
	)

	insert #datosRes (idPuntoDeVenta,NombrePDV, Fecha, semana, qty,idProducto,idMarca)
	select
	isnull(max(pdv.idPuntodeventa),DENSE_RANK() OVER(ORDER BY lx.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, lx.[CAV]) as NombrePDV,
	'W'+convert(varchar,datepart(wk,lx.[FECHA DE VENTA])),
	'col'+convert(varchar,datepart(wk,lx.[FECHA DE VENTA])),
	count(lx.[SERIAL PROVEEDOR]) as cantidad,
	p.idProducto,
	p.idMarca
	From informes_lanix lx
	left  join puntodeventa pdv 
		on pdv.nombre = lx.[CAV] collate database_default
		and pdv.idCliente = 142 --HARCODE ESTE CLIENTE PARA TOMAR LOS PUNTOS DE VENTA DE ALGUN CLIENTE DE LA FAMILIA LANIX.. ESTE ES: LANIX FOTOS
	left join producto p
		on p.nombre = lx.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = lx.[TIPO DE ENTREGA] collate database_default
	where [PROVEEDOR] = 'LANIX' 
	and lx.[ESTADO] = 'SALIDA DE MERCANCIA'
	and (lx.[TIPO DE ENTREGA] = 'DOMICILIO' or lx.[TIPO DE ENTREGA] = 'PRESENCIAL' or lx.[TIPO DE ENTREGA] = 'CAV')
	and convert(date,lx.[FECHA DE VENTA]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by convert(varchar,datepart(wk,lx.[FECHA DE VENTA])),pdv.nombre,lx.[CAV],p.idProducto,p.idMarca



	insert #datosStock(idPuntodeventa,nombrePDV,fecha,semana,qty,idProducto,idMarca)
	select
	isnull(max(pdv.idPuntodeventa),DENSE_RANK() OVER(ORDER BY Il.[CAV] ASC)) as idPuntodeventa,
	isnull(pdv.Nombre collate database_default, Il.[CAV]) as NombrePDV,
	x.fecha,
	x.semana,
	count(Il.[SERIAL PROVEEDOR]) as cantidad,
	p.idProducto,
	p.idMarca
	From informes_lanix Il
	left  join puntodeventa pdv 
		on pdv.nombre = Il.[CAV] collate database_default
		and pdv.idCliente = 142 --HARCODE ESTE CLIENTE PARA TOMAR LOS PUNTOS DE VENTA DE ALGUN CLIENTE DE LA FAMILIA LANIX.. ESTE ES: LANIX FOTOS
	left join producto p
		on p.nombre = Il.[REFERENCIA] collate database_default
		and p.idMarca = 2070 ---HARDCODE!!!!!
	left join tipoDeEntrega te
		on te.nombre = Il.[TIPO DE ENTREGA] collate database_default
	cross join (select fecha,semana from #datosRes group by fecha,semana) x
	where Il.[ESTADO] = 'STOCK DISPONIBLE CAV'
	--and [PROVEEDOR] = 'LANIX' 
	--and convert(date,Il.[FECHA DE RECEPCION]) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	and (isnull(@cTipoEntrega,0) = 0 or exists(select 1 from #tipoEntrega where idTipoEntrega = te.id))
	group by x.fecha,x.semana,pdv.nombre,Il.[CAV],p.idProducto,p.idMarca



	create table #NombresPDV
	(	idPuntodeventa int,
		nombre varchar(max)
	)

	insert #NombresPDV(idPuntodeventa,nombre)
	select distinct idPuntodeventa, nombrePDV from #datosRes

	create table #totalColumn
	(
		idPuntoDeVenta int,
		promedio numeric(18,2)
	)

	insert #totalColumn (idPuntoDeVenta, promedio)
	select d.idPuntoDeVenta, avg(isnull(d.qty,0)) from #datosRes d
	group by d.idPuntoDeVenta


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(semana as varchar(500)) + ']','[' + cast(semana as varchar(500)) + ']'
	  )
	FROM (select distinct semana from #datosRes) x order by semana
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(semana as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(semana as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct semana from #datosRes) x order by semana

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idPuntoDeVenta varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(semana as varchar(500)) + '" varchar(max)',cast(semana as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct semana from #datosRes) x order by semana


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idPuntoDeVenta],'+@PivotColumnHeaders+')
	SELECT [idPuntoDeVenta],'+@PivotColumnHeaders+'
	  FROM (
		Select idPuntoDeVenta, semana, qty from #DatosRes
	  ) AS PivotData
	  PIVOT (
		sum(qty)
		FOR semana IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable

		 
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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Nombre'+char(39)+','+char(39)+'PuntoDeVenta'+char(39)+', 80, 0)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'promedio'+char(39)+','+char(39)+'Promedio'+char(39)+', 80, 6)
	

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.semana as varchar) as name, i.Fecha as title, 40 as width, 1
	from #datosRes i

	select name, title, width from #columnasDef order by orden, name
	

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(pdv.Nombre)) as Nombre, '+@PivotColumnHeaders+', t.promedio
			from #DatosPivotFinal d
			inner join #NombresPDV pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join #totalColumn t on t.idPuntoDeVenta = d.idPuntoDeVenta
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(pdv.Nombre)) as Nombre, '+@PivotColumnHeaders+', t.promedio
			from #DatosPivotFinal d
			inner join #NombresPDV pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join #totalColumn t on t.idPuntoDeVenta = d.idPuntoDeVenta
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(pdv.Nombre)) as Nombre, '+@PivotColumnHeaders+', t.promedio
			from #DatosPivotFinal d
			inner join #NombresPDV pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join #totalColumn t on t.idPuntoDeVenta = d.idPuntoDeVenta

	'	
	EXEC sp_executesql @PivotTableSQL
	--print @PivotTableSQL

end


go



--Lanix_VentasMesInforme_T9 147