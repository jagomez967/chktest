IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Encuesta_Completa_BaytonTarjetaNaranja_T9'))
   exec('CREATE PROCEDURE [dbo].[Encuesta_Completa_BaytonTarjetaNaranja_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Encuesta_Completa_BaytonTarjetaNaranja_T9
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

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #meses
	(
		 id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes,qty) select convert(varchar, @fechaDesdeMeses,112),0
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #asignados
	(
		 id int
		,idUsuario int
		,idPuntoDeVenta int
		,localidad varchar(max)
		,zona varchar(max)
	)

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int,
		zona varchar (max),
		localidad varchar (max)
	)

	create table #reportesMesPdv
	(
		Fecha datetime,
		IdPuntoDeVenta int,
		usuario int,
		idReporte int,
		localidad varchar(max),
		zona varchar (max)
		
	)

	create table #datos
	(
		fecha datetime,
		id int identity(1,1),
		idreporte int,
		pdv int,
		usuario int,
		valor varchar (max),
		iditem int,
		idmarca int,
		preg varchar(max),
		orden int,
		localidad varchar(max),
		zona varchar(max)
	
	)

	-------------------------------------------------------------------- END (Temps)

	declare @i int = 1
	declare @max int
	declare @currentFechaHasta datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU

		select @fechaHasta=dateadd(day,-1,DATEADD(month,1,mes)) from #meses where id=@i
		set @currentFechaHasta = dateadd(month,1,dateadd(day,-day(@fechaHasta),@fechaHasta))

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta,zona,localidad, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,z.Nombre as zona
				,l.Nombre as localidad
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join Localidad l on p.IdLocalidad = l.IdLocalidad
		inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = pcu.IdCliente
		inner join Provincia pr on pr.IdCliente = pcu.IdCliente and pr.IdProvincia = l.IdProvincia
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
		and pcu.idCliente = @idcliente
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta,z.nombre,l.nombre

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta,zona,localidad)
		select @i, idUsuario, IdPuntoDeVenta,zona,localidad
		from #tempPCU
		
		set @i=@i+1
	end


	insert #reportesMesPdv (Fecha,IdPuntoDeVenta,localidad,zona, Usuario, idReporte)
	select r.fechacreacion,r.IdPuntoDeVenta,l.nombre as localidad,z.nombre as zona, r.idUsuario, r.IdReporte
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia
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
	
	
	insert #datos (fecha,idreporte, pdv,zona,localidad, usuario, valor, iditem, idmarca, preg, orden)
	select r.fecha,r.idReporte, r.IdPuntoDeVenta,z.nombre as zona,l.nombre as localidad, r.usuario, mi.LabelCampo1+' - '+isnull(mdr.Valor4,0) as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte 
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia
	where isnull(mdr.valor1,0) > 0 

	
	insert #datos (fecha,idreporte, pdv,zona,localidad, usuario, valor, iditem, idmarca, preg, orden)
	select r.fecha,r.idReporte, r.IdPuntoDeVenta,z.nombre as zona,l.nombre as localidad, r.usuario, mi.LabelCampo2+' - '+isnull(mdr.Valor4,0) as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia
	where isnull(mdr.Valor2,0) > 0

	
	insert #datos (fecha,idreporte, pdv,zona,localidad, usuario, valor, iditem, idmarca, preg, orden)
	select r.fecha,r.idReporte, r.IdPuntoDeVenta,z.nombre as zona,l.nombre as localidad, r.usuario, mi.LabelCampo3+' - '+isnull(mdr.Valor4,0) as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia
	where isnull(mdr.Valor3,0) > 0

	
	insert #datos (fecha,idreporte, pdv,zona,localidad, usuario, valor, iditem, idmarca, preg, orden)
	select r.fecha,r.idReporte, r.IdPuntoDeVenta,z.nombre as zona,l.nombre as localidad, r.usuario, isnull(mdr.Valor4,0) as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg 
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia
	where mdr.Valor4 is not NULL or mdr.Valor4 != ''


	insert #datos (fecha,idreporte, pdv,zona,localidad, usuario, valor, iditem, idmarca, preg, orden)
	select r.fecha,r.idReporte, r.IdPuntoDeVenta,z.nombre as zona,l.nombre as localidad, r.usuario, NULL as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg 
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Localidad l on p.IdLocalidad = l.IdLocalidad
	inner join Zona z on z.IdZona = p.IdZona and z.IdCliente = p.IdCliente
	inner join Provincia pr on pr.IdCliente = p.IdCliente and pr.IdProvincia = l.IdProvincia


