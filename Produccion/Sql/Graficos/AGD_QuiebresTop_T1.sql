IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.AGD_QuiebresTop_T1'))
   EXEC('CREATE PROCEDURE [dbo].[AGD_QuiebresTop_T1] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[AGD_QuiebresTop_T1]
(
	@IdCliente			INT,
	@Filtros			FiltrosReporting READONLY,
	@NumeroDePagina		INT = -1,
	@Lenguaje			VARCHAR(3) = 'es',
	@IdUsuarioConsulta	INT = 0,
	@TamaņoPagina		INT = 0
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
		idMarca int
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

	create table #CategoriaProducto
	(
		idCategoriaProducto int
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
	declare @cCategoriaProducto int = 0

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

	insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #CategoriaProducto (idCategoriaProducto) select clave as CategoriaProducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoriaProducto'),',') where isnull(clave,'')<>''
	set @cCategoriaProducto = @@ROWCOUNT
	
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

				
	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #datos
	(
		idPuntoDeVenta int,
		mes varchar(8),
		qty int
	)
	-------------------------------------------------------------------- END (Temp)

	--SI TENGO UN PDV SELECCIONADO ENTONCES....
	declare @topN INT = 5
	if(select count(1) from #puntosdeventa) = 1
	BEGIN 
		set @topN = 10000
	END


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
	declare @cantidadREG int

	create table #datosFinal(nombre varchar(max),qty int)

	insert #datosFinal(nombre,qty)
	SELECT TOP (SELECT @topN) p.Nombre ,count(*)
	from Reporte r
	inner join ReporteProducto rp on rp.IdReporte=r.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join producto p on p.idproducto = rp.idproducto
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=249
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and rp.Stock=1
	group by p.Nombre
	order by COUNT(*) desc, p.Nombre asc
	set @CantidadREG = @@rowcount

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50)
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title) values ('producto','Producto'),('quiebre','Quiebre')
	
	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title) values ('product','Product'),('quiebre','Break')
		
	declare @graphHeight int = 0
	declare @heightRegister int = 51
	if(@topN <> 5)
	BEGIN
		select @graphHeight = @cantidadREG * @heightRegister 
	END

	if(@graphHeight< (5 * @heightRegister)) 
	BEGIN
		set @graphHeight = 0
	END


	select name, title, '' AS IsInverted,0 as ShowLegend, '' as HideTitle,@graphHeight as Height from #columnasConfiguracion
	
	
	select nombre,qty from #datosFinal 
	
end
GO


