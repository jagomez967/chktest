IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_PdvConDistPorProd_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_PdvConDistPorProd_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Cob_PdvConDistPorProd_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamaņoPagina		int = 0
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
	create table #Categoria
	(
		idCategoria int
	)

	create table #CategoriaProducto
	(
		idCategoriaProducto int
	)
	
	create table #SubCategoria
	(
		idSubCategoria int
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
	declare @cCategoria int = 0
	declare @cCategoriaProducto int = 0
	declare @cSubCategoria int = 0 

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

	insert #CategoriaProducto (idCategoriaProducto) select clave as CategoriaProducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoriaProducto'),',') where isnull(clave,'')<>''
	set @cCategoriaProducto = @@ROWCOUNT
	
	insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
	set @cSubCategoria = @@ROWCOUNT

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

	declare @idEmpresa int 
	select @idEmpresa = idEmpresa from cliente where idCliente = @idCliente
	---NUEVO: Unificacion de filtros (Productos)
	
	if(@cProductos + @cMarcas + @cFamilia + @cCategoriaProducto + @cCompetenciaPrimaria + @cSubCategoria> 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
		and (isnull(@cCategoriaProducto,0) = 0 or exists(select 1 from #CategoriaProducto where idCategoriaProducto = p.idCategoria))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca)) 
		and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
												inner join subCategoriaProducto scp 
													on sc.idSubCategoria = scp.idSubCategoria
												where scp.idProducto = p.IdProducto))
		set @cProductos = @cProductos + @cMarcas + @cFamilia + @cCategoriaProducto + @cCompetenciaPrimaria + @cSubCategoria
	END
	--Unificacion de filtros (Puntos de venta)
	
	if(@cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores + @cCategoria> 0)
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
		AND (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
		 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pdv.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))

		select @cPuntosDeVenta = @cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores + @cCategoria
	END
	--Fin Unificacion Filtros

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte ( idUsuario, IdPuntoDeVenta, mes, idReporte)
	select r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and r.idEmpresa = @idEmpresa
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by r.IdUsuario ,r.IdPuntoDeVenta ,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)

	create table #datosFinal
	(
		id int identity(1,1),
		idpdv int,
		idProducto int
	)

	
	insert #datosFinal (idpdv, idproducto)
	select distinct t.idPuntoDeVenta,
			rp.idProducto
		from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	where isnull(rp.Stock,0) = 0 and isnull(rp.NoTrabaja,0) = 0
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = rp.IdProducto))		

	declare @maxpag int
	if(@TamaņoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamaņoPagina) from #datosFinal
	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('idpdv','idPuntoDeVenta',20),('npdv','NombrePdv',50),('dirpdv','Direccion',50),('localidad','Localidad',50),('zona','Zona',50),('cadena','Cadena',50),('producto','Producto',50)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('idpdv','idPdv',20),('npdv','PDV Name',50),('dirpdv','Address',50),('localidad','District',50),('zona','Zone',50),('cadena','Retail',50),('producto','Product',50)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select d.idpdv,pdv.nombre as npdv,pdv.direccion as dirpdv, l.nombre as localidad,z.nombre as zona,c.nombre as cadena,p.nombre as producto 
		from #datosFinal d 
		inner join puntodeventa pdv on pdv.idPuntodeventa = d.idpdv
		inner join zona z on z.idZona = pdv.idZona 
		inner join localidad l on l.idLocalidad = pdv.IdLocalidad
		inner join cadena c on c.idCadena = pdv.idCadena 
		inner join producto p on p.idProducto = d.idProducto
		where d.id between ((@NumeroDePagina - 1) * @TamaņoPagina + 1) and (@NumeroDePagina * @TamaņoPagina)
	
	if(@NumeroDePagina=0)
		select d.idpdv,pdv.nombre as npdv,pdv.direccion as dirpdv, l.nombre as localidad,z.nombre as zona,c.nombre as cadena,p.nombre as producto 
		from #datosFinal d 
		inner join puntodeventa pdv on pdv.idPuntodeventa = d.idpdv
		inner join zona z on z.idZona = pdv.idZona 
		inner join localidad l on l.idLocalidad = pdv.IdLocalidad
		inner join cadena c on c.idCadena = pdv.idCadena 
		inner join producto p on p.idProducto = d.idProducto
		where d.id between ((@maxpag - 1) * @TamaņoPagina + 1) and (@maxpag * @TamaņoPagina)
		
	if(@NumeroDePagina<0)
		select d.idpdv,pdv.nombre as npdv,pdv.direccion as dirpdv, l.nombre as localidad,z.nombre as zona,c.nombre as cadena,p.nombre as producto 
		from #datosFinal d 
		inner join puntodeventa pdv on pdv.idPuntodeventa = d.idpdv
		inner join zona z on z.idZona = pdv.idZona 
		inner join localidad l on l.idLocalidad = pdv.IdLocalidad
		inner join cadena c on c.idCadena = pdv.idCadena 
		inner join producto p on p.idProducto = d.idProducto
		
END
GO

