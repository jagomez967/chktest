IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonSellOutDetail_t9'))
   exec('CREATE PROCEDURE [dbo].[EpsonSellOutDetail_t9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[EpsonSellOutDetail_t9]
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
	create table #MarcaPropiedad
	(
		idMarcaPropiedad int
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
	declare @cMarcaPropiedad varchar(max)

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

	insert #MarcaPropiedad (IdMarcaPropiedad) select clave as idMarcaPropiedad from dbo.fnSplitString((select valores from @Filtros where IdFiltro = 'fltMarcaPropiedad'),',') where isnull(clave,'')<>''
	set @cMarcaPropiedad = @@ROWCOUNT
	
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

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idCadena int
	)


	create table #diferencia
	(
		idPuntodeventa int,
		idProducto int,
		ventas int,
		objetivo int,
		idCadena int, --VIENE DE PUNTO DE VENTA
		idEmpresa int
	)

	create table #datos
	(
		id int identity(1,1),
		diferencia decimal(10,2),
		nombreCadena varchar(max),
		idCadena int,
		idEmpresa int,
		VolumenObjetivo int
	)

	create table #datosFinal_agrupados
	(
		id int identity(1,1),
		pais varchar(max),
	--	cadena varchar(max),
		producto varchar(max),
		ventasVolumen int,
		objetivoVolumen int,
		precioUnitario decimal(10,2),
		objetivoVentas decimal(18,2),
		cumplimientoVolumen decimal(8,2),
		cumplimientoPrecio decimal(8,2)
	)
	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte,idCadena)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), r.idreporte,p.idCadena
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente = @IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))

	insert #diferencia
	(
		idPuntodeventa,
		idProducto,
		ventas,
		objetivo,
		idCadena, --VIENE DE PUNTO DE VENTA
		idEmpresa
	)
	select r.idPuntodeventa,rp.idProducto,tvo.ventas,tvo.objetivo,r.idCadena,r.idEmpresa
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join Epson_RetailerSellout tvo 
	on tvo.idReporte = r.idReporte and tvo.idProducto = rp.idProducto
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = rp.idProducto))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #Cadenas where idCadena = r.idCadena))

		create table #datosFinal
	(
		id int identity(1,1),
		pais varchar(max),
		cadena varchar(max),
		producto varchar(max),
		ventasVolumen int,
		objetivoVolumen int,
		precioUnitario decimal(10,2),
		objetivoVentas decimal(18,2),
		cumplimientoVolumen decimal(10,6),
		cumplimientoPrecio decimal(10,6)
	)

	declare @totalActual int 
	declare @totalObjetivo int

	select @totalActual = sum(isnull(ventas,0)) from #diferencia
	select @totalObjetivo = sum(isnull(objetivo,0)) from #diferencia


	insert #datosFinal (pais,cadena,producto,ventasVolumen,
						objetivoVolumen,precioUnitario,objetivoVentas,
						cumplimientoVolumen,cumplimientoPrecio)
	select 'Argentina',
		   cad.nombre,
		   prod.nombre,
		   dif.ventas,
		   dif.objetivo,
		   pu.precio,
		   pu.precio * dif.objetivo,
		   (dif.ventas * 100.0) / @TotalActual * 1.0,
		   (dif.Objetivo *100.0 )/ @TotalObjetivo * 1.0
	from #diferencia dif
	left join epson_preciosProductos pu
	on pu.idProducto = dif.idProducto
	left join cadena cad
	on cad.idCadena = dif.idCadena
	left join producto prod
	on prod.idProducto = dif.idProducto 


--	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = ru.idProducto))
--	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #Cadenas where idCadena = ru.idCadena))


