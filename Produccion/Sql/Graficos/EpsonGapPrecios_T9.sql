IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonGapPrecios_T9'))
   exec('CREATE PROCEDURE [dbo].[EpsonGapPrecios_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EpsonGapPrecios_T9]
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
	declare @difDias int
	declare @fechaDesdeAnterior varchar(30)
	declare @fechaHastaAnterior varchar(30)

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

	create table #marcasEpson
	(
		idMarcaEpson int
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
	declare @cMarcasEpson varchar(max)

	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		

	insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	set @cMarcas = @@ROWCOUNT
	
	insert #marcasEpson (idmarcaEpson) select clave as idmarcaEpson from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcasEpson'),',') where isnull(clave,'')<>''
	set @cMarcasEpson = @@ROWCOUNT
	
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

	insert #MarcasEpson(idMarcaEpson)
	select m.idSubMarca
	from SubMarca m
	inner join
	(select nombre from SubMarca
	where idSubMarca in (select idMarcaEpson from #MarcasEpson))me
	on me.nombre = m.nombre
	--Traigo todos, total siempre va a ser EPSON
	where not exists (select 1 from #MarcasEpson where idMarcaEpson = m.idSubMarca)
	--Mentira
	and m.idMarca in (select mar.idMarca
						from marca mar
						inner join cliente c on c.idEmpresa = mar.idEmpresa
						and c.idCliente in(select idCliente from #clientes)
					)

	insert #productos(idProducto)
	select p.idProducto 
	from producto p
	inner join
	(select nombre from producto
	where idProducto in (select idProducto from #Productos))prx
	on prx.nombre = p.nombre
	where p.idMarca in(select m.idMarca
						from marca m 
						where idEmpresa in (
							select e.idEmpresa 
							from #clientes c 
							inner join cliente e on e.idCliente = c.idCliente)
						)
	and not exists (select 1 from #Productos where idproducto = p.idProducto)
	and p.reporte = 1 

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
		idCliente int,
		idUsuario int,
		IdReporte int,
		IdPuntodeventa int,
		idProducto int,
		precio decimal(18,3),
		idCadena int
	)


	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	if (isnull(@cFamilia,0) = 0) --SOLO EPSON ARGENTINA POR AHORA, agregar las futuras familias
	begin
		insert #familia(idFamilia)
		select f.idFamilia 
		from familia f 
		inner join marca m on m.idMarca = f.idMarca
		inner join cliente c on c.idEmpresa = m.idEmpresa
		and f.nombre like '%CISS%'
		and c.idCliente = @idCliente 		
		select @cFamilia = @@rowcount
	End

	declare @cantidadCliente int
	select @cantidadCliente = count(idCliente) from #clientes

	
	if (@cantidadCliente = 1) 
	BEGIN
		insert #tempReporte (idCliente, idUsuario, IdReporte,IdPuntodeventa,IdProducto,precio,idCadena)
		select	c.IdCliente
				,r.IdUsuario
				,r.IdReporte
				,r.idPuntodeventa
				,rp.idProducto
				,rp.Precio
				,p.idCadena
		from reporte r
		inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
		inner join Cliente c on c.idempresa = r.idempresa
		inner join reporteProducto rp on rp.idReporte = r.idReporte
		inner join producto prod on prod.idProducto = rp.idProducto
		where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
				and c.idCliente in (select idCliente from #clientes)
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
				--and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = prod.idProducto))
				and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = prod.idFamilia))
				and (isnull(@cMarcasEpson,0) = 0 or exists(select 1 from #marcasEpson where idMarcaEpson in (select idSubMarca from SubMarca_Producto
				where idProducto = prod.idProducto)))
				and rp.precio <> 0.0
				and prod.reporte = 1
				--Oculto Consumibles
				and prod.idMarca != 2905
	END
	ELSE
	BEGIN
		insert #tempReporte (idCliente, idUsuario, IdReporte,IdPuntodeventa,IdProducto,precio,idCadena)
		select	c.IdCliente
				,r.IdUsuario
				,r.IdReporte
				,r.idPuntodeventa
				,rp.idProducto
				,rp.Precio/ cur.value
				,p.idCadena
		from reporte r
		inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
		inner join Cliente c on c.idempresa = r.idempresa
		inner join reporteProducto rp on rp.idReporte = r.idReporte
		inner join producto prod on prod.idProducto = rp.idProducto
		inner join CurrencyExchange cur on cur.CurLocal = c.localCurrency and cur.date = convert(date,r.fechaCreacion)
		where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
				and c.idCliente in (select idCliente from #clientes)
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
				--and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = prod.idProducto))
				and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = prod.idFamilia))
				and (isnull(@cMarcasEpson,0) = 0 or exists(select 1 from #marcasEpson where idMarcaEpson in (select idSubMarca from SubMarca_producto 
				where idProducto = prod.idProducto)))
				and rp.precio <> 0.0
				--Oculto Consumibles
				and prod.idMarca != 2905
	END

	--CALCULO MODA
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad)
	select idProducto,precio,count(precio)
	from  #tempReporte 
	group by idProducto,precio


		delete p from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto 
				where idProducto = p.idProducto
				and idCadena = p.idCadena
				and cantidad > p.cantidad)

	delete p from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto 
				where idProducto = p.idProducto
				and idCadena = p.idCadena
				and precio > p.precio)
	

	

	--FIN MODA	
	create table #datosFinal
	(idFamilia int,
	 idProducto int,
	 maxPrecio decimal(18,3),
	 idProductoCompetencia int,
	 maxPrecioCompetencia decimal(18,3)
	 )


	 insert #datosFinal (idFamilia,idProducto,maxPrecio,idProductoCompetencia)
	 select p.IdFamilia, pp.idProducto, max(pp.precio),ec.idProductoCompetencia
	 from #preciosPorProducto pp
	 inner join producto p on p.idProducto = pp.idProducto	 
	 left join ProductoCompetencia ec on ec.idProducto = pp.idProducto
	 where pp.idProducto in (select smp.idProducto from SubMarca s 
								inner join subMarca_Producto smp 
									on smp.idSubmarca = s.idSubMarca 
								where s.idSubMarca = 100)
	 and ec.reporte = 1
	 
	 group by p.idFamilia,pp.idProducto,ec.idProductoCompetencia

	 update d
	 set maxPrecioCompetencia = pp.precio
	 from #datosFinal d
	 inner join #preciosPorProducto pp
	 on d.idProductoCompetencia = pp.idProducto	 
	 where not exists (select 1 from #PreciosPorProducto where idProducto = pp.idProducto and pp.precio < precio)

	select 1
	
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esAgrupador bit,
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)

		
	
	if(@cantidadCliente = 1)
	BEGIN																							
		insert #columnasConfiguracion (esAgrupador,esclave,mostrar,name, title, width) 
		values				
			(0,0,1,'precio','Price',5),
			(0,0,1,'producto','Product',5),
			(0,0,1,'gap','Gap',5),
			(0,0,1,'precioCompetencia','Competitor Price',5),	
			(0,0,1,'productoCompetencia','Competitor',5)
			
		select mostrar,name, title, width from #columnasConfiguracion
		
		select 
		       p.nombre as producto,			  			   
			   '$ ' + ltrim(rtrim(str(d.maxPrecio,18,2))) as precio,
			   p2.nombre as productoCompetencia,
			   '$ ' + ltrim(rtrim(str(d.maxPrecioCompetencia,18,2))) as precioCompetencia,
			   case when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 > 40.0 then
					'<img src="images/circuloRojo.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 < -10.0 then
					'<img src="images/circuloRojo.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between -10.0 and -7.0  then  
					'<img src="images/circuloNaranja.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between 30 and 40  then  
					'<img src="images/circuloNaranja.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between -7.0 and 0  then  
					'<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between 20 and 30  then  
					'<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
					else '<img src="images/circuloVerde.png" width="16" height="16"/>' 
				end				 			  
				+ '  ' +
			   ltrim(rtrim(str(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,18,2)))+'%' 			  
			   as gap,
			   case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end
						as ordenMath
		from #datosFinal d 
		inner join familia f on f.idFamilia = d.idFamilia
		inner join producto p on p.idProducto = d.idProducto
		inner join producto p2 on p2.idProducto = d.idProductoCompetencia
				where (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.idProducto))
				and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
				--Oculto Consumibles
					and p.idMarca != 2905
					and p2.idMarca != 2905
		order by isnull(case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end,200) asc
					
	END
	ELSE
	BEGIN																							
		insert #columnasConfiguracion (esAgrupador,esclave,mostrar,name, title, width) 
		values				
		(0,0,1,'cliente','Country',5),			
			(0,0,1,'producto','Product',5),
			(0,0,1,'gap','Gap',5),
			(0,0,1,'precio','Price',5),	
			(0,0,1,'productoCompetencia','Competitor',5),
			(0,0,1,'precioCompetencia','Competitor Price',5)
			
		select mostrar,name, title, width from #columnasConfiguracion
		
		select 
		       p.nombre as producto,			  			   
			   '$ ' + ltrim(rtrim(str(d.maxPrecio,18,2))) as precio,
			   p2.nombre as productoCompetencia,
			   '$ ' + ltrim(rtrim(str(d.maxPrecioCompetencia,18,2))) as precioCompetencia,
			   case when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 > 40.0 then
					'<img src="images/circuloRojo.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 < -10.0 then
					'<img src="images/circuloRojo.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between -10.0 and -7.0  then  
					'<img src="images/circuloNaranja.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between 30 and 40  then  
					'<img src="images/circuloNaranja.png" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between -7.0 and 0  then  
					'<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
					when ((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100 between 20 and 30  then  
					'<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
					else '<img src="images/circuloVerde.png" width="16" height="16"/>'

				end				 			  
				+ '  ' +
			   ltrim(rtrim(str(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,18,2)))+'%' 			  
			   as gap,
			   case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end
						as ordenMath,
											c.nombre as cliente 
		from #datosFinal d 
		inner join familia f on f.idFamilia = d.idFamilia
		inner join producto p on p.idProducto = d.idProducto
		inner join producto p2 on p2.idProducto = d.idProductoCompetencia
		inner join marca m on m.idMarca = p.idMarca 
		inner join cliente c on c.idEmpresa = m.idEmpresa
				where (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.idProducto))
				and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
				--Oculto Consumibles
				and p.idMarca != 2905
				and p2.idMarca != 2905
		order by isnull(case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end,200) asc
					

	END
		

end

go

[EpsonGapPrecios_T9] 196

--select * from producto where nombre like '%Epson - L380%'
--11807







