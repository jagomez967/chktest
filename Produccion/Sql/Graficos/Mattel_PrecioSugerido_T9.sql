IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_PrecioSugerido_T9'))
   exec('CREATE PROCEDURE [dbo].[Mattel_PrecioSugerido_T9] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].Mattel_PrecioSugerido_T9
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

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idCadena int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		id int identity(1,1),
		idempresa int,
		idcadena int,
		idproductopropio int,
		idproductocomp int,
		precio decimal (9,2)
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idCadena, mes, idReporte)
	select r.idempresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6), max(r.IdReporte)
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias pro where pro.idProvincia in(select idProvincia from localidad loc where loc.idLocalidad = pdv.idLocalidad)))
	group by r.IdEmpresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6)

	insert #datos (idempresa, idcadena, idproductopropio, idproductocomp, precio)
	select e.idEmpresa, r.idCadena, pc.idProducto, rp.IdProducto, isnull(rp.Precio,0) from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte = r.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join ProductoCompetencia pc on rp.idProducto = pc.idProductoCompetencia
	inner join Empresa e on e.IdEmpresa = m.IdEmpresa
	where isnull(rp.Precio,0)>0

	create table #datosRes
	(
		idcadena varchar (8),
		cadena varchar (100),
		idpropio int,
		idproducto int,
		producto varchar (100),
		sugerido decimal (10,2),
		precio decimal (10,2),
		valor varchar (max)
	)

	insert #datosRes (idcadena, cadena, idpropio, idproducto, producto, sugerido, precio, valor)
	select 'col'+cast(d.idcadena as varchar(8)), ltrim(rtrim(c.Nombre)), ms.idProducto, d.idproductocomp, ltrim(rtrim(p.nombre)), ms.Sugerido, d.precio, cast(d.precio as varchar) + ' (' + LEFT(cast((d.precio*100.0/ms.Sugerido)-100.0 as varchar),5) + '%)' from #datos d
	inner join MattelSugerido ms on ms.idProducto = d.idProductoPropio
	inner join Cadena c on c.idCadena = d.idCadena
	inner join Producto p on p.idProducto = d.idProductoComp

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(idcadena as varchar(500)) + ']','[' + cast(idcadena as varchar(500)) + ']'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(idcadena as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idProducto int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(idcadena as varchar(500)) + ' varchar(max)',cast(idcadena as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct idcadena from #datosRes) x order by idcadena


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idProducto],'+@PivotColumnHeaders+')
	SELECT [idProducto],'+@PivotColumnHeaders+'
	  FROM (
		Select idProducto, idCadena, valor from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(valor)
		FOR idcadena IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable
	




	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([idProducto],'+@PivotColumnHeaders+')
	select [idProducto],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'

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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'marca'+char(39)+','+char(39)+'Marca'+char(39)+', 5, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'propio'+char(39)+','+char(39)+'Producto'+char(39)+', 5, 2)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'sku'+char(39)+','+char(39)+'SKU'+char(39)+', 5, 3)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'sugerido'+char(39)+','+char(39)+'Precio Sugerido'+char(39)+', 5, 4)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'marcacomp'+char(39)+','+char(39)+'Marca Comp'+char(39)+', 5, 5)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'prodcomp'+char(39)+','+char(39)+'Producto Comp'+char(39)+', 10, 6)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idcadena as varchar) as name, i.cadena as title, 40 as width, 7 as orden
	from #DatosRes i

	select name, title, width from #columnasDef


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select m2.Nombre as marca, p2.Nombre as propio, ms.SKU as sku, ms.Sugerido as sugerido,m.Nombre as marcacomp, p.Nombre as prodcomp, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join ProductoCompetencia pc on pc.idProductoCompetencia = d.idProducto
			inner join Producto p2 on p2.idProducto = pc.idProducto
			inner join Marca m2 on m2.idMarca = p2.idMarca
			inner join MattelSugerido ms on ms.idProducto = p2.idProducto
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			
			
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select m2.Nombre as marca, p2.Nombre as propio, ms.SKU as sku, ms.Sugerido as sugerido,m.Nombre as marcacomp, p.Nombre as prodcomp, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join ProductoCompetencia pc on pc.idProductoCompetencia = d.idProducto
			inner join Producto p2 on p2.idProducto = pc.idProducto
			inner join Marca m2 on m2.idMarca = p2.idMarca
			inner join MattelSugerido ms on ms.idProducto = p2.idProducto
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select m2.Nombre as marca, p2.Nombre as propio, ms.SKU as sku, ms.Sugerido as sugerido,m.Nombre as marcacomp, p.Nombre as prodcomp, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idProducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join ProductoCompetencia pc on pc.idProductoCompetencia = d.idProducto
			inner join Producto p2 on p2.idProducto = pc.idProducto
			inner join Marca m2 on m2.idMarca = p2.idMarca
			inner join MattelSugerido ms on ms.idProducto = p2.idProducto
			

	'	

	EXEC sp_executesql @PivotTableSQL

	--select @PivotColumnHeaders
	--select @PivotWhereCondition
	--select @ColDef


	--declare @maxpag int
	--select @maxpag = ceiling(count(*)*1.0/@pagesize) from #datosRes
	--select @maxpag

	----Configuracion de columnas
	--create table #columnasConfiguracion
	--(
	--	name varchar(50),
	--	title varchar(50),
	--	width int
	--)
	--insert #columnasConfiguracion (name, title, width) values
	--('Marca','Marca',40),
	--('ProdPropio','NomProducto',80),
	--('SKU', 'SKU',30),
	--('sugerido', 'Sugerido',30),
	--('Empresa', 'Fabricante',30),
	--('MarcaComp', 'MarcaComp',50),
	--('ProdComp', 'NomProdComp',80),
	--('cadena1', 'PARIS',50),
	--('cadena2', 'FALABELLA',50),
	--('cadena3', 'RIPLEY',50),
	--('cadena4', 'JUMBO',50),
	--('cadena5', 'WALMART',50)
	--select name, title, width from #columnasConfiguracion

	----Datos
	--if(@pagina>0)
	--	select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5,cadena6,cadena7,cadena8 from #Resultados where id between ((@pagina - 1) * @pagesize + 1) and (@pagina * @pagesize)
	
	--if(@pagina=0)
	--	select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5,cadena6,cadena7,cadena8 from #Resultados where id between ((@maxpag - 1) * @pagesize + 1) and (@maxpag * @pagesize)
		
	--if(@pagina<0)
	--	select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5,cadena6,cadena7,cadena8 from #Resultados


	--exec Mattel_PrecioSugeridoComp_T9 6,'M,20160401,20160430'
end