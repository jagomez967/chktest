IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_ClienteComp_T6'))
   exec('CREATE PROCEDURE [dbo].[Fac_ClienteComp_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_ClienteComp_T6] 	
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
	

	if (@cMarcas = 0)
	BEGIN
		insert #marcas(idMarca)
		select idMarca from producto where idProducto in (select idProducto from #productos)
		set @cMarcas = @@ROWCOUNT
	END
	
	
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
	
	if(@cProductos + @cMarcas + @cFamilia + @cCompetenciaPrimaria > 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))		
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca)) 
		set @cProductos = @cProductos + @cMarcas + @cFamilia+ @cCompetenciaPrimaria
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

	create table #Meses
	(
		mes varchar(8)
	)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		idEmpresa int,
		idMarca int,
		mes varchar(8),
		qty numeric(18,5)
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte)
	select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte)
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and r.FechaCreacion between convert(datetime,@fechaDesde) and convert(datetime,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6)

	insert #datos (idEmpresa, idMarca, mes, qty)
	select r.idEmpresa, m.idMarca, r.mes, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reportesMesPdv r
	inner join ReporteProducto rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
		and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = p.idFamilia))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = m.idMarca)) 	
	group by r.idEmpresa, m.idMarca, r.mes

	insert #datos (idEmpresa, idMarca, mes, qty)
	select m.idEmpresa, m.idMarca, r.mes, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join MarcaCompetencia mc on mc.IdMarcaCompetencia = m.IdMarca
	inner join ProductoCompetencia pc on pc.IdProductoCompetencia=p.IdProducto
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = mc.IdMarca))			
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pc.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #familia where idFamilia = (select max(idFamilia) from producto where idProducto = pc.idProducto)))
			and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria f inner join MarcaCompetencia mct on f.idMarca = mct.idMarca where f.idMarca = mc.idMarca and mct.idMarcaCompetencia = mc.idMarcaCompetencia and isnull(mct.esCompetenciaPrimaria,0) = 1))  
	group by m.idEmpresa, m.idMarca, r.mes

	insert #Meses (mes)
	select distinct mes from #datos

	create table #EmpresasMeses
	(
		idEmpresa int,
		mes varchar(8)
	)

	insert #EmpresasMeses (idEmpresa, mes)
	select distinct tmp.idempresa, m.mes
	from #datos tmp
	inner join #Meses m on 1=1

	create table #Resultados
	(
		idEmpresa int,
		idMarca int,
		mes varchar(8),
		qty numeric(18,5)
	)

	insert #Resultados (idEmpresa, mes, qty)
	select te.idEmpresa, te.mes, SUM(isnull(d.qty,0))
	from #EmpresasMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.mes=te.mes
	group by te.idEmpresa, te.mes

	delete from #Resultados where mes in
	(select mes
	from #Resultados
	group by mes
	having sum(qty)=0)

	delete from #Resultados where idEmpresa in
	(select idEmpresa
	from #Resultados
	group by idEmpresa
	having sum(qty)=0)

	select e.idEmpresa, LTRIM(rtrim(e.nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.qty,0), r.mes,1 Visiblelabel
	from #Resultados r
	inner join Empresa e on e.IdEmpresa=r.idEmpresa
	order by r.mes, e.IdEmpresa

	delete from #Resultados

	insert #Resultados (idEmpresa, idMarca, mes, qty)
	select te.idEmpresa, d.idMarca, te.mes, SUM(isnull(d.qty,0))
	from #EmpresasMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.mes=te.mes
	group by te.idEmpresa, idMarca, te.mes

	delete from #Resultados where mes in
	(select mes
	from #Resultados
	group by mes
	having sum(qty)=0)

	delete from #Resultados where idMarca in
	(select idMarca
	from #Resultados
	group by idMarca
	having sum(qty)=0)

	select e.idEmpresa, LTRIM(rtrim(e.nombre)), r.idMarca, ltrim(rtrim(m.Nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.qty,0), r.mes,1 Visiblelabel
	from #Resultados r
	inner join Empresa e on e.IdEmpresa=r.idEmpresa
	inner join Marca m on m.IdMarca=r.idMarca
	order by r.mes, r.IdEmpresa, r.idMarca
end
go



--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20181001,20181031')
-----insert into @p2 values(N'fltpuntosdeventa',N'21257')
-----insert into @p2 values(N'fltusuarios',N'3915')
----insert into @p2 values(N'fltMarcas',N'611')
--exec Fac_ClienteComp_T6 @IdCliente=44,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'



