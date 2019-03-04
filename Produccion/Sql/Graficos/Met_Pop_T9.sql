IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Met_Pop_T9'))
   exec('CREATE PROCEDURE [dbo].[Met_Pop_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Met_Pop_T9] 	
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
	
	if(@cProductos + @cMarcas + @cFamilia > 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
		set @cProductos = @cProductos + @cMarcas + @cFamilia
	END
	--Unificacion de filtros (Puntos de venta)
	
	if(@cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores> 0)
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

		select @cPuntosDeVenta = @cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores 
	END
	--Fin Unificacion Filtros


	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #tempReporte
	(
		idEmpresa int,
		idUsuario int,
		IdPuntoDeVenta int,
		fecha datetime,
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, fecha, idReporte)
	select	r.IdEmpresa
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and r.idEmpresa = @idEmpresa 
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		 group by r.idEmpresa,r.IdUsuario,r.IdPuntoDeVenta,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) 

	create table #datos
	(
		idReporte int,
		idMarca int,
		idPop int
	)

	insert #datos (idReporte, idMarca, idPop)
	select t.idReporte, m.idMarca, pm.idPop 
	from #tempReporte t, Pop_Marca pm
	inner join Marca m on m.idMarca = pm.idMarca
	where m.Reporte = 1
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #Marcas where idMarca = m.idMarca))
	order by t.idReporte

	create table #datosFinal
	(
		id int identity(1,1),
		idReporte int,
		fecharep varchar(10),
		idpdv int,	
		idMarca int,		
		idpop int,
		cantidad decimal(18,2),
		idUsuario int
	)

	insert #datosfinal(idReporte,fecharep, idpdv, idUsuario,idMarca, idpop, cantidad)
	select d.idReporte
		,convert(varchar,r.FechaCreacion,103) as FechaRep
		,r.idPuntoDeVenta as idPuntoDeVenta
		,r.idUsuario
		,d.idmarca idmarca
		,d.idpop as id_pop
		,isnull(cast(rp.Cantidad as numeric(18,1)), 0) as Cantidad
	from #datos d
	inner join ReportePop rp on rp.idReporte = d.idReporte and rp.idPop = d.idPop and d.idMarca = rp.idMarca
	inner join Reporte r on r.idReporte = d.idReporte --needed
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
	order by r.FechaCreacion, pdv.IdPuntoDeVenta, d.IdMarca, d.IdPop,d.idReporte

	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje='es')	
		insert #columnasConfiguracion (name, title, width) values ('idReporte','idReporte',5),('fecharep','Fecha',5),('idpdv','idPuntoDeVenta',5),('pdv','PDV',5),('direccion','Dirección',5),('zona','Zona',5),('rtm','RTM',5),('marca','Marca',5),('cadena','Cadena',5),('pop','POP',5),('cantidad','Cantidad',10)

	if(@lenguaje='en')	
		insert #columnasConfiguracion (name, title, width) values ('idReporte','idReporte',5),('fecharep','Fecha',5),('idpdv','idPuntoDeVenta',5),('pdv','PDV',5),('direccion','Dirección',5),('zona','Zona',5),('rtm','RTM',5),('marca','Marca',5),('cadena','Cadena',5),('pop','POP',5),('cantidad','Cantidad',10)
	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select idReporte,fecharep, idpdv,pdv.nombre as pdv,pdv.direccion as direccion,z.nombre as zona,u.apellido + ', ' + u.nombre collate database_default as rtm,
		m.nombre as marca,c.nombre as cadena,p.nombre as pop, cantidad 
		from #datosFinal d
		inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.idpdv
		inner join zona z on z.idZona = pdv.idZona
		inner join cadena c on c.idCadena = pdv.idCadena
		inner join pop p on p.IdPop = d.idpop
		inner join marca m on m.idMarca = d.idMarca 
		inner join usuario u on u.idUsuario = d.idUsuario
		where d.id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select idReporte,fecharep, idpdv,pdv.nombre as pdv,pdv.direccion as direccion,z.nombre as zona,u.apellido + ', ' + u.nombre collate database_default as rtm,
		m.nombre as marca,c.nombre as cadena,p.nombre as pop, cantidad 
		from #datosFinal d
		inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.idpdv
		inner join zona z on z.idZona = pdv.idZona
		inner join cadena c on c.idCadena = pdv.idCadena
		inner join pop p on p.IdPop = d.idpop
		inner join marca m on m.idMarca = d.idMarca 
		inner join usuario u on u.idUsuario = d.idUsuario
		where d.id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select idReporte,fecharep, idpdv,pdv.nombre as pdv,pdv.direccion as direccion,z.nombre as zona,u.apellido + ', ' + u.nombre collate database_default as rtm,
		m.nombre as marca,c.nombre as cadena,p.nombre as pop, cantidad 
		from #datosFinal d
		inner join puntodeventa pdv on pdv.IdPuntoDeVenta = d.idpdv
		inner join zona z on z.idZona = pdv.idZona
		inner join cadena c on c.idCadena = pdv.idCadena
		inner join pop p on p.IdPop = d.idpop
		inner join marca m on m.idMarca = d.idMarca 
		inner join usuario u on u.idUsuario = d.idUsuario

end
GO

-- met_pop_t9 44 