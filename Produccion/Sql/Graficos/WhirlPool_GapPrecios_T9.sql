IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.WhirlPool_GapPrecios_T9'))
   exec('CREATE PROCEDURE [dbo].[WhirlPool_GapPrecios_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[WhirlPool_GapPrecios_T9]
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
	declare @cFamilia varchar(max)
	declare @cTipoPDV varchar(max)
	declare @cClientes varchar(max)
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

	insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''
	set @cFamilia = @@ROWCOUNT
	
	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT

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

	---Data
	create table #data
	(
		idProducto int,
		producto varchar(500), --NOMBRE DE PRODUCTO<
		dashStyle int,
		color varchar(10),
		fecha int,
		valorFecha varchar(10),
		valor decimal(18,2),
		linkedTo varchar(50), --LinkedToID
		marca varchar(50),
		idCadena int

	)
	
		
	insert #data(idPRoducto,producto,dashStyle,color,fecha,valorFecha,valor,linkedTo,marca,idCadena)			
	select p.idProducto,p.nombre,/*CONTADOR*/1,/*m.MarcaColor*/'',
	year(r.FechaCreacion) * 10000
	+
	datepart(month,r.FechaCreacion) * 100
	+
	datepart(day,r.FechaCreacion) * 1

	,convert(varchar,r.fechacreacion,103),rp.precio2,  --PROMEDIO
	(select max(idProducto) from ProductoCompetencia
	where idProductoCompetencia = p.idProducto
	and reporte = 1 ), -- y bue
	m2.nombre --Nombre de serie
	,pdv.idCadena
	From reporte r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join producto p on p.idProducto = rp.idProducto
	inner join Marca M2 ON P.idMarca = M2.idMarca
	inner join cliente c on c.idEmpresa = r.idEmpresa
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idCliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))
	--and rp.precio2 <> 0	
	and p.Reporte = 1 	

	INSERT INTO #data
	(
		idPRoducto,
		producto,
		dashStyle,
		color,
		fecha,
		valorFecha,
		valor,
		linkedTo,
		marca,
		idCadena
	)
	SELECT 
	P.idProducto,
	P.Nombre,
	1,
	'',
	YEAR(R.FechaCreacion) * 10000 +	DATEPART(MONTH,R.FechaCreacion) * 100 + DATEPART(DAY,R.FechaCreacion) * 1,
	CONVERT(VARCHAR,R.FechaCreacion,103),
	RPC.Precio,
	NULL,
	M.Nombre,
	PDV.idCadena
FROM 
	Reporte R 
	INNER JOIN ReporteProductoCompetencia RPC ON R.idReporte = RPC.idReporte
	INNER JOIN ProductoCompetencia PC ON RPC.idProducto = PC.idProductoCompetencia
	INNER JOIN Producto P2 ON PC.idProducto = P2.idProducto
	INNER JOIN Producto P ON RPC.idProducto = P.idProducto
	INNER JOIN Marca M ON P.idMarca = M.idMarca
	INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
	INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
WHERE 
	C.idCliente = @idCliente
	AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
	AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p2.idProducto))
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p2.idFamilia))
	and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))
	AND ISNULL(RPC.Precio,0) != 0			
	
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int,
		fecha int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,fecha)
	select idProducto,valor,count(valor),fecha
	from  #data
	group by idProducto,valor,fecha


	SET DATEFIRST 1
	;WITH DateTable
	AS
	(
		SELECT CONVERT(DATE,'20180101') Fecha
		UNION ALL
		SELECT DATEADD(DAY, 1, Fecha)
		FROM DateTable
		WHERE DATEADD(DAY, 1, Fecha) < CONVERT(DATE,'20181231')
	)SELECT 
		Fecha,
		DATENAME(WEEKDAY,Fecha) Dia,
		ROW_NUMBER() OVER (ORDER BY Fecha) NroSemana,
		2018 as anio
	INTO
		#Semanas
	FROM 
		DateTable
	WHERE 
		DATENAME(WEEKDAY,Fecha) = 'Viernes' 
	OPTION 
		(MAXRECURSION 730)


