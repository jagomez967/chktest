IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_Sha_Marca_Producto_Propio_T9'))
   exec('CREATE PROCEDURE [dbo].[Savant_Sha_Marca_Producto_Propio_T9] AS BEGIN SET NOCOUNT ON; END')
GO 
alter PROCEDURE [dbo].[Savant_Sha_Marca_Producto_Propio_T9] 
 
(  
 @IdCliente   int  
 ,@Filtros   FiltrosReporting readonly  
 ,@NumeroDePagina int = -1  
 ,@Lenguaje   varchar(10) = 'es'  
 ,@IdUsuarioConsulta int = 0  
 ,@TamañoPagina  int = 0  
)  
as  
begin  
 /*  
   
 Para filtrar en un query hacer:  
 ===============================  
 * (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))  
 * (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))  
  
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
  
 create table #Cantidad_Bandejas  
 (  
  idCantidad_Bandeja int  
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
 declare @cCantidad_Bandejas int = 0  
  
 insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''    
  
 insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''  
 set @cMarcas = @@ROWCOUNT  
  
 insert #Cantidad_Bandejas (idCantidad_Bandeja) select clave as idCantidad_Bandeja from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCantidad_Bandeja'),',') where isnull(clave,'')<>''  
 set @cCantidad_Bandejas = @@ROWCOUNT  
   
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
   

   
	
	declare @idEmpresa int 
	select @idEmpresa = idEmpresa from cliente where idCliente = @idCliente
	---NUEVO: Unificacion de filtros (Productos)
	
	if(@cProductos + @cMarcas + @cFamilia > 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
		
		set @cProductos = @cProductos + @cMarcas + @cFamilia
	END
	--Unificacion de filtros (Puntos de venta)
	
	if(@cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cVendedores > 0)
	BEGIN	
		insert #puntosdeventa(idPuntoDeVenta)
		select pdv.idPuntodeventa
		from puntodeventa pdv 
		where pdv.idCliente = @idCLiente
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE IdPuntoDeVenta = PDV.IdPuntoDeVenta))	
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))

		select @cPuntosDeVenta = @cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias  + @cVendedores 
	END
	--Fin Unificacion Filtros






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
  
 -------------------------------------------------------------------- END (Tablas de trabajo) ----------------------------------------------------------------  
  create table #tempReporte
	(
		idEmpresa int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(20),
		idReporte int,
		idZona int,
		idCadena int,
		fechaValor varchar(10)
	)


	INSERT #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, mes, idReporte)
	SELECT	r.idEmpresa,
			r.IdUsuario,
			r.IdPuntoDeVenta,
			convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes,
			max(r.idReporte)
	FROM reporte r
	WHERE	r.idEmpresa = @idEmpresa
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)		
   GROUP BY r.idEmpresa,
			r.IdUsuario,
			r.IdPuntoDeVenta,
			convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112)
	
	UPDATE t
	SET fechaValor = convert(varchar(10),CONVERT(date,r.FechaCreacion,106),103)
	FROM #tempReporte t 
	INNER JOIN reporte r on r.idReporte = t.idReporte 

	CREATE TABLE #datos
	(
		idEmpresa int,
		idReporte int,
		idProducto int,
		qty int,
		propio int,
		mes varchar(300),
		IdPuntoDeVenta int,
		idUsuario int,
		Cantidad int
	)

	INSERT #datos (idReporte,idEmpresa,idProducto, qty,propio,idPuntodeventa,idUsuario,Cantidad,mes)
	SELECT distinct r.idReporte,r.idEmpresa, rp.idProducto, isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0),1,
	r.IdPuntoDeVenta,r.idUsuario,rp.Cantidad,r.fechaValor	
	FROM #tempReporte r
    inner join ReporteProducto rp on rp.IdReporte = r.IdReporte
	WHERE (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = rp.IdProducto))
			

	INSERT #datos (idReporte,idEmpresa,idProducto, qty,propio,idPuntodeventa,idUsuario,Cantidad,mes)
	SELECT distinct r.idReporte,r.idEmpresa, rp.idProducto, (isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)),0,
	r.IdPuntoDeVenta,r.idUsuario,rp.Cantidad,r.fechaValor	
	FROM #tempReporte r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	left join ProductoCompetencia pc on pc.idproductocompetencia = rp.idproducto
	WHERE (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pc.IdProducto))
					
	CREATE TABLE #marcaCompetencia
	(idMarca int,
	idMarcaComp int,
	idProducto int )
	
	CREATE TABLE #totalShareMarca(idMarca int ,qty numeric(18,5),mes varchar(10),idPuntodeventa int,idProducto int)

	INSERT #marcaCompetencia(idMarca,idMarcaComp,idProducto)
	SELECT distinct ppropio.idMarca,p.idMarca,p.idProducto
	FROM #datos d
	inner join producto ppropio on ppropio.idProducto = d.idProducto 
	inner join ProductoCompetencia pc on pc.IdProducto = ppropio.idProducto 
	inner join producto p on p.idProducto = pc.IdProductoCompetencia 
	WHERE d.propio = 1

	INSERT #totalShareMarca(idMarca,qty,mes,idPuntodeventa)
	SELECT p.idMarca, sum(d.qty),d.mes,d.idPuntodeventa
	FROM #datos d
	inner join producto p on p.idProducto = d.idProducto 
	GROUP BY p.idMarca,d.mes,d.IdPuntoDeVenta

	CREATE TABLE #totalShareMarca2(idMarca int ,qty numeric(18,5),mes varchar(10),idPuntodeventa int,idProducto int)
	
	INSERT #totalShareMarca2(idMarca,qty,mes,idPuntodeventa,idProducto)
	SELECT p.idMarca, sum(d.qty),d.mes,d.idPuntodeventa,d.idProducto
	FROM #datos d
	inner join producto p on p.idProducto = d.idProducto
	GROUP BY p.idMarca,d.mes,d.IdPuntoDeVenta,d.idProducto
	
	CREATE TABLE #Resultados_Share
	(
		idPuntodeventa int,
		idProd int,
		qty numeric(18,5),
		qty_marca int,
		mes varchar(10),
		idMarca int
	)
	 
	INSERT #Resultados_Share (idPuntodeventa, idProd, qty, qty_marca,mes,idMarca)
	SELECT distinct d.idPuntodeventa,  d.idProducto, 
	isnull(d.qty,0) / (isnull(tm.qty,0) + isnull(x.total,0)),isnull(tm.qty,0)+ isnull(x.total,0),d.mes,p.idMarca
	FROM #datos d
	inner join producto p on p.idProducto = d.idProducto 
	inner join #totalShareMarca tm on tm.mes = d.mes and tm.idMarca = p.idMarca  and tm.idPuntodeventa = d.idPuntodeventa 
	inner join (select mc.idMarca,  sum(isnull(tc.qty,0))as total /*competencia*/,tc.mes,tc.idPuntodeventa 
	            from #marcaCompetencia mc 
				inner join #totalShareMarca2 tc on tc.idProducto = mc.idProducto
				group by mc.idMarca,tc.mes,tc.idPuntodeventa)
				x on x.mes = d.mes and x.idMarca = tm.idMarca and x.IdPuntoDeVenta = tm.idPuntodeventa											     
	WHERE isnull(tm.qty,0)+isnull(x.total,0) <> 0  	
	
	--tantas tablas temporales van a tener que hacer las conchas de la vaca puta??!!
	CREATE TABLE #Resultados_ShareComp
	(
		idPuntodeventa int,
		idProd int,
		qty numeric(18,5),
		qty_marca int,
		mes varchar(10),
		idMarca int,
		IdmarcaPropia int 
	)

	INSERT #Resultados_ShareComp (idPuntodeventa, idProd, qty, qty_marca,mes,idMarca,IdmarcaPropia)
	SELECT distinct s.idPuntodeventa, mc.idProducto, s.qty, s.qty_marca,s.mes,mc.idMarcaComp, s.idMarca 
	FROM #Resultados_Share s
	inner join #marcaCompetencia mc on mc.idMarca = s.idMarca
	UNION
	SELECT distinct idPuntodeventa, idProd, qty, qty_marca,mes,idMarca,idMarca 
	FROM #Resultados_Share 

	CREATE TABLE #Datos_Final
	(
	id int identity(1,1),
	Fecha varchar(12),
	Mes varchar(15),
	mesint int,
	Año varchar(12),
	Pais VARCHAR (20),
	IdPuntoDeVenta int,
	Share numeric(18,2),
	Frentes_Categoria int,
	FrenteSku int,
	idprod int,
	idUsuario int,
	diaint int
	)
		
	INSERT #Datos_Final (Fecha,Mes,Año,Pais,IdPuntoDeVenta,idUsuario,Share,Frentes_Categoria,FrenteSku,idProd,mesint,diaint)
	SELECT distinct d.mes, datename(mm,d.mes) as Mes, DATEPART(yy,d.mes) as Año,'Argentina' as Pais,
	d.IdPuntoDeVenta as IdPuntoDeVenta, d.idUsuario, isnull(d.Cantidad,0) / nullif(r.qty_marca *1.0,0) as Share,isnull(r.qty_marca,0) as 'Frentes_Categoria',
	(isnull(d.Cantidad,0)) as 'FrenteSku', 	d.idProducto,DATEPART(mm,d.mes),DATEPART(dd,d.mes)
	FROM #Resultados_ShareComp  r
	inner join #datos d on d.idProducto = r.idProd and d.idPuntodeventa = r.idPuntodeventa
	ORDER BY DATEPART(yy,d.mes) asc, DATEPART(mm,d.mes) asc,DATEPART(dd,d.mes)
	
		
	--Cantidad de páginas  
	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #Datos_Final
	select @maxpag

	 ----Configuracion de columnas  

	 create table #columnasConfiguracion  
	 (  
	  name varchar(50),  
	  title varchar(50),  
	  width int,
	  orden int    
	 )  
   
	 if(@lenguaje='es')  
	  insert #columnasConfiguracion (name, title, width,orden) values     
	 ('Fecha','Fecha',5,1),('Mes','Mes',10,2),('Año','Año',10,3)
			,('Pais','Pais',10,4),('Zona','Zona',10,5),('Cadena','Cadena',10,6)
			,('IdPuntoDeVenta','IdPuntoDeVenta',10,7),('CodigoCliente','CodigoCliente',10,8),('PuntoDeVenta','PuntoDeVenta',10,9),('Direccion','Direccion',10,10),
			('Equipo','Equipo',10,11),('RTM','RTM',10,12),('Familia','Familia',10,13),('Empresa','Empresa',10,14),('Producto','Producto',10,15),('Marca','Marca',10,16)
			,('Share','Share_Exhibicion',10,17),('Frentes_Categoria','Frentes_Categoria',10,18),('FrenteSku','FrenteSku',10,19)
	 if(@lenguaje='en')  
	  insert #columnasConfiguracion (name, title, width) values   
	  ('Fecha','Fecha',5,1),('Mes','Mes',10,2),('Año','Año',10,3)
			,('Pais','Pais',10,4),('Zona','Zona',10,5),('Cadena','Cadena',10,6)
			,('IdPuntoDeVenta','IdPuntoDeVenta',10,7),('CodigoCliente','CodigoCliente',10,8),('PuntoDeVenta','PuntoDeVenta',10,9),('Direccion','Direccion',10,10),
			('Equipo','Equipo',10,11),('RTM','RTM',10,12),('Familia','Familia',10,13),('Empresa','Empresa',10,14),('Producto','Producto',10,15),('Marca','Marca',10,16)
			,('Share','Share_Exhibicion',10,17),('Frentes_Categoria','Frentes_Categoria',10,18),('FrenteSku','FrenteSku',10,19)
    
	 select name, title, width from #columnasConfiguracion order by  orden,name  

	 ----Datos  
	 if(@NumeroDePagina>0)  
	  select d.Fecha,d.Mes,d.Año,d.Pais,z.nombre as Zona,cad.nombre as Cadena, d.IdPuntoDeVenta, pdv.CodigoAdicional as CodigoCliente,
	  pdv.nombre as PuntoDeVenta,pdv.Direccion as Direccion,eq.nombre as Equipo,u.apellido + ', '+ u.nombre collate database_default as RTM,
	  f.nombre as Familia,e.nombre as Empresa,p.nombre as Producto,m.nombre as Marca,
	  convert(varchar,d.Share)  +'%' as Share,d.Frentes_Categoria,d.FrenteSku
	  from #Datos_Final d 
	  inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.IdPuntoDeVenta
	  inner join zona z on z.idZona = pdv.idZona
	  inner join cadena cad on cad.idCadena = pdv.idCadena 
	  inner join PuntoDeVenta_Vendedor pdvv on pdvv.IdPuntoDeVenta = pdv.IdPuntoDeVenta 
	  inner join vendedor v on v.idVendedor = pdvv.idVendedor
	  inner join equipo eq on eq.idEquipo = v.idEquipo
	  inner join usuario u on u.idUsuario = d.idUsuario 
	  inner join producto p on p.idProducto = d.idprod
	  inner join marca m on m.idMarca = p.idMarca 
	  inner join familia f on f.idMarca = m.idMarca and p.idFamilia = f.IdFamilia
	  inner join empresa e on e.IdEmpresa = m.IdEmpresa 
	  where d.id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	order by d.id  
   
   
	 if(@NumeroDePagina=0)  
	  select d.Fecha,d.Mes,d.Año,d.Pais,z.nombre as Zona,cad.nombre as Cadena, d.IdPuntoDeVenta, pdv.CodigoAdicional as CodigoCliente,
	  pdv.nombre as PuntoDeVenta,pdv.Direccion as Direccion,eq.nombre as Equipo,u.apellido + ', '+ u.nombre collate database_default as RTM,
	  f.nombre as Familia,e.nombre as Empresa,p.nombre as Producto,m.nombre as Marca,
	  convert(varchar,d.Share)  +'%' as Share,d.Frentes_Categoria,d.FrenteSku
	  from #Datos_Final d 
	  inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.IdPuntoDeVenta
	  inner join zona z on z.idZona = pdv.idZona
	  inner join cadena cad on cad.idCadena = pdv.idCadena 
	  inner join PuntoDeVenta_Vendedor pdvv on pdvv.IdPuntoDeVenta = pdv.IdPuntoDeVenta 
	  inner join vendedor v on v.idVendedor = pdvv.idVendedor
	  inner join equipo eq on eq.idEquipo = v.idEquipo
	  inner join usuario u on u.idUsuario = d.idUsuario 
	  inner join producto p on p.idProducto = d.idprod
	  inner join marca m on m.idMarca = p.idMarca 
	  inner join familia f on f.idMarca = m.idMarca and p.idFamilia = f.IdFamilia
	  inner join empresa e on e.IdEmpresa = m.IdEmpresa 
	  where d.id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)  
	order by d.id  
   
	 if(@NumeroDePagina<0)  		
	 select d.Fecha,d.Mes,d.Año,d.Pais,z.nombre as Zona,cad.nombre as Cadena, d.IdPuntoDeVenta, pdv.CodigoAdicional as CodigoCliente,
	  pdv.nombre as PuntoDeVenta,pdv.Direccion as Direccion,eq.nombre as Equipo,u.apellido + ', '+ u.nombre collate database_default as RTM,
	  f.nombre as Familia,e.nombre as Empresa,p.nombre as Producto,m.nombre as Marca,
	  convert(varchar,d.Share)  +'%' as Share,d.Frentes_Categoria,d.FrenteSku
	  from #Datos_Final d 
	  inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.IdPuntoDeVenta
	  inner join zona z on z.idZona = pdv.idZona
	  inner join cadena cad on cad.idCadena = pdv.idCadena 
	  inner join PuntoDeVenta_Vendedor pdvv on pdvv.IdPuntoDeVenta = pdv.IdPuntoDeVenta 
	  inner join vendedor v on v.idVendedor = pdvv.idVendedor
	  inner join equipo eq on eq.idEquipo = v.idEquipo
	  inner join usuario u on u.idUsuario = d.idUsuario 
	  inner join producto p on p.idProducto = d.idprod
	  inner join marca m on m.idMarca = p.idMarca 
	  inner join familia f on f.idMarca = m.idMarca and p.idFamilia = f.IdFamilia
	  inner join empresa e on e.IdEmpresa = m.IdEmpresa 
	order by d.id  
   
end  

go
/*
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181101,20190131')
--insert into @p2 values(N'fltpuntosdeventa',N'21298')
---insert into @p2 values(N'fltusuarios',N'3915')
---insert into @p2 values(N'fltMarcas',N'817')

exec Savant_Sha_Marca_Producto_Propio_T9 @IdCliente=49,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'
*/

