IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EPSONVSHP_T9'))
   exec('CREATE PROCEDURE [dbo].[EPSONVSHP_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EPSONVSHP_T9]
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
			and rp.precio <> 0.0
			and prod.reporte = 1
			
	--CALCULO MODA
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,idCadena)
	select idProducto,precio,count(precio),idcadena
	from  #tempReporte 
	group by idProducto,precio,idCadena

	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idproducto = p.idProducto and cantidad > p.cantidad and idCadena = p.idCadena)

	--FIN MODA	
	create table #datosFinal
	(idFamilia int,
	 idProducto int,
	 maxPrecio decimal(18,3),
	 idProductoCompetencia int,
	 maxPrecioCompetencia decimal(18,3),
	 idCadena int
	 )

	 insert #datosFinal (idFamilia,idProducto,maxPrecio,idProductoCompetencia,idCadena)
	 select p.IdFamilia, pp.idProducto,pp.precio,ec.idProductoCompetencia,pp.idCadena
	 from #preciosPorProducto pp
	 inner join producto p on p.idProducto = pp.idProducto	 
	 left join ProductoCompetencia ec on ec.idProducto = pp.idProducto
	 where pp.idProducto in (select idProducto from SubMarca_producto where idSubMarca = 100)   --EPSON
	 and ec.idProductoCompetencia in (select idProducto from SubMarca_producto where idSubMarca = 200)  --HP
	 and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.idProducto))
	 and ec.reporte =1 

	 update d
	 set maxPrecioCompetencia = pp.precio
	 from #datosFinal d
	 inner join #preciosPorProducto pp
	 on d.idProductoCompetencia = pp.idProducto	 
	 and d.idCadena = pp.idCadena
	 where not exists (select 1 from #PreciosPorProducto where idProducto = pp.idProducto and pp.precio < precio
						and idcadena =pp.idCadena )

	select 1
	
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)
	-- VOY A DINAMIZAR ESTO SIN HACER PIVOT...

	create table #productosList(idProducto int,nombre varchar(max))
	insert #productosList(idProducto,nombre)
	select distinct d.idProducto,p.nombre
	from #datosFinal d 
	inner join producto p on p.idProducto = d.idProducto


	declare @spQuery nvarchar(max)

	set @spQuery = ''

	insert #columnasConfiguracion (esclave,mostrar,name, title, width) 
	values	
		(0,1,'Retail','Retail',5)


	insert #columnasConfiguracion (esclave,mostrar,name, title, width) 
	select 0,1,nombre,nombre,5
	from #productosList 

	select esclave,mostrar,name, title, width from #columnasConfiguracion

	create table #retails(idcadena int, cadena varchar(500))

	insert #retails(idCadena,cadena)
	select distinct d.idCadena,c.nombre
	from #datosFinal d
	inner join cadena c on c.idcadena = d.idCadena


	select @spQuery = 
	'select r.Cadena as Retail'
	
	select @spQuery = @spQuery +
	',(select top 1
		   case when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 > 10
		   then 
		   ''<font color="red">''+ltrim(rtrim(str(((MaxPrecio / MaxPrecioCompetencia)*100)-100,18,2)))+''%''+''</font>''
		   when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 < -10 
		   then
		   ''<font color="yellow">''+ltrim(rtrim(str(((MaxPrecio / MaxPrecioCompetencia)*100)-100,18,2)))+''%''+''</font>''
		   else
		   ''<font color="black">''+ltrim(rtrim(str(((MaxPrecio / MaxPrecioCompetencia)*100)-100,18,2)))+''%''+''</font>''
		   end
		    from #datosFinal 
				where idProducto = '+ltrim(rtrim(str(idProducto)))+' and idCadena = r.idCadena) as ['+nombre+']'
	from #productosList
	select @spQuery = @spQuery +
	'
	from #retails r'

	EXEC sp_executesql @spQuery

end

go


EpsonVsHp_t9 194

--Retail	XP241	XP441	L380	L395
--Coto	<font color="black">-4.35%</font>	NULL	NULL	<font color="yellow">-12.28%</font>
--Garbarino	<font color="red">29.43%</font>	NULL	<font color="red">29.74%</font>	<font color="red">22.23%</font>
--Cencosud S.A.	NULL	NULL	NULL	<font color="black">5.09%</font>
--Fravega	NULL	<font color="red">130.87%</font>	<font color="red">20.01%</font>	<font color="red">22.23%</font>