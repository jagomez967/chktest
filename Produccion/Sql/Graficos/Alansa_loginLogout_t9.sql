IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Alcansa_LoginLogut_T9'))
   exec('CREATE PROCEDURE [dbo].[Alcansa_LoginLogut_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Alcansa_LoginLogut_T9]
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
--	if @lenguaje = 'en' set language english LO TENGO QUE SACAR PORQUE EN INGLES NO VA A FUNCIONAR CON ESTA LOGICA

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #datos_pre
	(
		id int identity(1,1),
		usuario varchar(300),
		operacion varchar(100),
		fecha datetime,
		hora varchar(1000),
		idOperacion int
	)
	
	create table #datos
	(
		id int identity(1,1),
		usuario varchar(300),
		operacion varchar(100),
		fecha datetime,
		hora varchar(1000)
	)

	insert #datos_pre (usuario, operacion, fecha, hora,idOperacion)
	select	ltrim(rtrim(u.apellido)) + ', ' + ltrim(rtrim(u.nombre)) collate database_default
			,ltrim(rtrim(o.Descripcion))
			,
			ou.fecha,
			'<a href="https:/'+'/www.google.com.ar/maps/place/'+
			convert(varchar(20),ou.latitud) + ',' +
			convert(varchar(20),ou.longitud) + '/@' +
			convert(varchar(20),ou.latitud) + ',' +
			convert(varchar(20),ou.longitud) + ',' + '17z' --NIVEL DE ZOOM
			+ '" target="popup" onClick ="window.open(this.href, this.target, ''width=800,height=600''); return false;" style="text-indent:0">' +
			--convert(char(10),ou.Fecha,103)
			+'<u style="color:blue">'
			+ RIGHT(CONVERT(CHAR(20), ou.fecha, 22), 11)
			+'</u>'
			+'</a>' collate database_default,
			o.idOperacion
	from operacion_usuario ou
	inner join operacion o on o.idOperacion = ou.idOperacion
	inner join usuario u on u.idusuario = ou.idusuario
	inner join usuario_cliente cu on cu.idusuario=ou.idusuario
	where	cu.idcliente=@idcliente
			and convert(date,ou.fecha) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = u.IdUsuario)) and isnull(u.esCheckPos,0) = 0


	insert #datos(usuario, operacion, fecha, hora)
	select usuario,operacion,min(fecha) as fec,hora 
	from #datos_pre 
	where idOperacion = 1 --login
	group by usuario, operacion, hora
	union all
	select usuario,operacion,max(fecha) as fec,hora
	from #datos_pre
	where idOperacion = 2 --logout
	group by usuario, operacion, hora
	order by usuario, fec asc
	
	drop table #datos_pre

	--Cantidad de páginas
	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datos

	select @maxpag
	
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('usuario','Usuario',5),('operacion','Operación',5)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('usuario','User',5),('operacion','Operation',5)
	
	insert #columnasConfiguracion (name,title, width)
	select cast(datename(month, fecha)+cast(day(fecha) as varchar) + cast(year(fecha) as varchar) as varchar) as name 
		   ,cast(cast(day(fecha) as varchar) + ' ' + datename(month, fecha)+' '+cast(year(fecha) as varchar) as varchar) as title
			,5 as width
    from (select distinct convert(varchar,fecha,103)as fecha from #datos)x
	order by x.fecha

	--MODO VILLERO ON
	if @lenguaje = 'en'
	BEGIN
		update #columnasConfiguracion
		set title = REPLACE(title,'Enero','January')
		where title like '%Enero%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Febrero','February')
		where title like '%Febrero%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Marzo','March')
		where title like '%Marzo%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Abril','April')
		where title like '%Abril%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Mayo','May')
		where title like '%Mayo%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Junio','June')
		where title like '%Junio%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Julio','July')
		where title like '%Julio%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Agosto','August')
		where title like '%Agosto%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Septiembre','September')
		where title like '%Septiembre%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Octubre','October')
		where title like '%Octubre%'

		update #columnasConfiguracion
		set title = REPLACE(title,'Noviembre','November')
		where title like '%Noviembre%'
		
		update #columnasConfiguracion
		set title = REPLACE(title,'Diciembre','December')
		where title like '%Diciembre%'
	END
	select name, title, width from #columnasConfiguracion


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
		@PivotColumnHeaders + ',[' +  datename(month, fecha)+cast(cast(day(fecha) as varchar) +cast(year(fecha) as varchar) as varchar) + ']', 
		   '[' + cast( datename(month, fecha)+cast(day(fecha) as varchar) +cast(year(fecha) as varchar) as varchar) + ']'
		)
    from (select distinct convert(varchar,fecha,103)as fecha from #datos)x
	order by x.fecha



	DECLARE @ColDef VARCHAR(MAX)
	SELECT @ColDef = 
	  COALESCE(
		@ColDef + ',' + cast(datename(month, fecha)+ cast(day(fecha) as varchar) +cast(year(fecha) as varchar) as varchar) + ' varchar(max)',
		cast(datename(month, fecha)+ cast(day(fecha) as varchar) +cast(year(fecha) as varchar) as varchar) + ' varchar(max)'
	  )
	from (select distinct convert(varchar,fecha,103)as fecha from #datos)x
	order by x.fecha
	

	DECLARE @PivotTableSQL NVARCHAR(MAX)
	SET @PivotTableSQL = N'
	  CREATE TABLE #tablaPivot 
	  ( id int identity(1,1),
	    usuario varchar(300),
		operacion varchar(100),
		'+ @ColDef +'
	  )

	  insert #tablaPivot (usuario,operacion,'+@PivotColumnHeaders+')
	  SELECT [usuario],[operacion],'+@PivotColumnHeaders+'
	  FROM (
		SELECT
		  usuario as usuario,
		  operacion as operacion,
		  cast( datename(month, fecha)+cast(day(fecha) as varchar) + cast(year(fecha) as varchar) as varchar) as dia,
		  hora as hora
		FROM #Datos 

		) AS PivotData
	  PIVOT (
		max(hora)
		FOR dia IN (
		  ' + @PivotColumnHeaders + ')
		) AS PivotTable
	
	select [usuario],[operacion],'+@PivotColumnHeaders+'
	from #tablaPivot
	 '+ @PivotWhere 

	EXECUTE(@PivotTableSQL)

end

go
