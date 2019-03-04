--Epson_EvaluacionGeneral_T9 61
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Epson_EvaluacionGeneral_T9'))
   exec('CREATE PROCEDURE [dbo].[Epson_EvaluacionGeneral_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Epson_EvaluacionGeneral_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
	,@mejores           bit = 0
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
	declare @difDias int
	declare @strFDesdePeriodoAnterior varchar(30)
	declare @strFHastaPeriodoAnterior varchar(30)
	
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
	
	--PREGUNTAR SI ESTO ESTA BIEN ASI O SACARLO (PARA EL CASO EN EL QUE NO SE INGRESE FILTRO POR CLIENTE)
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	create table #tempReporte
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #TotalModulos 
	(
		IdReporte int,
		IdMarca int,
		TotalModulos Decimal(18,8)
	) 


	create table #datosFinal
	(
		id int identity(1,1),
		idPDV int,
		NombrePDV varchar(500),
		mes varchar(20),
		NombreMes varchar(100),
		qty numeric(18,2),
		result varchar(200)
	)	


	create table #tablaPonderaciones
	(	idReporte int,
		idMarca int,
		ponderacionMarca decimal(9,5),
		idModulo int,
		ponderacionModulo decimal(9,5),
		idItem int,
		PonderacionItem decimal(9,5),
		Valor bit
	)
	CREATE NONCLUSTERED INDEX IX_reporte  
	ON #tablaPonderaciones (idReporte)  
	INCLUDE ([PonderacionMarca]);  
 


	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idEmpresa, IdPuntoDeVenta, mes, idReporte)
	select	r.idEmpresa
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)			
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	group by r.IdEmpresa, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	


	--SI EL MODULO O ITEM NO LLEGA A CUBIR EL 100%, ENTONCES TENGO QUE ACTUALIZAR LAS PONDERACIONES.
	exec Epson_Calculo_Ponderacion

	
	create table #datosFinal_marca
	( idReporte int,
	  idMarca int,
	  nombreMarca varchar(100) collate database_default,
	  qty decimal(9,2)
	)
	
	insert #datosFinal_marca(idReporte,idMarca,nombreMarca,qty)
	select t.idReporte,
			t.idMarca,
		   m.Nombre,
		  --round((sum((t.Valor * t.PonderacionItem / 100.0)* (t.PonderacionModulo /100.0))/count(distinct t.idReporte))*100.0,2)
		  round((sum((t.Valor * 100 / 100.0)* (100 /100.0))/count(distinct t.idReporte))*100.0,2)
	 from #tablaPonderaciones t
	 inner join marca m on m.idMarca = t.idMarca
	 group by t.idReporte,t.idMarca,m.nombre
	 order by idMarca
	
	
 	
	
	update #datosFinal_marca
	set qty = 100.0
	where qty > 100.0
	
	insert #datosFinal (idPDV, NombrePDV, mes,NombreMes, qty)
	SELECT temp.idPuntoDeVenta as IdPDV 
		  ,pdv.Nombre as NombrePDV
		  ,left(temp.mes,6) as mes
		  ,Datename(mm,temp.mes) + ' ' + Datename(yy,temp.mes) as NombreMes
		  --, round((sum((t.Valor * 100.0 / 100.0)* (100.0 /100.0) * (t.PonderacionMarca / 100.0))/count(distinct t.idReporte))*100.0,2)
		 --	  ,round((sum((t.Valor * 100 / 100.0)* (100 /100.0))/count(distinct t.idReporte))*100.0,2)
			,avg(tm.qty)
			as Performance
	FROM #tempReporte temp
	inner join #datosFinal_marca tm on tm.idReporte = temp.idReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=temp.IdPuntoDeVenta
	GROUP BY temp.idPuntoDeVenta, pdv.Nombre, temp.mes, Datename(mm,temp.mes) + ' ' + Datename(yy,temp.mes)
	

	--select * from #tablaponderaciones
	--select * from md_reporteModuloItem where idReporte = 460152
	--select * from reporte where idReporte = 460152

	--update #datosFinal
	--set qty = round(qty,2)

	update #datosFinal 
	set Result = case when 
					qty >= 0.0 and qty < 70.0 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
				 when 
					qty >= 70.0 and qty < 85.0 then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
				 when 
					qty >= 85.0 and qty <= 100.0 then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
				 end 
				 +' '+ cast(qty as varchar(100)) + ' %'	
		
	
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)
	
	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('PuntoDeVenta','PuntoDeVenta',5)
	
	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('PuntoDeVenta','Pointofsale',5)

	insert #columnasConfiguracion (name,title, width)
	select  cast(datename(month, x.mes+'01')+cast(year(x.mes+'01') as varchar) as varchar) as name 
		   ,cast(datename(month, x.mes+'01')+' '+cast(year(x.mes+'01') as varchar) as varchar) as title
			,10 as width
    from (select distinct mes from #datosFinal) x 
	order by x.mes

	

	--Datos
	declare @PivotWhere varchar(max)



	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar) + ']',
		'[' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar)+ ']'
	  )
	FROM (select distinct mes from #DatosFinal) x
	order by mes asc

	DECLARE @ColDef VARCHAR(MAX)
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar)+ ' nvarchar(4000)',
		cast(datename(month, mes+'01')+cast(year(mes+'01') as varchar) as varchar) + ' nvarchar(4000)'
	  )
	FROM (select distinct mes from #DatosFinal) x order by mes asc

	

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	  CREATE TABLE #tablaPivot 
	  ( id int identity(1,1),
	    PuntoDeVenta varchar(max),
		'+ @ColDef +'
	  )

	  insert #tablaPivot (PuntoDeVenta,'+@PivotColumnHeaders+')
	  SELECT [PuntoDeVenta],'+@PivotColumnHeaders+'
	  FROM (
		SELECT
		  NombrePDV as PuntoDeVenta,
		  datename(month, mes+'+char(39)+'01'+char(39)+')+cast(year(mes+'+char(39)+'01'+char(39)+') as varchar) as mes,
		  /*cast(Qty as numeric(18,2)) as cantidad*/
		  result as resultado
		FROM #DatosFinal 

		) AS PivotData
	  PIVOT (
		MAX(resultado)
		FOR Mes IN (
		  ' + @PivotColumnHeaders + ')
		) AS PivotTable

	declare @maxpag int

		if('+cast(@TamañoPagina as varchar)+'=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/'+cast(@TamañoPagina as varchar)+') from #tablaPivot
	select @maxpag
	
	select name,title,width from #columnasConfiguracion
	
	if('+cast(@NumeroDePagina as varchar)+'>0)
			select [PuntoDeVenta], '+@PivotColumnHeaders+'
			from #tablaPivot 
			where id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select [PuntoDeVenta], '+@PivotColumnHeaders+'
			from #tablaPivot 
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select [PuntoDeVenta], '+@PivotColumnHeaders+'
			from #tablaPivot 
			
'
	if (@PivotTableSQL is null)
	BEGIN
		declare @maxpag int

		if(cast(@TamañoPagina as varchar)=0)
			set @maxpag=1
		else
			select @maxpag=ceiling(count(*)*1.0/cast(@TamañoPagina as varchar)) from reporte where 0 = 1 
	select @maxpag
	
	select name,title,width from #columnasConfiguracion
	select 1 [PuntoDeVenta] from reporte where 0 = 1 

	END
	ELSE
	BEGIN
		exec(@PivotTableSQL)
	END
end
go


