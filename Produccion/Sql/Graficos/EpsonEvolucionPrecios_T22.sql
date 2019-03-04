IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonEvolucionPrecios_T22'))
   exec('CREATE PROCEDURE [dbo].[EpsonEvolucionPrecios_T22] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[EpsonEvolucionPrecios_T22]
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
	declare @cMarcasEpson varchar(max)
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
	

	---PLOTBANDS 
	create table #plotBands
	( inicio int,
	 fin int,
	color varchar(20),
	label varchar(50)
	)
	---PLOTLINES
	create table #plotLines
	( valor int,
	  color varchar(20),
	  estilo varchar(50),
	  grosor int,
	  [text] varchar(20),
	  align varchar(20),
	  x int,
	  colorLabel varchar(20),
	  fontWeight varchar(20),
	  fontSize varchar(20)
	)
	---Configuracion
	create table #configuracion
	( 
		xTitulo varchar(50),
		yTitulo varchar(50)
	)
	---Data
	create table #data
	(
		idProducto int,
		producto varchar(500), --NOMBRE DE PRODUCTO<
		dashStyle int,
		color varchar(10),
		fecha int,
		valorFecha varchar(10),
		valor decimal(18,2),
		linkedTo varchar(50), --LinkedToID
		marca varchar(50),
		idCadena int

	)

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


	insert #plotBands(inicio,fin,color,label)
	select inicio,fin,color,label
	from rangoPrecios where idCliente = @idCliente

	insert #plotLines(valor,color,estilo,grosor,[text],align,x,colorLabel,fontWeight,fontSize)	
	select fin,'#A8A8A8','dash',2,ltrim(rtrim(cast(fin as varchar))),'left',-35,'#A8A8A8','bold','10px'
	from RangoPrecios where fin > 0
	and idCliente = @idCliente
	
	insert #configuracion(xTitulo,yTitulo)
	values('Producto','Precio $')
	
	
	insert #data(idPRoducto,producto,dashStyle,color,fecha,valorFecha,valor,linkedTo,marca,idCadena)			
	select p.idProducto,p.nombre,/*CONTADOR*/1,m.MarcaColor,
	year(r.FechaCreacion) * 10000
	+
	datepart(month,r.FechaCreacion) * 100
	+
	datepart(day,r.FechaCreacion) * 1

	,convert(varchar,r.fechacreacion,103),rp.precio,  --PROMEDIO
	(select max(idProducto) from ProductoCompetencia
	where idProductoCompetencia = p.idProducto
	and reporte = 1 ), -- y bue
	m.nombre --Nombre de serie
	,pdv.idCadena
	From reporte r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join producto p on p.idProducto = rp.idProducto
	inner join subMarca_Producto smp on smp.idProducto = p.idProducto
	inner join SubMarca m on m.idSubMarca = smp.idSubMarca
		and m.idMarca = p.idMarca
	inner join cliente c on c.idEmpresa = r.idEmpresa
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	where	convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)			
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.idProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
			and (isnull(@cMarcasEpson,0) = 0 or exists(select 1 from #marcasEpson where idMarcaEpson = m.idSubMarca))
	and rp.precio <> 0	
	and p.Reporte = 1 	
	--Oculto Consumibles
	AND P.idMarca != 2905



	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int,
		fecha int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,fecha)
	select idProducto,valor,count(valor),fecha
	from  #data
	group by idProducto,valor,fecha

	
	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idproducto = p.idProducto and cantidad > p.cantidad and  p.fecha = fecha)

	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idProducto = p.idProducto and precio > p.precio  and  p.fecha = fecha)

		select distinct d.idPRoducto,d.producto,d.fecha,d.valorFecha,cast(max(p.precio) as decimal(18,2))as valor,d.color,
		d.dashStyle,d.linkedTo,d.Marca,prod.orden,p.cantidad as reportes--,1 as 'LabelFullName' 
		from #data d
		inner join #preciosPorProducto p		
		on p.idProducto = d.idProducto and p.fecha = d.fecha	
		inner join producto prod on prod.idProducto = p.idProducto
		group by d.idProducto,d.producto,d.fecha,d.valorFecha,d.color
		,d.dashStyle,d.linkedTo,d.Marca,prod.orden,p.cantidad 
	order by prod.orden,d.fecha
	select inicio,fin,color,label from #plotBands
	select valor,color,estilo,grosor,[text] as texto,align,x,colorLabel,fontWeight,fontSize from #plotLines
	select xTitulo,yTitulo from #configuracion 

	---------------------------------------------------------------------------------------------------------------------------------
end
go




		 