--SELECT D.idReporte, R.idReporte
--   FROM #reportesMesPdv R
--   LEFT JOIN #datos D ON R.idReporte = D.idReporte
--   WHERE ISNULL(d.idReporte,0) = 0
--    and r.idReporte = 6828657
	
	--Acá debería sumar los PDVs que no relevaron items con columnas vacías

	--insert #datos (pdv, usuario, valor, iditem, preg, orden)
	--select rmp.IdPuntoDeVenta, rmp.usuario, NULL as valor, mi.IdItem, mi.Nombre, mi.Orden as preg from #reportesMesPdv rmp, MD_ReporteModuloItem mdr
	--inner join MD_Item mi on mi.IdItem = mdr.IdItem
	--inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	--inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	--where rmp.IdPuntoDeVenta in (select distinct idPuntoDeVenta from #asignados where idPuntoDeVenta not in (select pdv from #datos))

	create table #datosRes
	(	

		fecha datetime,
		id int identity(1,1),
		idreporte varchar(max),
		iditem int,
		idmarca varchar(max),
		preg varchar(100),
		pdv varchar(max),
		usuario varchar(max),
		valor varchar(max),
		localidad varchar(max),
		zona varchar(max)
		
	)


	insert #datosRes (zona,localidad,fecha,idreporte, iditem, idmarca, preg, pdv, usuario, valor)
	select zona,localidad,fecha,idreporte,iditem,
	idmarca, preg, pdv, usuario,CASE when idItem in (12459,12462,12463,12464,12466,12467,12516,12465)
	THEN  SUBSTRING(valor,CHARINDEX('-',valor,+3),30) 
    ELSE valor 
	END as valor from #datos order by orden

	--delete from #datosRes where valor is null
	
	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(iditem as varchar(500)) + ']','[' + cast(iditem as varchar(500)) + ']'
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='zona varchar(max),localidad varchar(max),fecha varchar(max),idreporte varchar(max), pdv varchar(max), usuario varchar(max), idmarca varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(iditem as varchar(500)) + '" varchar(max)',cast(iditem as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct iditem from #datosRes) x order by iditem


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([zona],[localidad],[fecha],[idreporte],[pdv],[usuario],[idmarca],'+@PivotColumnHeaders+')
	SELECT [zona],[localidad],convert(varchar(50),[fecha],103),[idreporte],[pdv],[usuario],[idmarca],'+@PivotColumnHeaders+'
	  FROM (
		Select iditem,zona,localidad,fecha, idreporte, pdv, usuario, idmarca, valor from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(valor)
		FOR iditem IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable

		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 

	insert #DatosPivotFinal ([zona],[localidad],[fecha],[idreporte],[pdv],[usuario],[idmarca],'+@PivotColumnHeaders+')
	select [zona],[localidad],[fecha],[idreporte],[pdv],[usuario],[idmarca],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
		  

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
	
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Marca'+char(39)+','+char(39)+'Marca'+char(39)+', 80, 0)

    insert #columnasDef (name, title, width, orden) values ('+char(39)+'Usuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 80, -1)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'localidad'+char(39)+','+char(39)+'localidad'+char(39)+', 80, -2)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'zona'+char(39)+','+char(39)+'zona'+char(39)+', 80, -3)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Nombre'+char(39)+','+char(39)+'PDV'+char(39)+', 80, -4)
			
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idReporte'+char(39)+','+char(39)+'idReporte'+char(39)+', 80, -5)
		
	insert #columnasDef (name, title, width, orden) values('+char(39)+'fecha'+char(39)+','+char(39)+'Fecha'+char(39)+', 80, -6)
	
	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.iditem as varchar) as name, i.preg as title, 40 as width, i.iditem
	from #DatosRes i
	
	select name, title, width from #columnasDef order by orden, name
	

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select d.fecha as fecha,d.idReporte as idReporte, pdv.Nombre,d.zona,d.localidad, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Marca,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			order by d.idreporte
		

		if('+cast(@NumeroDePagina as varchar)+'=0)
			select d.fecha as fecha,d.idReporte as idReporte, pdv.Nombre,d.zona,d.localidad, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Marca,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			order by d.idreporte
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select d.fecha as fecha,d.idReporte as idReporte, pdv.Nombre,d.zona,d.localidad, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, m.Nombre as Marca,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca 

	'	

	EXEC sp_executesql @PivotTableSQL


end

--exec Encuesta_Completa_BaytonTarjetaNaranja_T9 241





