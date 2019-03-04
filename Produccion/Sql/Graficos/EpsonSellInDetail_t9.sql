IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonSellInDetail_t9'))
   exec('CREATE PROCEDURE [dbo].[EpsonSellInDetail_t9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[EpsonSellInDetail_t9]
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


	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		Fechacreacion datetime,
		idReporte int,
		idCadena int
	)

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
	--Configuracion de columnas
		create table #columnasConfiguracion
		(
			name varchar(50),
			title varchar(50),
			width int
		)



	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------
	declare @totalActual int
	declare @totalTarget int

	select @totalActual = sum(isnull(ventas,0)) from epson_retailerUnidades
	select @totalTarget = sum(isnull(objetivo,0)) from epson_retailerUnidades

	insert #datosFinal (pais,cadena,producto,ventasVolumen,
						objetivoVolumen,precioUnitario,objetivoVentas,
						cumplimientoVolumen,cumplimientoPrecio)
	select 'Argentina',
		   cad.nombre,
		   prod.nombre,
		   ru.ventas,
		   ru.objetivo,
		   pu.precio,
		   pu.precio * ru.objetivo,
		   (ru.ventas * 100.0) / @totalActual,
		   (ru.Objetivo * 100.0) /	@totalTarget
	from epson_retailerUnidades ru
	inner join epson_preciosProductos pu
	on pu.idProducto = ru.idProducto
	inner join cadena cad
	on cad.idCadena = ru.idCadena
	inner join producto prod
	on prod.idProducto = ru.idProducto 
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = ru.idProducto))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #Cadenas where idCadena = ru.idCadena))

	
	declare @maxpag int
	if exists(select 1 from #Cadenas) 
	BEGIN

		--declare @maxpag int
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
									/*		case when cumplimientoVolumen < 60 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
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
						0,0--sum(ventasVolumen)/@totalTarget*1.0,sum(ObjetivoVentas)/@TotalTarget*1.0
		from #datosFinal
		group by pais,producto,precioUnitario

		update #datosFinal_Agrupados
		set cumplimientoVolumen = (ventasVolumen*100.0)/@totalActual * 1.0
			,cumplimientoPrecio = (ObjetivoVolumen * 100) /@totalTarget * 1.0
		where objetivoVolumen <> 0
			and objetivoVolumen <>0


		insert #datosFinal_Agrupados(pais,producto,ventasVolumen,
						objetivoVolumen,precioUnitario,objetivoVentas,
						cumplimientoVolumen,cumplimientoPrecio)
		select '<b>TOTAL:</b>',null,sum(ventasVolumen),sum(objetivoVolumen),null,
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
							+ ' ' +*/ 
							cast(cumplimientoPrecio as varchar) + '%'
							as cumplimientoPrecio
			from #datosFinal_Agrupados
	END
end

--[EpsonSellInDetail_t9] 61