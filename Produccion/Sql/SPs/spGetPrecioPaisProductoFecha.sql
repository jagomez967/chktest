IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spGetPrecioPaisProductoFecha'))
   exec('CREATE PROCEDURE [dbo].[spGetPrecioPaisProductoFecha] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[spGetPrecioPaisProductoFecha]
(
	@IdCliente			int,
	@nombreProducto varchar(200),
	@fecha			varchar(20)
	,@Filtros			FiltrosReporting readonly
)
AS
BEGIN
	
	SET LANGUAGE spanish
	set nocount on
	declare @lenguaje char(2) = 'es'

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
	and m.idMarca in
		(select mar.idMarca from marca mar
		inner join cliente c on c.idEmpresa = mar.idEmpresa
		where c.idCliente in(select idCliente from #clientes)
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



	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	create table #data
	(
		valor decimal(18,2),
		producto varchar(500),
		idProducto int,
		marca varchar(50),
		colorMarca varchar(10),
		idcliente  int,
		marcaEPson varchar(max)
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

	insert #data(valor,p.idProducto,producto,marca,colorMarca,idCliente,marcaEpson)			
	select rp.precio/cur.value,p.idProducto,p.nombre,ltrim(rtrim(str(m.idSubMarca/100))) + ' - ' + m.nombre,m.MarcaColor,c.idCliente,m.nombre
	From reporte r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join producto p on p.idProducto = rp.idProducto
	inner join subMarca_Producto smp on smp.idProducto = rp.idProducto
	inner join SubMarca m on m.idSubMarca = smp.idSubMarca
	and m.idMarca = p.idMarca
	inner join cliente c on c.idempresa = r.idEmpresa
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
	inner join currencyExchange cur on cur.date = convert(date,r.fechaCreacion) and cur.curLocal = c.localCurrency	
	where	convert(date,r.fechaCreacion) = convert(date,@fecha,103)
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
			and (isnull(@cMarcasEpson,0) = 0 or exists(select 1 from #MarcasEpson where idMarcaEpson = m.idSubMarca))
			and p.nombre like '%'+ltrim(rtrim(@nombreProducto))+'%'
	and rp.precio <> 0	







	--CALCULO MODA
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,2),
		cantidad int,
		idCliente int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,idCliente)
	select idProducto,valor,count(valor),idCliente
	from  #data
	group by idProducto,valor,idCliente

	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idproducto = p.idProducto and cantidad > p.cantidad and idCliente = p.idCliente)

	delete p 
	from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto where idProducto = p.idProducto and precio > p.precio and idCliente = p.idCliente)


	--FIN MODA	
	update d
	set valor = p.precio
	from #data d 
	inner join #preciosPorProducto p
	on p.idProducto = d.idProducto
	and p.idCliente = d.idCLiente

	select distinct c.nombre as pais,p.precio as valor
	from #data d
	inner join #preciosPorProducto p
	on p.idProducto = d.idProducto 
	inner join producto pr on pr.idProducto = d.idProducto
	inner join marca m on m.idMarca = pr.idMarca 
	inner join cliente c on c.idEmpresa = m.idEmpresa
	where c.idCliente in(select idCliente from #clientes)
	and pr.nombre like '%'+ltrim(rtrim(@nombreProducto))+'%'


END

GO

declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20180601,20180612')

exec [spGetPrecioPaisProductoFecha] @IdCliente=196, @nombreProducto = 'EPSON L380', @fecha = '21/06/2018'








