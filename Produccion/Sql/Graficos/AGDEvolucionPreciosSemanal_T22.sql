IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.AGDEvolucionPreciosSemanal_T22'))
   exec('CREATE PROCEDURE [dbo].[AGDEvolucionPreciosSemanal_T22] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[AGDEvolucionPreciosSemanal_T22]
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
-- if @lenguaje = 'en' set language english  
  
 declare @strFDesde varchar(30)  
 declare @strFHasta varchar(30)  
 declare @fechaDesde datetime  
 declare @fechaHasta datetime  
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
  
  create table #competencia(fecha date,idProducto int,idProductoCompetencia int,precio decimal (11,2),idTipo int,reportes int)

  insert #competencia (fecha,idProducto,idProductoCompetencia, precio,idTipo,reportes)
  select 		
	    r.FechaCreacion,
		pc.idProducto,
		rp.IdProducto,
		 AVG(
		CASE 
			WHEN isnull(rp.Precio,0) !=0 and isnull(rp.cantidad,0) != 0 and isnull(rp.Precio,0) > isnull(rp.cantidad,0) 
				THEN rp.cantidad
			WHEN isnull(rp.Precio,0) != 0 and isnull(rp.cantidad,0) != 0 and isnull(rp.cantidad,0) > isnull(rp.cantidad,0)
				THEN rp.precio 
			WHEN isnull(rp.Precio,0) != 0 and isnull(rp.cantidad,0) = 0 
				THEN rp.precio
			when isnull(rp.cantidad,0) != 0 and isnull(rp.cantidad,0) = 0
				THEN rp.cantidad
			ELSE
				null  ---ESTO DA ERROR, pero no deberia, ya que la segunda condicion en el where me deberia evitar este caso 
			END),
		pdv.idTipo,
		count(distinct r.idReporte)
	from reporte r
	inner join reporteProductoCompetencia rp on rp.idReporte = r.idReporte
	inner join cliente c on c.idEmpresa = r.idEmpresa
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	inner join ProductoCompetencia pc on pc.IdProductoCompetencia = rp.idProducto
	where c.idCliente = 248
		and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = pc.IdProducto))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(rp.Precio,0) > 0 or isnull(rp.Cantidad,0) > 0) 
	group by r.FechaCreacion,pc.idProducto,rp.idProducto,pdv.idTipo

 
	create table #tempProducto(fecha date,idProducto int,precio decimal (18,2),idTipo int,reportes int)

	insert #tempProducto(fecha,idProducto,precio,idTipo,reportes)
	select
		r.fechaCreacion,
		rp.idProducto,
		 AVG(
		CASE 
			WHEN isnull(rp.Precio,0) !=0 and isnull(rp.Precio2,0) != 0 and isnull(rp.Precio,0) > isnull(rp.Precio2,0) 
				THEN rp.Precio2
			WHEN isnull(rp.Precio,0) != 0 and isnull(rp.Precio2,0) != 0 and isnull(rp.Precio2,0) > isnull(rp.Precio2,0)
				THEN rp.precio 
			WHEN isnull(rp.Precio,0) != 0 and isnull(rp.Precio2,0) = 0 
				THEN rp.precio
			when isnull(rp.Precio2,0) != 0 and isnull(rp.precio,0) = 0
				THEN rp.precio2
			ELSE
				null  ---ESTO DA ERROR, pero no deberia, ya que la segunda condicion en el where me deberia evitar este caso 
			END),
		pdv.idTipo,
		count(distinct r.idreporte)
	from reporte r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join cliente c on c.idEmpresa = r.idEmpresa
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	where c.idCliente = 248
		and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = rp.IdProducto))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(rp.Precio,0) > 0 or isnull(rp.precio2,0) > 0) 
	group by r.fechaCreacion,rp.idProducto,pdv.idTipo


	create table #datosFinal(idPRoducto int, producto varchar(max), fecha int, valorFecha varchar(max),
					         valor decimal(11,2), color varchar(max), dashStyle varchar(max), linkedTo int, orden int, reportes int)

	insert #datosFinal(idPRoducto,producto,fecha,valorFecha,valor,color,dashStyle,linkedTo,orden,reportes)
	select p.idProducto  * 1000 + t.idTipo as idPRoducto, p.nombre + ' - ' + t.Nombre collate database_default as producto,
    cast(CONVERT(VARCHAR(10), c.fecha, 112)as int),
	CONVERT(VARCHAR(10), c.fecha, 103) as valorFecha, c.precio as valor,
		m.sColor as color, 
		case when t.nombre = 'SUPERMERCADOS' then 'solid'
			 when t.nombre = 'MAYORISTA' then 'shortdot'
			 else 'longdash'
		end as dashStyle,
	    c.idProducto as linkedTo,		
		p.orden,
		c.reportes 
	from #Competencia c
	inner join producto p on p.idProducto = c.idProductoCompetencia
	inner join marca m on m.idMarca = p.idMarca 
	inner join tipo t on t.idTipo = c.idTipo
	union
	select p.idProducto * 1000 + t.idTipo as idPRoducto, p.nombre + ' - ' + t.Nombre collate database_default as producto,
	cast(CONVERT(VARCHAR(10), c.fecha, 112)as int),
	CONVERT(VARCHAR(10), c.fecha, 103) as valorFecha, c.precio as valor,
		m.sColor as color, 
		case when t.nombre = 'SUPERMERCADOS' then 'solid'
			 when t.nombre = 'MAYORISTA' then 'shortdot'
			 else 'longdash'
		end as dashStyle,
	    c.idProducto as linkedTo,		
		p.orden,
		c.reportes 
	from #tempPRoducto c
	inner join producto p on p.idProducto = c.idProducto
	inner join marca m on m.idMarca = p.idMarca 
	inner join tipo t on t.idTipo = c.idTipo


	create table #configuracion(xTitulo varchar(100), yTitulo varchar(100))
	
	insert #configuracion(xTitulo,yTitulo)
	values('Producto','Precio $')
	
	
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int,
		fecha int,
		semana varchar(100)
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,semana)
	select idProducto,valor,count(valor),CONVERT(VARCHAR,DATEPART(WEEK,CONVERT(VARCHAR,valorFecha,112)))
	from  #datosFinal
	group by idProducto,valor,CONVERT(VARCHAR,DATEPART(WEEK,CONVERT(VARCHAR,valorFecha,112)))

	
	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idproducto = p.idProducto and cantidad > p.cantidad and  p.semana = semana)
	

	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idProducto = p.idProducto and precio > p.precio  and  p.semana = semana)
	

	
	select d.idPRoducto,d.producto,
	
	convert(varchar(10),dateadd(day,-1,dateadd(week,cast(p.semana as int)-1, DATEADD(wk, DATEDIFF(wk,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)), 0))),112) as fecha,
	convert(varchar(10),dateadd(day,-1,dateadd(week,cast(p.semana as int)-1, DATEADD(wk, DATEDIFF(wk,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)), 0))),112) as valorFecha,
	p.precio as valor,d.color,d.dashStyle,d.linkedTo,d.orden,--sum(d.reportes) as reportes,
	'Semana ' + ltrim(rtrim(p.semana))	 as Cat
	from #datosFinal d
	inner join #preciosPorProducto p
		on p.idProducto = d.idproducto
		and p.Semana = CONVERT(VARCHAR,DATEPART(WEEK,CONVERT(VARCHAR,d.valorFecha,112)))
	group by d.idPRoducto,d.producto,
	convert(varchar(10),dateadd(day,-1,dateadd(week,cast(p.semana as int)-1, DATEADD(wk, DATEDIFF(wk,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)), 0))),112),
	convert(varchar(10),dateadd(day,-1,dateadd(week,cast(p.semana as int)-1, DATEADD(wk, DATEDIFF(wk,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)), 0))),112),
	p.precio,d.color,d.dashStyle,d.linkedTo,d.orden,'Semana ' + ltrim(rtrim(p.semana))	
	 

	select ''inicio,''fin,''color,''label where 1 = 2 

	select ''valor,''color,''estilo,''grosor,''[text],''align,''x,''colorLabel,''fontWeight,''fontSize	
	where 1 = 2

	select xTitulo,yTitulo from #configuracion 

	---------------------------------------------------------------------------------------------------------------------------------
end
go


