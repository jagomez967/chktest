IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Whirpool_Capacitados_Por_Categoria_T11'))
   exec('CREATE PROCEDURE [dbo].[Whirpool_Capacitados_Por_Categoria_T11] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Whirpool_Capacitados_Por_Categoria_T11]
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
		
		Idpdv int,
		IdReporte int,
		fecha varchar(8),
		usuario int,
		nombre varchar(200),
		id_cadena int,
		tipo_pdv int
	)

	-------------------------------------------------------------------- TEMPS (Filtros)

	
	insert #tempReporte ( Idpdv, IdReporte,fecha, usuario,nombre,id_cadena,tipo_pdv)
	select distinct  p.IdPuntoDeVenta, r.idreporte,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112), u.idusuario,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Usuario, p.idCadena, p.IdTipo
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join usuario u on u.idUsuario = r.IdUsuario
	where	c.IdCliente=@IdCliente
		and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))	
	
	group by p.IdPuntoDeVenta,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),u.idusuario,
	U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT,r.idreporte,p.idCadena,p.IdTipo
	
	
	
	create table #coccion_cocinas
	(
	cantidad int,
	cadena varchar(100)
	)
	
	insert #coccion_cocinas (cadena, cantidad)
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1)--,r.fecha
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11217
	and mi.idmodulo = 2441
	group by mi.nombre--,r.fecha
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1)--,r.fecha
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11218
	and mi.idmodulo = 2441
	group by mi.nombre--,r.fecha
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1)--,r.fecha
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11219
	and mi.idmodulo = 2441
	group by mi.nombre--,r.fecha
  
	
	
	create table #coccion
	(
	cantidad int,
	cadena varchar(100)
	)
	
	insert #coccion (cadena, cantidad)
	select  cadena, sum(cantidad)
	from  #coccion_cocinas  
	group by cadena

	

	-------------------------------------------------------------------------------------
	
	create table #Lavado_Lavarropas_CS
	(
	cantidad int,
	id_cadena int, 
	cadena varchar(100), id int 
	)
	
	insert #Lavado_Lavarropas_CS (cadena, cantidad,id_cadena)
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11220
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11221
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11222
	and mi.idmodulo = 2441
    group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11342
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	
	
	create table #Lavado
	(
	cantidad int,
	cadena varchar(100)
	)
	
	insert #Lavado (cadena, cantidad)
	select  cadena,sum(cantidad)
	from  #Lavado_Lavarropas_CS
	group by cadena 
	
	
	---------------------------------------------------------------------------------------
	
	create table #Refrigeración_Heladeras
	(
	cantidad int,
	id_cadena int, 
	cadena varchar(100)
	)
	
	insert #Refrigeración_Heladeras (cadena, cantidad,id_cadena)
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11223
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11224
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11225
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1),mi.idItem
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11343
	and mi.idmodulo = 2441
	group by mi.nombre,mi.idItem

	
	create table #Refrigeración
	(
	cantidad int,
	cadena varchar(100)
	)
	
	insert #Refrigeración (cadena, cantidad)
	select cadena, sum (cantidad)
	from  #Refrigeración_Heladeras 
	group by cadena

	------------------------------------------------------------------------------------------------------------
	
	create table #Hogar
	(
	cantidad int,
	meses int, 
	cadena varchar(100), id int 
	)
	
	insert #Hogar (cadena, cantidad)
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),count(rmi.valor1)
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem = 11226
	and mi.idmodulo = 2441
	group by mi.nombre
	---------------------------------------------------------------------------------------------------------------------
	
	create table #Resultado
	(
	cantidad int, 
	cadena varchar(100)
	)
	
	
	insert into #Resultado(cadena, cantidad) 
	select cadena, cantidad
	from #coccion 
	union
	select cadena, cantidad
	from #Lavado
	union
	select cadena, cantidad
	from #Refrigeración
	union
	select cadena, cantidad
	from #Hogar

	
	select cadena, cadena,sum(cantidad) as cantidad, 1 showVal from #Resultado group by cadena
	
	create table #datosRes
	(
		
		id_cadena int,
		cadena varchar(100),
		nombre varchar(100),
		cantidad int
	)
	
	insert #datosRes (cadena, id_cadena,nombre,cantidad)
    
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre,count(rmi.valor1)
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem in (11217,11218,11219)
	and mi.idmodulo = 2441
	group by SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre,count(rmi.valor1)
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem in (11220,11221,11222,11342)
	and mi.idmodulo = 2441
	group by SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre
	union
	select  SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre,count(rmi.valor1)
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem in (11223,11224,11225,11343)
	and mi.idmodulo = 2441
	group by SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre
	union
	select   SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre,count(rmi.valor1)
	from MD_ReporteModuloItem rmi
	inner join #tempReporte r on r.IdReporte = rmi.IdReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	where rmi.IdItem =11226
	and mi.idmodulo = 2441
	group by SUBSTRING(mi.nombre, 0, CHARINDEX('-',mi.nombre,0)),mi.idItem,mi.nombre
	
	--select meses,cadena,id_cadena,nombre,cantidad, 1 showVal from #datosRes
	
	select cadena,cadena,id_cadena,nombre,cantidad, 1 showVal from #datosRes
   
end
go
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20180801,20180830')
--insert into @p2 values(N'fltpuntosdeventa',N'99647')
--insert into @p2 values(N'fltusuarios',N'3915')
--insert into @p2 values(N'fltMarcas',N'614')
--insert into @p2 values(N'fltCadenas',N'4751')

exec Whirpool_Capacitados_Por_Categoria_T11 @IdCliente=201,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'