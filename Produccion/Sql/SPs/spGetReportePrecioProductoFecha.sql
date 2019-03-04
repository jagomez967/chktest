 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spGetReportePrecioProductoFecha'))
    exec('CREATE PROCEDURE [dbo].[spGetReportePrecioProductoFecha] AS BEGIN SET NOCOUNT ON; END')
 Go
 alter procedure [dbo].[spGetReportePrecioProductoFecha]
 (
 	@IdCliente			int,
 	@nombreProducto varchar(200),
 	@fecha			varchar(20),
	@precio			varchar(100),
	@TipoPrecio		INT = 1,
	@anio char(4) = '2018',
	@Filtros FiltrosReporting readonly				
 )
 AS
 BEGIN
	if(CHARINDEX('- MAYORISTA',@nombreProducto) > 0 or CHARINDEX('- SUPERMERCADOS',@nombreProducto) > 0)
	BEGIN		
		exec spGetReportesPrecioAGD @IdCliente = @IdCliente, @nombreProducto = @nombreProducto, @fecha = @fecha, @anio = @anio,@Filtros = @Filtros
		return;
	END



	select @nombreProducto = replace(@nombreProducto,'Accionado','')
	IF (SELECT 1 WHERE @fecha LIKE '%Semana%') = 1 BEGIN
 		DECLARE @FechaDesde DATE
 		DECLARE @FechaHasta DATE

 		SET LANGUAGE SPANISH

 		;WITH DateTable
 		AS
 		(
 			SELECT CONVERT(DATE,cast(@anio as char(4)) + '0101') Fecha
 			UNION ALL
 			SELECT DATEADD(DAY, 1, Fecha)
 			FROM DateTable
 			WHERE DATEADD(DAY, 1, Fecha) < CONVERT(DATE,cast(@anio as char(4))+ '1231')
 		)SELECT 
 			Fecha,
 			DATENAME(WEEKDAY,Fecha) Dia,
 			ROW_NUMBER() OVER (ORDER BY Fecha) NroSemana
 		INTO
 			#Semanas
 		FROM 
 			DateTable
 		WHERE 
 			DATENAME(WEEKDAY,Fecha) = 'Viernes' 
 		OPTION 
 			(MAXRECURSION 730)
 
 		SELECT 
 			@FechaDesde = DATEADD(DAY,-4,Fecha),
 			@FechaHasta = Fecha
 		FROM
 			#Semanas
 		WHERE 
 			NroSemana = SUBSTRING(@fecha,CHARINDEX(' ',@fecha) + 1,LEN(@fecha))
 
 		select r.idReporte as idreporte, pdv.nombre as puntodeventa, u.apellido +', '+u.nombre collate database_default as usuario
 		from reporte r
 		inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
 		inner join cliente c on c.idEmpresa = r.idEmpresa
 		inner join usuario u on u.idUsuario = r.idUsuario
 		inner join reporteProducto rp on rp.idReporte = r.idReporte
 		inner join producto p on p.idProducto = rp.idProducto
 		where
 		c.idCliente = @idCliente 
 		and p.nombre like '%'+ltrim(rtrim(@nombreProducto))+'%'
		and cast(@precio as NUMERIC(18,2)) = CASE WHEN @TipoPrecio = 1 THEN cast(rp.precio as NUMERIC(18,2)) ELSE cast(rp.precio2 as NUMERIC(18,2)) END 
 		and convert(date,r.fechaCreacion) >= @FechaDesde
 		and convert(date,r.fechaCreacion) <= @FechaHasta
		UNION
		SELECT 
			R.idReporte,
			PDV.Nombre,
			U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT
		FROM 
			Reporte R 
			INNER JOIN ReporteProductoCompetencia RPC ON R.idReporte = RPC.idReporte
			INNER JOIN Producto P ON RPC.idProducto = P.idProducto
			INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
			INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
			INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
		WHERE 
			C.idCliente = @idCliente 
			AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
			AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
			AND P.Nombre LIKE '%' + LTRIM(RTRIM(@nombreProducto)) + '%'
			AND ISNULL(RPC.Precio,0) = @precio
		
 		DROP TABLE #Semanas
 	END
 	ELSE BEGIN
 
 		select r.idReporte as idreporte, pdv.nombre as puntodeventa, u.apellido +', '+u.nombre collate database_default as usuario
 		from reporte r
 		inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
 		inner join cliente c on c.idEmpresa = r.idEmpresa
 		inner join usuario u on u.idUsuario = r.idUsuario
 		inner join reporteProducto rp on rp.idReporte = r.idReporte
 		inner join producto p on p.idProducto = rp.idProducto
 		where
 		c.idCliente = @idCliente 
 		and p.nombre like '%'+ltrim(rtrim(@nombreProducto))+'%'
 		and cast(cast(rp.precio as NUMERIC(18,2))as int) = cast(cast(@precio as NUMERIC(18,2)) as int)
 		and convert(date,r.fechaCreacion) = convert(date,@fecha,103)
 	END
 END
 go