--select sum(cumplimientoPrecio),sum(cumplimientoVolumen) from #datosFinal
		create table #columnasConfiguracion
		(
			name varchar(50),
			title varchar(50),
			width int
		)
	declare @maxpag int

	if exists(select 1 from #Cadenas) 
	BEGIN

		if(@TamañoPagina=0)
			set @maxpag=1
		else
			select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal
		select @maxpag



		if(@lenguaje = 'es')
			insert #columnasConfiguracion (name, title, width)
			values 
			 ('pais','Pais',10),
			 ('cadena','Retail',10),
			 ('producto','Producto',15),
			 ('ventasVolumen','Ventas Volumen',10),
			 ('objetivoVolumen','Objetivo Volumen',10),
	--		 ('precioUnitario','Precio Unitario',5),
		--	 ('objetivoVentas','Objetivo Ventas',10),
			 ('cumplimientoVolumen','% Ventas',10),
			 ('cumplimientoPrecio','% Objetivo',10)


		if(@lenguaje = 'en')
			insert #columnasConfiguracion (name, title, width)
			values 
			 ('pais','Country',10),
			 ('cadena','Retail',10),
			 ('producto','Product Name',15),
			 ('ventasVolumen','Sales in Volume Actual',10),
			 ('objetivoVolumen','Sales in Volume Target',10),
--			 ('objetivoVentas','Sales in Mix Target',10),
			 ('cumplimientoVolumen','% Sales in Mix Actual',10),
--			 ('precioUnitario','Unit Price',5),
			 ('cumplimientoPrecio','% Sales in Mix Target',10)

 
		select name, title, width from #columnasConfiguracion

		--Datos
		if(@NumeroDePagina>0)
			select 	pais,cadena,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
									/*		case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoPrecio as varchar)+ '%'
							as cumplimientoPrecio
			from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
		if(@NumeroDePagina=0)
			select 	pais,cadena,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
									/*		case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.png" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoPrecio as varchar)+ '%'
							as cumplimientoPrecio
			from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
		if(@NumeroDePagina<0)
			select 	pais,cadena,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
											/*case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else ''
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else ''
							end
							+ ' ' +*/
							cast(cumplimientoPrecio as varchar)+ '%'
							as cumplimientoPrecio
			from #datosFinal
	 END
	 ELSE
	 BEGIN
	 insert #datosFinal_Agrupados(pais,producto,ventasVolumen,
						objetivoVolumen,precioUnitario,objetivoVentas,
						cumplimientoVolumen,cumplimientoPrecio)
		select pais,producto,sum(ventasVolumen),
						sum(objetivoVolumen),precioUnitario,sum(objetivoVentas),
						0,0
		from #datosFinal
		group by pais,producto,precioUnitario

		update #datosFinal_Agrupados
		set cumplimientoVolumen = (ventasVolumen*100.0)/@totalActual * 1.0
			,cumplimientoPrecio = (ObjetivoVolumen * 100.0) /@totalObjetivo * 1.0
		where objetivoVolumen <> 0
			and objetivoVolumen <>0


		insert #datosFinal_Agrupados(pais,producto,ventasVolumen,
						objetivoVolumen,precioUnitario,objetivoVentas,
						cumplimientoVolumen,cumplimientoPrecio)
		select '<b>TOTAL:</b>','',sum(ventasVolumen),sum(objetivoVolumen),null,
				sum(objetivoVentas),sum(cumplimientoVolumen),sum(cumplimientoPrecio)
		from #datosFinal_Agrupados

		if(@TamañoPagina=0)
			set @maxpag=1
		else
			select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal_Agrupados
		select @maxpag

		
		if(@lenguaje = 'es')
			insert #columnasConfiguracion (name, title, width)
			values 
			 ('pais','Pais',10),
--			 ('cadena','Retail',10),
			 ('producto','Producto',15),
			 ('ventasVolumen','Ventas Volumen',10),
			 ('objetivoVolumen','Objetivo Volumen',10),
	--		 ('precioUnitario','Precio Unitario',5),
	--		 ('objetivoVentas','Objetivo Ventas',10),
			 ('cumplimientoVolumen','% Ventas',10),
			 ('cumplimientoPrecio','% Objetivo',10)


		if(@lenguaje = 'en')
			insert #columnasConfiguracion (name, title, width)
			values 
			 ('pais','Country',10),
--			 ('cadena','Retail',10),
			 ('producto','Product Name',15),
			 ('ventasVolumen','Sales in Volume Actual',10),
			 ('objetivoVolumen','Sales in Volume Target',10),
			 ('cumplimientoVolumen','% Sales in Mix Actual',10),
--			 ('precioUnitario','Unit Price',5),
		--	 ('objetivoVentas','Sales in Mix Target',10),
			 ('cumplimientoPrecio','% Sales in Mix Target',10)

 
		select name, title, width from #columnasConfiguracion

		--Datos
		if(@NumeroDePagina>0)
			select 	pais,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
							/*case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else ''
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoPrecio as varchar)+ '%'
							as cumplimientoPrecio
			from #datosFinal_Agrupados where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
		if(@NumeroDePagina=0)
			select 	pais,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
							/*case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else ''
							end
							+ ' ' +*/
							cast(cumplimientoPrecio as varchar)+ '%'
							as cumplimientoPrecio
			from #datosFinal_Agrupados where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
		if(@NumeroDePagina<0)
			select 	pais,producto,ventasVolumen,
							objetivoVolumen,precioUnitario,objetivoVentas,
							/*case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoVolumen >= 60 and cumplimientoVolumen < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoVolumen >= 80 and cumplimientoVolumen <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else ''
							end
							+ ' ' +*/
							cast(cumplimientoVolumen as varchar)+ '%'
							as cumplimientoVolumen,
							/*case when cumplimientoPrecio < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
							when cumplimientoPrecio >= 60 and cumplimientoPrecio < 80
								then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
							when cumplimientoPrecio >= 80 and cumplimientoPrecio <=100
								then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
							else '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
							end
							+ ' ' + */
							cast(cumplimientoPrecio as varchar) + '%'
							as cumplimientoPrecio
			from #datosFinal_Agrupados



	 END
	
end

go

--[EpsonSellOutDetail_t9] 181