;WITH DateTable
	AS
	(
		SELECT CONVERT(DATE,'20190101') Fecha
		UNION ALL
		SELECT DATEADD(DAY, 1, Fecha)
		FROM DateTable
		WHERE DATEADD(DAY, 1, Fecha) < CONVERT(DATE,'20191231')
	)
	insert #Semanas(fecha,dia,NroSemana,anio)
	SELECT 
		Fecha,
		DATENAME(WEEKDAY,Fecha) Dia,
		ROW_NUMBER() OVER (ORDER BY Fecha) NroSemana,
		2019 as anio
	FROM 
		DateTable
	WHERE 
		DATENAME(WEEKDAY,Fecha) = 'Viernes' 
	OPTION 
		(MAXRECURSION 730)

	update p 
	SET cantidad = (select count(1) from #preciosPorProducto where idproducto = p.idproducto and fecha = p.fecha and precio = p.precio) 
	from #preciosPorProducto p
	
	select d.idPRoducto,d.producto,
	convert(varchar,(SELECT Fecha 
					FROM #Semanas 
					WHERE NroSemana = DATEPART(WEEK,CONVERT(VARCHAR,d.fecha,112))
					and anio =  DATEPART(YEAR,CONVERT(VARCHAR,d.fecha,112))),112) fecha,
					d.valorFecha,cast(max(p.precio) as decimal(18,2))as valor,d.color,
	d.dashStyle,d.linkedTo,d.Marca,prod.orden, 'Semana ' + CONVERT(VARCHAR,DATEPART(WEEK,CONVERT(VARCHAR,d.fecha,112))) Cat, p.cantidad qty 
	into #prepdata
	from #data d
	inner join #preciosPorProducto p		
	on p.idProducto = d.idProducto and p.fecha = d.fecha	
	inner join producto prod on prod.idProducto = p.idProducto
	where p.cantidad = (select max(cantidad) from #preciosPorProducto WHERE idproducto = p.idproducto and fecha = d.fecha)
	group by d.idProducto,d.producto,d.fecha,d.valorFecha,d.color
	,d.dashStyle,d.linkedTo,d.Marca,prod.orden,p.precio,p.cantidad
	order by d.idProducto,p.precio asc--,(SELECT Fecha FROM #Semanas WHERE NroSemana = DATEPART(WEEK,CONVERT(VARCHAR,d.fecha,112)))

	SELECT DISTINCT idProducto,Producto,fecha,valorfecha,valor,color,dashStyle,linkedTo,Marca,orden,Cat INTO #finaldata 
	FROM #prepdata F 
	WHERE Qty = (SELECT MAX(QTY) FROM #prepdata WHERE idProducto = F.idProducto AND Cat = F.Cat)
	SELECT DISTINCT idProducto,Producto,fecha,CONVERT(VARCHAR,fecha,103) valorfecha,valor,color,dashStyle,linkedTo,Marca,orden,Cat,null qty into #finalreport 
	FROM #finaldata  F 
	WHERE valor = (SELECT MIN(valor) FROM #finaldata WHERE idProducto = F.idProducto AND Cat = F.Cat)

	select 1
	
	create table #columnasConfiguracion
	(
		esAgrupador bit,
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)
																							
		insert #columnasConfiguracion (esAgrupador,esclave,mostrar,name, title, width)
		values
		(0,0,1,'producto','SKU Propio',5),
		(0,0,1,'precio','Precio',5),
		(0,0,1,'productoCompetencia','SKU Competencia',5),
		(0,0,1,'precioCompetencia','Precio',5),
		(0,0,1,'gap','Gap',5)
		
		
		select mostrar,name, title, width from #columnasConfiguracion

		UPDATE F set qty = (SELECT count(1) FROM #finalreport where producto = f.producto and valor = f.valor) FROM #finalReport f

		delete F from #finalreport f where qty != (select max(qty) from #finalreport where producto = f.producto)
		delete F from #finalreport f where valor != (select min(valor) from #finalreport where producto = f.producto)
				
		SELECT DISTINCT P.Nombre producto,F.valor precio,P2.Nombre productoCompetencia,F2.valor precioCompetencia,ltrim(rtrim(str(((F.valor/F2.valor)-1)*100,18,2)))+'%' gap FROM #finalreport F
		INNER JOIN Producto P ON F.idProducto = P.idProducto
		INNER JOIN ProductoCompetencia PC ON F.idProducto = PC.idProducto
		INNER JOIN Producto P2 ON PC.idProductoCompetencia = P2.idProducto
		INNER JOIN #finalreport F2 ON P2.idProducto = F2.idProducto
		
	---------------------------------------------------------------------------------------------------------------------------------
end
GO

