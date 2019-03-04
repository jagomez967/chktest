IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_MesUsuario_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_MesUsuario_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Cob_MesUsuario_T9] 	
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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		id int identity(1,1),
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)

	create table #asignados
	(
		idUsuario int
		,mes varchar(6)
		,idPuntoDeVenta int
	)

	create table #Relevados
	(
		idUsuario int
		,Fecha varchar(7)
		,mes varchar(9)
		,qty int
	)


	-------------------------------------------------------------------- TEMPS (Filtros)

	declare @i int = 1
	declare @max int
	declare @currentFecha datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU
		
		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #meses where id=@i

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, mes, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,left(@currentFecha,7)
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where convert(date,Fecha)<=convert(date,@currentFecha)
		and exists(select 1 from #clientes where idCliente = pcu.idCliente)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))	
		and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
		and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))	
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (idUsuario, mes, idPuntoDeVenta)
		select idUsuario, left(convert(varchar,@currentFecha,112),6), IdPuntoDeVenta from #tempPCU

		set @i=@i+1
	end

	create table #cantAsignados
	(
		Asignados int,
		idUsuario int,
		mes varchar(7)
	)
	
	insert #cantAsignados
	select count(idPuntoDeVenta), idUsuario, left(mes,7) from #asignados
	group by idUsuario, mes
		
		
	insert #Relevados (idUsuario, Fecha, mes, qty)
	select	r.IdUsuario
			,left(convert(varchar, FechaCreacion, 112),6)
			,'col'+left(convert(varchar, FechaCreacion, 112),6)
			,count(distinct r.idpuntodeventa)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where convert(date,r.FechaCreacion) between convert(date,@fechadesde) and convert(date,@fechahasta)
	and exists(select 1 from #clientes where idCliente = c.idCliente)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))	
	and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
	and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
		
	group by r.IdUsuario,left(convert(varchar, FechaCreacion, 112),6),'col'+left(convert(varchar, FechaCreacion, 112),6)

	create table #datosRes
	(
		idUsuario int,
		mes varchar(9),
		qty int
	)

	insert #datosRes (qty, idUsuario, mes)
	select cast(qty*100/Asignados as int), c.idUsuario, r.mes from #cantAsignados c
	inner join #Relevados r on c.idUsuario = r.idUsuario and c.mes = r.Fecha


	declare @cantMeses int
	select @cantMeses = count(distinct mes) from #datosRes
	
	declare @cantUsuarios int
	select @cantUsuarios = count(distinct idUsuario) from #datosRes
	
	create table #totalesUsuario
	(
		idusuario int,
		total numeric
	)

	insert #totalesUsuario
	select idUsuario, isnull(sum(qty),0)/@cantMeses from #datosRes
	group by idUsuario

	create table #totalesMeses
	(
		mes varchar(100),
		total numeric
	)
	
	insert #totalesMeses
	select mes, isnull(sum(qty),0)/@cantUsuarios from #datosRes
	group by mes
	union all
	select 'totalRow',isnull(sum(total),0)/@cantUsuarios from #totalesUsuario


	declare @minRojo int=0, @maxRojo int=64
	declare @minAmarillo int=65, @maxAmarillo int=94
	declare @minVerde int=95


	alter table #totalesUsuario
	alter column total varchar(100)
	alter table #totalesMeses
	alter column total varchar(100)
	alter table #datosRes
	alter column qty varchar(100)
	
	update #datosRes set qty = case when qty between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when qty between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when qty >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(qty as varchar(100)) + ' %'
	
	update #totalesUsuario set total = case when total between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when total between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when total >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(total as varchar(100)) + ' %'

	update #totalesMeses set total = case when total between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16"/>'
	when total between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
	when total >= @minVerde then '<img src="images/circuloVerde.png" width="16" height="16"/>' end +' '+ cast(total as varchar(100)) + ' %'


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(mes as varchar(500)) + ']','[' + cast(mes as varchar(500)) + ']'
	  )
	FROM (select distinct mes from #datosRes) x order by mes

	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull(' + cast(mes as varchar(500)) + ',0)<>'+char(39)+char(39),'isnull('+cast(mes as varchar(500)) + ',0)<>'+char(39)+char(39)
	  )
	FROM (select distinct mes from #datosRes) x order by mes

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idusuario int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(mes as varchar(500)) + ' varchar(max)',cast(mes as varchar(500)) + ' varchar(max)'
	  )
	FROM (select distinct mes from #datosRes) x order by mes

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idusuario],'+@PivotColumnHeaders+')
	SELECT [idusuario],'+@PivotColumnHeaders+'
	  FROM (
		Select idusuario, mes, qty from #DatosRes
		) AS PivotData
	  PIVOT (
		max(qty)
		FOR mes IN (
		  ' + @PivotColumnHeaders + '
		)
	  ) AS PivotTable

	CREATE TABLE #totalRow
	(
		'+@ColDef+',
		totalZ varchar(100)
	)

	insert #totalRow ('+@PivotColumnHeaders+', [totalZ])
	select * from (
			select mes, total as Total from #totalesMeses
			) as x
		PIVOT (
			max(total) for mes in (
					'+@PivotColumnHeaders+',
					[totalRow]
								) 
							)as PivotSum


	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+',
		total varchar(100)
	) 

	insert #DatosPivotFinal ([idusuario],'+@PivotColumnHeaders+')
	select [idusuario],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
	update #DatosPivotFinal set total = t.total from (select idusuario, total from #totalesUsuario) t where t.idusuario = #DatosPivotFinal.idusuario
	
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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'idusuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 150, 1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'total'+char(39)+','+char(39)+'Total'+char(39)+', 150, 13)

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.mes as varchar) as name, left(i.Fecha,7) as title, 40 as width, 5 as orden
	from #Relevados i

	select name, title, width from #columnasDef order by orden, name


	if('+cast(@NumeroDePagina as varchar)+'>0)
			select ltrim(rtrim(u.Apellido)) as idusuario,'+@PivotColumnHeaders+', tu.total as total
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #totalesUsuario tu on tu.idusuario = d.idusuario
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select ltrim(rtrim(u.Apellido)) as idusuario,'+@PivotColumnHeaders+', tu.total as total
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #totalesUsuario tu on tu.idusuario = d.idusuario
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow

		if('+cast(@NumeroDePagina as varchar)+'<0)
			select ltrim(rtrim(u.Apellido)) as idusuario,'+@PivotColumnHeaders+', tu.total as total
			from #DatosPivotFinal d
			inner join Usuario u on u.idusuario = d.idusuario
			inner join #totalesUsuario tu on tu.idusuario = d.idusuario
			union all
			select ''Total'', '+@PivotColumnHeaders+', totalZ from #totalRow
						
			
	'	
	
	EXEC sp_executesql @PivotTableSQL
end
go
