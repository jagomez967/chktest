IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Alcansa_CantidadPersonas_T9'))
   exec('CREATE PROCEDURE [dbo].[Alcansa_CantidadPersonas_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Alcansa_CantidadPersonas_T9]
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		Objetivo int,
		Fecha varchar(6),
		idReporte  int
	)

	-------------------------------------------------------------------- TEMPS (Filtros)

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, Objetivo, Fecha, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,etl.CantidadPersonas as Objetivo
			,REPLACE(convert(varchar(6), r.FechaCreacion), ' ', '-') as Fecha
			,max(r.idReporte)
	from f_reporte(@filtros) r
	inner join f_PuntoDeVenta(@filtros) p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Alcansa_CantidadPersonas etl on etl.idPuntoDeVenta = r.idPuntoDeVenta-- and etl.Mes = left(convert(varchar,r.fechacreacion,112),6)
	inner join cliente c on c.idEmpresa = r.idEmpresa
	group by c.IdCliente ,r.IdUsuario, r.IdPuntoDeVenta, etl.CantidadPersonas, convert(varchar(6), r.FechaCreacion)

	create table #datos
	(
		idPuntoDeVenta int,
		idUsuario int,
		idPop int,
		Objetivo int,
		valor varchar(max),
		Fecha varchar(6)
	)

	insert #datos (idPuntoDeVenta, idUsuario, idPop, Objetivo, valor, Fecha)
	select t.idPuntoDeVenta, t.idUsuario, rp.idPop, t.Objetivo, rp.Cantidad, t.Fecha from #tempReporte t
	inner join ReportePop rp on rp.idReporte = t.idReporte


	update #datos set valor = valor+' '+'<img src="images/circuloRojo.png" width="16" height="16"/>' where valor < Objetivo


	create table #datosRes
	(
		id int identity(1,1),
		idPop int,
		Fecha varchar(6),
		idPuntoDeVenta varchar(max),
		Objetivo int,
		idUsuario varchar(max),
		valor varchar(max)
	)


	insert #datosRes (idPop, Fecha, idPuntoDeVenta, Objetivo, idUsuario, valor)
	select idPop, Fecha, idPuntoDeVenta, Objetivo, idUsuario, valor from #datos


	DECLARE @PivotColumnHeaders VARCHAR(MAX)
	SELECT @PivotColumnHeaders = 
	  COALESCE(
		@PivotColumnHeaders + ',[' + cast(Fecha as varchar(500)) + ']','[' + cast(Fecha as varchar(500)) + ']'
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha
	
	DECLARE @PivotWhereCondition VARCHAR(MAX)
	SELECT @PivotWhereCondition = 
	  COALESCE(
		@PivotWhereCondition + 'and isnull([' + cast(Fecha as varchar(500)) + '],0)<>'+char(39)+char(39),'isnull(['+cast(Fecha as varchar(500)) + '],0)<>'+char(39)+char(39)
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha

	DECLARE @ColDef VARCHAR(MAX)
	set @ColDef='idPuntoDeVenta varchar(max), idUsuario varchar(max), Objetivo int'
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',"' + cast(Fecha as varchar(500)) + '" varchar(max)',cast(Fecha as varchar(500)) + '" varchar(max)'
	  )
	FROM (select distinct Fecha from #datosRes) x order by Fecha


	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	CREATE TABLE #DatosPivot
	(
		'+@ColDef+'
	)

	insert #DatosPivot([idPuntoDeVenta],[idUsuario], [Objetivo],'+@PivotColumnHeaders+')
	SELECT [idPuntoDeVenta],[idUsuario], [Objetivo],'+@PivotColumnHeaders+'
	  FROM (
		Select Fecha, idPuntoDeVenta, idUsuario, Objetivo, valor from #DatosRes
	  ) AS PivotData
	  PIVOT (
		max(valor)
		FOR Fecha IN (
		  ' + @PivotColumnHeaders + '
		)
	)	AS PivotTable

		 
	CREATE TABLE #DatosPivotFinal
	(
		id int identity(1,1),
		'+@ColDef+'
	) 



	insert #DatosPivotFinal ([idPuntoDeVenta],[idUsuario], [Objetivo],'+@PivotColumnHeaders+')
	select [idPuntoDeVenta],[idUsuario], [Objetivo],'+@PivotColumnHeaders+' from #DatosPivot where '+@PivotWhereCondition +'
	


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

	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Usuario'+char(39)+','+char(39)+'Usuario'+char(39)+', 15, -6)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Provincia'+char(39)+','+char(39)+'Provincia'+char(39)+', 15, -5)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Zona'+char(39)+','+char(39)+'Zona'+char(39)+', 15, -4)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Localidad'+char(39)+','+char(39)+'Localidad'+char(39)+', 15, -3)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Cadena'+char(39)+','+char(39)+'Cadena'+char(39)+', 15, -2)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'PuntoDeVenta'+char(39)+','+char(39)+'PuntoDeVenta'+char(39)+', 50, -1)
	insert #columnasDef (name, title, width, orden) values ('+char(39)+'Objetivo'+char(39)+','+char(39)+'Objetivo'+char(39)+', 10, 0)
	

	insert #columnasDef (name, title, width, orden)
	select distinct cast(i.Fecha as varchar) as name, i.Fecha as title, 10 as width, 1 as orden
	from #DatosRes i

	select name, title, width from #columnasDef order by orden, name
	

	if('+cast(@NumeroDePagina as varchar)+'>0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario, p.Nombre as Provincia, z.Nombre as Zona, l.Nombre as Localidad, c.Nombre as Cadena, pdv.Nombre as PuntoDeVenta, d.Objetivo as Objetivo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join Usuario u on u.idUsuario = d.idUsuario
			inner join Localidad l on l.idLocalidad = pdv.idLocalidad
			inner join Provincia p on p.idProvincia = l.idProvincia
			inner join Zona z on z.idZona = pdv.idZona
			inner join Cadena c on c.idCadena = pdv.idCadena
			where d.id between (('+cast(@NumeroDePagina as varchar)+' - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and ('+cast(@NumeroDePagina as varchar)+' * '+cast(@TamañoPagina as varchar)+')
		
		if('+cast(@NumeroDePagina as varchar)+'=0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario, p.Nombre as Provincia, z.Nombre as Zona, l.Nombre as Localidad, c.Nombre as Cadena, pdv.Nombre as PuntoDeVenta, d.Objetivo as Objetivo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join Usuario u on u.idUsuario = d.idUsuario
			inner join Localidad l on l.idLocalidad = pdv.idLocalidad
			inner join Provincia p on p.idProvincia = l.idProvincia
			inner join Zona z on z.idZona = pdv.idZona
			inner join Cadena c on c.idCadena = pdv.idCadena
			where id between ((@maxpag - 1) * '+cast(@TamañoPagina as varchar)+' + 1) and (@maxpag * '+cast(@TamañoPagina as varchar)+')
			
		if('+cast(@NumeroDePagina as varchar)+'<0)
			select u.Apellido+'', ''+u.Nombre collate database_default as Usuario, p.Nombre as Provincia, z.Nombre as Zona, l.Nombre as Localidad, c.Nombre as Cadena, pdv.Nombre as PuntoDeVenta, d.Objetivo as Objetivo,'+@PivotColumnHeaders+'
			from #DatosPivotFinal d
			inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.idPuntoDeVenta
			inner join Usuario u on u.idUsuario = d.idUsuario
			inner join Localidad l on l.idLocalidad = pdv.idLocalidad
			inner join Provincia p on p.idProvincia = l.idProvincia
			inner join Zona z on z.idZona = pdv.idZona
			inner join Cadena c on c.idCadena = pdv.idCadena

	'	

	EXEC sp_executesql @PivotTableSQL
end
go