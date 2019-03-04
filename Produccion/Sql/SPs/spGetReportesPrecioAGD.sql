 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spGetReportesPrecioAGD'))
    exec('CREATE PROCEDURE [dbo].[spGetReportesPrecioAGD] AS BEGIN SET NOCOUNT ON; END')
 Go
 alter procedure [dbo].[spGetReportesPrecioAGD]
 (
 	@IdCliente			int,
 	@nombreProducto varchar(200),
 	@fecha			varchar(20),
	@anio char(4) = '2018',
	@Filtros			FiltrosReporting readonly
 )
 AS
 BEGIN

 SET LANGUAGE spanish  
 set nocount on  
  
  
 declare @strFDesde varchar(30)  
 declare @strFHasta varchar(30)  
 declare @difDias int  
 declare @fechaDesdeAnterior varchar(30)  
 declare @fechaHastaAnterior varchar(30)  
  
 create table #fechaCreacionReporte  
 (  
  id int identity(1,1)  
  ,fecha varchar(10)  
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
  
 declare @cMarcas int = 0 
 declare @cProductos int = 0  
 declare @cCadenas int = 0  
 declare @cZonas int = 0  
 declare @cLocalidades int = 0  
 declare @cUsuarios int = 0  
 declare @cPuntosDeVenta int = 0  
 declare @cCompetenciaPrimaria int = 0  
 declare @cVendedores int = 0
 declare @cTipoRtm int = 0  
 declare @cProvincias int = 0  
 declare @cTags int = 0 
 declare @cFamilia int = 0  
 declare @cTipoPDV int = 0  
 declare @cClientes int = 0  
 declare @cCategoria int = 0  
  
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
  
  
	insert #cadenas(idCadena)
	select c.idCadena 
	from cadena c
	inner join empresa e on e.idNegocio = c.idNegocio
	inner join cliente cl on cl.idEmpresa = e.idEmpresa 
	inner join
	(select nombre from cadena 
	where idCadena in(select idCadena from #cadenas))cx 
	on cx.nombre = c.nombre
	where cl.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #cadenas where idCadena = c.idCadena)

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

	insert #TipoPDV(idTipo)
	select t.idTipo
	from tipo t
	inner join
	(select nombre from tipo
	where idTipo in (select idTipo from #TipoPDV))tx
	on tx.nombre = t.nombre
	where t.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #TipoPDV where idTipo = t.idTipo)


	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)


	insert #Marcas(idMarca)
	select m.idMarca 
	from marca m 
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join
	(select nombre from marca 
	where idMarca in(select idMarca from #marcas))mx 
	on mx.nombre = m.nombre
	where c.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #marcas where idMarca = m.idMarca)

	insert #productos(idProducto)
	select p.idProducto 
	from producto p
	inner join marca m on m.idMarca = p.idMarca
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join 
	(select nombre from producto
	where idProducto in(select idProducto from #productos))px
	on px.nombre = p.nombre 
	where c.idCliente in(select idCliente from #clientes)
	and not exists(select 1 from #productos where idProducto = p.idProducto)

	insert #familia(idFamilia)
	select f.idFamilia 
	from familia f 
	inner join marca m on m.idMarca = f.idMarca 
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join 
	(select nombre from familia 
	where idFamilia in(select idFamilia from #familia))fx
	on fx.nombre = f.nombre 
	where c.idCliente in(select idCliente from #clientes) 
	and not exists(select 1 from #familia where idFamilia = f.idFamilia) 

	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)
				
	---NUEVO: Unificacion de filtros (Productos)
	insert #productos(idProducto)
	select distinct p.idProducto 
	from producto p 
	where
	    (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
	AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
	AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
	
	set @cProductos = @cProductos + @cMarcas + @cFamilia

	--Unificacion de filtros (Puntos de venta)

	insert #puntosdeventa(idPuntoDeVenta)
	select pdv.idPuntodeventa
	from puntodeventa pdv 
	where pdv.idCliente in (select idCliente from #Clientes)
	AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
	AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE IdPuntoDeVenta = PDV.IdPuntoDeVenta))	
	AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
	AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))

	select @cPuntosDeVenta = @cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias
	--Fin Unificacion Filtros

	--Malisimo, refill de filtros con los unificados
	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)

	insert #productos(idProducto)
	select p.idProducto 
	from producto p
	inner join marca m on m.idMarca = p.idMarca
	inner join cliente c on c.idEmpresa = m.idEmpresa 
	inner join 
	(select nombre from producto
	where idProducto in(select idProducto from #productos))px
	on px.nombre = p.nombre 
	where c.idCliente in(select idCliente from #clientes)
	and not exists(select 1 from #productos where idProducto = p.idProducto)
	--end refill






	DECLARE @FechaDesde DATE
 	DECLARE @FechaHasta DATE 
 	DECLARE @idTipo int

	SET LANGUAGE SPANISH

	IF exists (select 1 from familiaClientes where idCliente = @idCliente and familia = 'AGD')
		SET @idCliente = 248

	IF CHARINDEX('- MAYORISTA',@nombreProducto) > 0
	BEGIN
		set @nombreProducto = REPLACE(@nombreProducto,'- MAYORISTA','')
		SET @idTipo = 372
	END
	IF CHARINDEX('- SUPERMERCADOS',@nombreProducto) > 0
	BEGIN
		set @nombreProducto = REPLACE(@nombreProducto,'- SUPERMERCADOS','')
		SET @idTipo = 377
	END
	
	

	IF CHARINDEX('Semana',@fecha) > 0
	BEGIN

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
 			@FechaDesde = DATEADD(DAY,-4,Fecha), --LUNES
 			@FechaHasta = DATEADD(DAY,1,Fecha)  -- SABADO , hay que ver cuando labura AGD
 		FROM
 			#Semanas
 		WHERE 
 			NroSemana = SUBSTRING(@fecha,CHARINDEX(' ',@fecha) + 1,LEN(@fecha))
	END
	ELSE
	BEGIN
		SELECT @FechaDesde = convert(date,@fecha,103)
		SELECT @FechaHasta = convert(date,@fecha,103)
	END

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
		and isnull(rp.precio,0) > 0
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))		 
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
			INNER JOIN ProductoCompetencia PC on PC.idProductoCompetencia = RPC.idProducto
		WHERE 
			C.idCliente = @idCliente 
			AND CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
			AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
			AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = pc.IdProducto))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))		 
			AND P.Nombre LIKE '%' + LTRIM(RTRIM(@nombreProducto)) + '%'
			AND isnull(RPC.precio,0) > 0	

 END
 GO