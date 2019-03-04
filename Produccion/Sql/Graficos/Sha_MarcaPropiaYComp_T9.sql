IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Sha_MarcaPropiaYComp_T9'))
   exec('CREATE PROCEDURE [dbo].[Sha_MarcaPropiaYComp_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Sha_MarcaPropiaYComp_T9] 	
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


	create table #marcaCompetencia
	(
		idMarca int
	)

	declare @cCompetencia int

	insert #marcaCompetencia (idMarca)
	select ID_MARCACOMP from competenciaPrimariaAndromaco
	where [ID MARCA] in(select idMarca from #competenciaPrimaria)
	set @cCompetencia = @@ROWCOUNT

	
	insert #marcas(idMarca)
	select [ID MARCA] from competenciaPrimariaAndromaco
	where [ID MARCA] in(select idMarca from #competenciaPrimaria)
	set @cMarcas = @cMarcas + @@ROWCOUNT


	declare @idEmpresa int 
	select @idEmpresa = idEmpresa from cliente where idCliente = @idCliente
	---NUEVO: Unificacion de filtros (Productos)
	
	if(@cProductos + @cMarcas + @cFamilia + @cSubCategoria > 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
		and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
													inner join subCategoriaProducto scp 
														on sc.idSubCategoria = scp.idSubCategoria
													where scp.idProducto = p.IdProducto))
		set @cProductos = @cProductos + @cMarcas + @cFamilia + @cSubCategoria
	END
	--Unificacion de filtros (Puntos de venta)
	
	if(@cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores > 0)
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

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		idReporte int
	)

	create table #datos
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		qty numeric(18,2)
	)

	create table #datosFinal
	(
		id int identity(1,1),
		marca varchar(100),
		share decimal(18,1)
	)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, idReporte)
	select r.idempresa, r.idpuntodeventa, max(r.idreporte)
	from Reporte r
	where	r.IdEmpresa=@idEmpresa
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)	
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))		
	group by r.IdEmpresa, r.IdPuntoDeVenta

	insert #datos (idEmpresa,idProducto,qty)
	select r.idEmpresa,rp.idProducto, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reportesMesPdv r
	inner join ReporteProducto rp on rp.IdReporte=r.IdReporte
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = rp.IdProducto))
	group by r.idEmpresa, rp.IdProducto

	create table #ProductoCompetencia(idProducto int)
	declare @cProductoCompetencia int = 0

	if(@cCompetencia > 0) --SI tengo marcas competidoras seleccionadas
	BEGIN
		insert #ProductoCompetencia(idProducto)
		select distinct p.idProducto 
		from producto p 
		where p.idMarca in(select idMarca from #marcaCompetencia)
		set @cProductoCompetencia = @@ROWCOUNT
	END
	
	if(@cProductos > 0)
	BEGIN
		insert #ProductoCompetencia(idProducto)
		select distinct pc.idProductoCompetencia 
		from ProductoCompetencia pc
		where pc.IdProducto in (select idProducto from #productos)
		set @cProductoCompetencia = @cProductoCompetencia + @@ROWCOUNT
	END


	insert #datos (idProducto, qty)
	select rp.idProducto, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	where (isnull(@cProductoCompetencia,0) = 0 or exists(select 1 from #ProductoCompetencia where idProducto = rp.IdProducto))
	group by rp.IdProducto


	update d
	set idMarca = p.idMarca
	from #datos d 
	inner join producto p	
		on p.idProducto = d.idProducto 
	
	update d
	set idEmpresa = m.idEmpresa 
	from #datos d 
	inner join producto p
		on p.idProducto = d.idProducto
	inner join marca m 
		on m.idmarca = p.idMarca 
	where d.idMarca is null

	create table #Resultados
	(
		idEmpresa int,
		idMarca int,
		qty numeric(18,5)
	)

	insert #Resultados (idEmpresa, idMarca, qty)
	select te.idEmpresa, te.idMarca, SUM(isnull(te.qty,0))
	from #datos te
	group by te.idEmpresa, te.idMarca

	delete from #Resultados where idEmpresa in (select idEmpresa from #Resultados group by idEmpresa having sum(qty)=0)
	delete from #Resultados where idMarca in (select idMarca from #Resultados group by idMarca having sum(qty)=0)

	declare @total numeric(18,5)
	select @total = SUM(isnull(qty,0)) from #Resultados

	insert #datosFinal(marca, share)
	select LTRIM(rtrim(m.nombre)) as Marca, cast(isnull(r.qty,0)*100*1.0/@total as numeric(18,1)) as Share
	from #Resultados r
	inner join Marca m on m.idmarca=r.idMarca
	order by m.nombre

	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal

	select @maxpag
	
	
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje='es')
		insert #columnasConfiguracion (name, title, width) values ('marca','Marca',5),('share','Share',10)

	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('marca','Brand',5),('share','Share',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select marca, share from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select marca, share from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select marca, share from #datosFinal

end
GO

