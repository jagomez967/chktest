IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonCompetimeterConsumibles_T24'))
   exec('CREATE PROCEDURE [dbo].[EpsonCompetimeterConsumibles_T24] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EpsonCompetimeterConsumibles_T24]
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

	create table #marcasEpson
	(
		idMarcaEpson int
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
	
	insert #marcasEpson (idmarcaEpson) select clave as idmarcaEpson from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcasEpson'),',') where isnull(clave,'')<>''
	set @cMarcasEpson = @@ROWCOUNT
	

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
	create table #data
	(valor decimal(18,3),
	idProducto int,
	idCadena int)

	if (isnull(@cFamilia,0) = 0) 
	begin
		insert #familia(idFamilia)
		select idfamilia from familia	
		where nombre  = 'CISS CONSUMIBLES'
		and idMarca in(select idMarca from marca where idEmpresa in
		(select idEmpresa from cliente where idCliente in(select idCliente from #clientes)))
		set @cFamilia = @@rowcount
	End

		create table #preciosPorProducto
		(
			idProducto int,
			precio decimal(18,3),
			cantidad int,
			idCadena int
		)

	declare @idCliente_actual int 
	declare @valor decimal(18,2)	
	declare @valor_acumulado decimal(18,2)
		
	declare @precioPropio decimal(18,3),
			@precioCompetencia decimal(18,3),
			@idProductoPropio int,
			@idProductoCompetencia int

	declare @propio varchar(200),@competencia varchar(200)

	declare @propio_acumulado varchar(max),@competencia_acumulado varchar(max)

	declare @cantidad int = 0
	
	DECLARE cliente_cursor CURSOR FOR   
	select idCliente
	FROM #clientes
	OPEN cliente_cursor

	FETCH NEXT FROM cliente_cursor
	INTO @idCLiente_actual

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		delete from #data 

		select @propio = null,@competencia = null, @idProductoPropio = null,@idProductoCompetencia = null 

		insert #data(valor,idProducto,idCadena)			
		select rp.precio,rp.idProducto ,pdv.idCadena
		From reporte r
		inner join reporteProducto rp on rp.idReporte = r.idReporte
		inner join producto p on p.idProducto = rp.idProducto
		inner join cliente c on c.idempresa = r.idEmpresa
		inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
		where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
				--and exists(select 1 from #clientes where idCliente = c.idCliente)			
				and c.idCliente = @idCliente_actual 
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
				and p.Reporte = 1
				and rp.precio <> 0	

				 
			--CALCULO MODA

		delete from #preciosPorProducto

		insert #preciosPorProducto(idProducto,precio,cantidad)
		select idProducto,valor,count(valor)
		from  #data
		group by idProducto,valor

		delete p 
		from #preciosPorProducto p
		where exists(select 1 from #preciosPorProducto where idproducto = p.idProducto and cantidad > p.cantidad)
		--FIN MODA	

	if exists (select 1 from #Familia where idFamilia in( select idFamilia from familia where nombre = 'CISS CONSUMIBLES')) --CISS
	BEGIN
		select @precioPropio = 
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18115),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18116),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18117),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18118),0)

		
		select @precioCompetencia = 
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18127),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18128),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18129),0)
		+
		ISNULL((SELECT max(precio) 
		from #preciosPorProducto 
		where idProducto = 18130),0)
		
		
		END
--		BEGIN TRY
			select @valor = (((@precioPropio - @precioCompetencia   )/ NULLIF(@precioPropio,0) * 1.0)*100.0)
--		END TRY
--		BEGIN CATCH
--			select @valor = 0
--		END CATCH

	
		if @valor is null 
		BEGIN
			set @valor = 0.0
		END
		ELSE
		BEGIN
			set @cantidad = @cantidad + 1
		END

		if @propio is null
			set @propio ='T504'

		if @competencia is null
			set @competencia = 'GT52'
		

		select @valor_acumulado = coalesce(@valor_acumulado + @valor,@valor)
		

		select @propio_acumulado = coalesce(@propio_acumulado +', '+ @propio, @propio)
		select @competencia_acumulado = coalesce(@competencia_acumulado +', '+ @competencia, @competencia)

	
		 FETCH NEXT FROM cliente_cursor   
		  INTO @idCliente_actual
	END	

	if isnull(@cantidad,0)  = 0	set @cantidad = 1

	close cliente_cursor;
	deallocate cliente_cursor;

	select @propio = @propio_acumulado
	select @competencia = @competencia_acumulado
	select @valor = @valor_acumulado / (@cantidad * 1.0)
	
	declare @minValor int =-40, @maxValor int = 10

	if(@minValor > ceiling(@valor)) set @minValor = ceiling(@valor)

	if(@maxValor < ceiling(@valor)) set @maxValor = ceiling(@valor)

	select @minValor as minvalor, @maxValor as maxvalor, ceiling(@valor) as valor,@propio as producto,@competencia as competencia,'COMPETIMETER' as texto

	create table #labels 
	(valor int ,label varchar(100))


	if(@Lenguaje = 'en')
	BEGIN
		insert #labels (valor,label)
		values ( 0, 'POOR'),(34,'FAIR'),(68,'GOOD'),(102,'BEST')
	END

	ELSE
	BEGIN
		insert #labels (valor,label)
		values ( 0, 'MALO'),(34,'BAJO'),(68,'BUENO'),(102,'OPTIMO')
	END
	
	select valor , label from #labels

	END
