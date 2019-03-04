IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Whirpool_relevo_T9'))
   exec('CREATE PROCEDURE [dbo].[Whirpool_relevo_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Whirpool_relevo_T9
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
	)

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(10),
		id int,
		direccion varchar(max)
	)

	create table #reportesMesPdv
	(
		IdPuntoDeVenta int,
		usuario int,
		idReporte int,
		Fecha varchar(20),
		direccion varchar(max)
		
	)

	create table #datos
	(
		id int identity(1,1),
		pdv int,
		usuario int,
		valor varchar (max),
		iditem int,
		idmarca int,
		preg varchar(max),
		orden int,
		rep int,
		--Fecha varchar(20)
		fecha datetime,
		direccion varchar (max)
	)
	create table #datos1
	(
		id int identity(1,1),
		pdv int,
		usuario int,
		valor varchar (max),
		iditem int,
		idmarca int,
		preg varchar(max),
		orden int,
		rep int,
		Fecha varchar(20),
		direccion varchar (max)
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

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id,direccion)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
				,p.Direccion
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
		and pcu.idCliente = @idcliente
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta,p.Direccion

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta)
		select @i, idUsuario, IdPuntoDeVenta
		from #tempPCU
		
		set @i=@i+1
	end


	insert #reportesMesPdv (IdPuntoDeVenta,direccion, Usuario, idReporte, Fecha)
	select r.IdPuntoDeVenta,p.Direccion, r.idUsuario, r.IdReporte, r.FechaCreacion---convert(varchar,r.FechaCreacion,103)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))

	
	insert #datos (pdv,direccion, usuario, valor, iditem, idmarca, preg, orden,rep,fecha)
	select r.IdPuntoDeVenta,r.direccion, r.usuario, mi.LabelCampo1+' - '+mdr.Valor4 as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg,r.idReporte,r.fecha
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte
	
	insert #datos (pdv,direccion, usuario, valor, iditem, idmarca, preg, orden,rep,fecha)
	select r.IdPuntoDeVenta,r.direccion, r.usuario, mi.LabelCampo2+' - '+mdr.Valor4 as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg,r.idReporte,r.fecha
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte

	insert #datos (pdv,direccion, usuario, valor, iditem, idmarca, preg, orden,rep,fecha)
	select r.IdPuntoDeVenta,r.direccion, r.usuario, NULL as valor, mi.IdItem, mdr.idMarca, mi.Nombre, mi.Orden as preg,r.idReporte,r.fecha
	from MD_ReporteModuloItem mdr
	inner join MD_Item mi on mi.IdItem = mdr.IdItem
	inner join MD_Modulo mm on mm.IdModulo = mi.IdModulo
	inner join #reportesMesPdv r on r.IdReporte = mdr.IdReporte

	create table #datosRes
	(
		id int identity(1,1),
		iditem int,
		idmarca varchar(max),
		preg varchar(100),
		pdv varchar(max),
		usuario varchar(max),
		valor varchar(max),
		Fecha varchar(20),
		direccion varchar (max)
	)

	insert #datosRes (iditem, idmarca, preg, pdv,direccion, usuario, valor,fecha)
	select orden, idmarca, preg, pdv,direccion, usuario, valor,fecha 
	from #datos 
	where orden not in (16)
	order by orden
	
	create table #datosRes_16
	(
		id int identity(1,1),
		iditem int,
		idmarca varchar(max),
		direccion varchar (max),
		preg varchar(100),
		pdv varchar(max),
		usuario varchar(max),
		valor varchar(max),
		Fecha varchar(20),
		rep int
	)

	insert #datosRes_16 (iditem, idmarca, preg, pdv,direccion, usuario, valor,fecha,rep)
	select orden, idmarca, preg, pdv,direccion, usuario, SUBSTRING(valor, +5, CHARINDEX('-',valor,+3)),fecha,rep 
	from #datos 
	where orden =16
	order by orden

	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(iditem as varchar(500)) + ']','[' + cast(iditem as varchar(500)) + ']'
	  )
	FROM (select distinct iditem from #datosRes ) x order by iditem
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(iditem as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct iditem from #datosRes )x order by iditem

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='pdv varchar(max),direccion varchar(max), usuario varchar(max), idmarca varchar(max),fecha varchar(max)'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(iditem as varchar(500)) + '" varchar(max)',cast(iditem as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct iditem from #datosRes )	x order by iditem
	
	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([pdv],[direccion],[usuario],[idmarca],[fecha],'+@PivotColumnHeaders+')
	SELECT [pdv],[direccion],[usuario],[idmarca],[fecha],'+@PivotColumnHeaders+'
	  FROM (
		Select iditem, pdv,direccion, usuario, idmarca, valor,fecha from #DatosRes 
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
    
	insert #DatosPivotFinal ([pdv],[direccion],[usuario],[idmarca],[fecha],'+@PivotColumnHeaders+')
	select [pdv],[direccion],[usuario],[idmarca],[fecha],'+@PivotColumnHeaders+' 
	from #DatosPivot 
	where '+@PivotWhereCondition +'
	
    
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
	

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'direccion'+char(39)+','+char(39)+'direccion'+char(39)+', 80, -1)

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idPuntoDeVenta'+char(39)+','+char(39)+'idPDV'+char(39)+', 80, -4)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Fecha'+char(39)+','+char(39)+'Fecha'+char(39)+', 80, -3)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Nombre'+char(39)+','+char(39)+'PDV'+char(39)+', 80, -2)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Usuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 80, -1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Marca'+char(39)+','+char(39)+'Marca'+char(39)+', 80, 0)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Asistentes'+char(39)+','+char(39)+'Asistentes'+char(39)+', 80, 0)
	

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.iditem as varchar) as name, i.preg as title, 40 as width, i.iditem
	from #DatosRes i
    
	select name, title, width from #columnasDef order by orden, name
	
    
	if('+cast(@NumeroDePagina as varchar)+'>0)
			select  d.fecha as Fecha,pdv.idPuntoDeVenta,pdv.Nombre,d.direccion, u.Apellido+'', ''+u.Nombre collate database_default as Usuario, r.valor as 
			Asistentes,m.Nombre as Marca,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca
			left join #datosRes_16 r on r.pdv  = d.pdv  and d.usuario= r.usuario and r.valor is not null and d.fecha = r.fecha
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and 
			('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select  d.fecha as Fecha,pdv.idPuntoDeVenta,pdv.Nombre,d.direccion, u.Apellido+'', ''+u.Nombre collate database_default as Usuario,
			r.valor as Asistentes, m.Nombre as Marca,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca
			left join #datosRes_16 r on r.pdv  = d.pdv  and d.usuario= r.usuario and r.valor is not null and d.fecha = r.fecha
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select  d.fecha as Fecha,pdv.idPuntoDeVenta,pdv.Nombre,d.direccion, u.Apellido+'', ''+u.Nombre collate database_default as Usuario,
			r.valor as Asistentes, m.Nombre,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.pdv
			inner join Usuario u on u.idUsuario = d.usuario
			inner join Marca m on m.idMarca = d.idMarca
			left join #datosRes_16 r on r.pdv  = d.pdv  and d.usuario= r.usuario and r.valor is not null and d.fecha = r.fecha
			

	'	

	EXEC sp_executesql @PivotTableSQL

	
end

/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181201,20181230')
--insert into @p2 values(N'fltpuntosdeventa',N'189279')
--insert into @p2 values(N'fltusuarios',N'3976')
--insert into @p2 values(N'fltMarcas',N'2464')
exec Whirpool_relevo_T9 @IdCliente=187,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/