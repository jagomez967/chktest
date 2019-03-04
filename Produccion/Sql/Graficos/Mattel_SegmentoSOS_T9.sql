IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_SegmentoSOS_T9'))
   exec('CREATE PROCEDURE [dbo].[Mattel_SegmentoSOS_T9] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].Mattel_SegmentoSOS_T9
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
		idPuntoDeVenta int,
		mes varchar(8),
		idCadena int,
		idReporte int
	)


	create table #datos
	(
		valor numeric(10,2),
		idempresa int,
		idproducto int,
		idPuntodeventa int,
		idMarca int,
		idSegmento int,
		idCadena int
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idCadena, idReporte)
	select r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), pdv.IdCadena, r.IdReporte
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
	--group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), pdv.IdCadena

	insert #datos(idempresa, idPuntodeventa, idproducto, idmarca, idsegmento, valor, idcadena)
	select r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto, p.IdMarca, mc.idsegmento, sum(isnull(rp.precio,0)), r.idCadena
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join MattelCat_Seg_Marca_Prod mc on mc.idProducto = p.idProducto
	where	isnull(rp.precio,0)>0
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
	group by  r.idEmpresa, r.idPuntoDeVenta, rp.IdProducto, p.IdMarca, mc.idsegmento, r.idCadena

	insert #datos (idempresa, idPuntodeventa, idproducto, idmarca, idsegmento, valor, idcadena)
	select m2.idempresa, r.idPuntoDeVenta, rp.IdProducto, p2.IdMarca, mc.idsegmento, sum(isnull(rp.precio,0)), r.idCadena
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join MattelCat_Seg_Marca_Prod mc on mc.idProducto = rp.idProducto
	inner join ProductoCompetencia pc on pc.IdProductoCompetencia=rp.IdProducto
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Producto p2 on p2.idProducto = pc.idProducto
	inner join Marca m on m.IdMarca=p2.IdMarca
	inner join Marca m2 on m2.idMarca = p.idMarca
	where	isnull(rp.precio,0)>0
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p2.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = rp.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
	group by  m2.idempresa, r.idPuntoDeVenta, rp.IdProducto, p2.IdMarca, mc.idsegmento, r.idCadena

	create table #totalporsegmento
	(
		idsegmento int,
		idcadena int,
		qty numeric(10,2)
	)
	insert #totalporsegmento (idsegmento, idcadena, qty)
	select d.idsegmento, d.idcadena, sum(d.valor) from #datos d
	group by d.idsegmento, d.idcadena
	

	create table #datosCant
	(
		idcadena varchar (50),
		cadena varchar(100),
		idempresa int,
		empresa varchar (100),
		idsegmento int,
		idmarca int,
		marca varchar(100),
		idproducto int,
		producto varchar (100),
		qty numeric(10,2)		
	)

	insert #datosCant(idcadena, cadena, idempresa, empresa, idSegmento, idmarca, marca, idproducto, producto, qty)
	select 'col'+cast(d.idcadena as varchar)+'m', ltrim(rtrim(c.Nombre))+' (Mts)',e.IdEmpresa, e.Nombre, d.idSegmento, d.idmarca, m.Nombre, d.idproducto, ltrim(rtrim(p.Nombre)), sum(d.valor) from #datos d
	inner join Cadena c on c.IdCadena = d.idcadena
	inner join Producto p on p.IdProducto = d.idproducto
	inner join Marca m on m.IdMarca = d.IdMarca
	inner join Empresa e on e.IdEmpresa = d.IdEmpresa
	inner join #totalporsegmento temp on temp.idsegmento = d.idsegmento and temp.idcadena = d.idcadena
	group by d.idcadena, c.Nombre, e.IdEmpresa, e.Nombre, d.idsegmento, d.idmarca, m.Nombre, d.idproducto, p.Nombre, temp.qty

	create table #datosShare
	(
		idcadena varchar (50),
		cadena varchar(100),
		idempresa int,
		empresa varchar (100),
		idsegmento int,
		idmarca int,
		marca varchar(100),
		idproducto int,
		producto varchar (100),
		share numeric(10,2)		
	)

	insert #datosShare(idcadena, cadena, idempresa, empresa, idsegmento, idmarca, marca, idproducto, producto, share)
	select 'col'+cast((d.idcadena) as varchar)+'p', ltrim(rtrim(c.Nombre))+' (%)',e.IdEmpresa, e.Nombre, d.idsegmento, d.idmarca, m.Nombre, d.idproducto, ltrim(rtrim(p.Nombre)), cast(sum(d.valor)*100.0/temp.qty as numeric(10,2)) from #datos d
	inner join Cadena c on c.IdCadena = d.idcadena
	inner join Producto p on p.IdProducto = d.idproducto
	inner join Marca m on m.IdMarca = d.IdMarca
	inner join Empresa e on e.IdEmpresa = d.IdEmpresa
	inner join #totalporsegmento temp on temp.idsegmento = d.idsegmento and temp.idcadena = d.idcadena
	group by d.idcadena, c.Nombre, e.IdEmpresa, e.Nombre, d.idsegmento, d.idmarca, m.nombre, d.idproducto, p.Nombre, temp.qty


	create table #datosRes
	(
		id int identity(1,1),
		idcadena varchar(50),
		cadena varchar(100),
		idsegmento int,
		segmento varchar(max),
		idmarca int,
		marca varchar(max),
		empresa varchar(100),
		idproducto int,
		producto varchar(max),
		total varchar(max)
	)

	insert #datosRes (idcadena, cadena, idsegmento, segmento, idmarca, marca, empresa, idproducto, producto, total)
	select d.idcadena, d.cadena, d.idsegmento, ms.Nombre, d.idmarca, d.Marca, d.empresa, d.idproducto, d.Producto, d.qty from #datosCant d
	inner join MattelSegmento ms on ms.idSegmento = d.idSegmento

	insert #datosRes (idcadena, cadena, idsegmento, segmento, idmarca, marca, empresa, idproducto, producto, total)
	select d.idcadena, d.cadena, d.idsegmento, ms.Nombre, d.idmarca, d.Marca, d.empresa, d.idproducto, d.Producto, cast(share as varchar(max))+' %' from #datosShare d
	inner join MattelSegmento ms on ms.idSegmento = d.idSegmento

	--insert #datosRes (idcadena, cadena, idsegmento, segmento, marca, empresa, producto, total)
	--select 'col00', cadena, d.idsegmento, ms.Nombre, marca, 'Total (Mts)','', sum(qty) from #datosCant d
	--inner join MattelSegmento ms on ms.idSegmento = d.idSegmento
	--group by cadena, d.idsegmento, ms.Nombre, marca
	--order by ms.Nombre
	
	--insert #datosRes (idcadena, cadena, idsegmento, segmento, marca, empresa, producto, total)
	--select 'col0', cadena, d.idsegmento, ms.Nombre, marca, 'Total (%)', '', cast(sum(share) as varchar)+' %' from #datosShare d
	--inner join MattelSegmento ms on ms.idSegmento = d.idSegmento
	--group by cadena, d.idsegmento, ms.Nombre, marca
	--order by ms.Nombre


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
		Select idMarca, idSegmento, idProducto, idCadena, total from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(total)
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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'categoria'+char(39)+','+char(39)+'Categoria'+char(39)+', 50, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'segmento'+char(39)+','+char(39)+'Segmento'+char(39)+', 50, 2)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'marca'+char(39)+','+char(39)+'Marca'+char(39)+', 50, 3)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'producto'+char(39)+','+char(39)+'Producto'+char(39)+', 50, 4)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.idcadena as varchar) as name, i.cadena as title, 40 as width, 5 as orden
	from #DatosRes i


	select name, title, width, orden from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select m2.Nombre as categoria, ms.Nombre as segmento, e.Nombre as marca, p.Nombre as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idproducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join Empresa e on e.idEmpresa = m.idEmpresa
			inner join MattelCat_Seg_Marca_Prod mc on mc.idProducto = p.idProducto
			inner join MattelSegmento ms on ms.idSegmento = mc.idSegmento
			inner join Marca m2 on m2.idMarca = mc.idMarca
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			order by 1,2,3


		if('+cast(@NumeroDePagina as varchar)+'=0)
			select m2.Nombre as categoria, ms.Nombre as segmento, e.Nombre as marca, p.Nombre as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idproducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join Empresa e on e.idEmpresa = m.idEmpresa
			inner join MattelCat_Seg_Marca_Prod mc on mc.idProducto = p.idProducto
			inner join MattelSegmento ms on ms.idSegmento = mc.idSegmento
			inner join Marca m2 on m2.idMarca = mc.idMarca
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			order by 1,2,3


		if('+cast(@NumeroDePagina as varchar)+'<0)
			select m2.Nombre as categoria, ms.Nombre as segmento, e.Nombre as marca, p.Nombre as producto, '+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join Producto p on p.idProducto = d.idproducto
			inner join Marca m on m.idMarca = p.idMarca
			inner join Empresa e on e.idEmpresa = m.idEmpresa
			inner join MattelCat_Seg_Marca_Prod mc on mc.idProducto = p.idProducto
			inner join MattelSegmento ms on ms.idSegmento = mc.idSegmento
			inner join Marca m2 on m2.idMarca = mc.idMarca
			order by 1,2,3

	'	

	EXEC sp_executesql @PivotTableSQL

	
end


