IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_PromedioMarcaProd_T6'))
   exec('CREATE PROCEDURE [dbo].[Fac_PromedioMarcaProd_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_PromedioMarcaProd_T6] 	
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
	create table #Categoria
	(
		idCategoria int
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
	declare @cCategoria varchar(max)

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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

		declare @idEmpresa int 
	select @idEmpresa = idEmpresa from cliente where idCliente = @idCliente
	---NUEVO: Unificacion de filtros (Productos)
	
	if(@cProductos + @cMarcas + @cFamilia + @cCompetenciaPrimaria> 0)
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
		set @cProductos = @cProductos + @cMarcas + @cFamilia + @cCompetenciaPrimaria
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


	create table #Meses
	(
		mes varchar(8)
	)

	create table #FacingPromedioMarca
	(
		idEmpresa int,
		mes varchar(8),
		idMarca int,
		pdvs int,
		facing numeric(10,2),
		promedio numeric(10,2)
	)

	create table #FacingPromedioProducto
	(
		idEmpresa int,
		mes varchar(8),
		idMarca int,
		idProducto int,
		pdvs int,
		facing numeric(10,2),
		promedio numeric(10,2)
	)

	create table #tempReporte
	(
		idEmpresa int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temp)

	insert #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	r.idEmpresa
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	where	r.IdEmpresa = @idEmpresa
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by r.idEmpresa, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)

	insert #FacingPromedioProducto (idEmpresa, mes, idMarca, idProducto, pdvs, facing, promedio)
	select r.idEmpresa
			,r.mes
			,p.IdMarca
			,p.IdProducto
			,count(distinct r.idpuntodeventa) as pdvs
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0 as facing
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0/count(distinct r.idpuntodeventa) as promedio
	from #tempReporte r
	inner join ReporteProducto rp on rp.IdReporte = r.IdReporte
	inner join producto p on p.IdProducto = rp.IdProducto
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))		
			and (isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0)
	group by r.IdEmpresa, r.mes, p.IdMarca, p.IdProducto
	
	insert #FacingPromedioMarca (idEmpresa, mes, idMarca, pdvs, facing, promedio)
	select idEmpresa,mes,idMarca,sum(pdvs),sum(facing),sum(facing)/sum(pdvs) from #facingPromedioProducto
	group by IdEmpresa, mes, IdMarca

	
	insert #Meses (mes)
	select distinct mes from #FacingPromedioMarca

	create table #MarcasMeses
	(
		idEmpresa int,
		idMarca int,
		mes varchar(8)
	)

	insert #MarcasMeses (idEmpresa, idmarca, mes)
	select distinct tmp.idEmpresa, tmp.idMarca, m.mes
	from #FacingPromedioMarca tmp
	left join #Meses m on 1=1

	create table #ResultadosMarca
	(
		idEmpresa int,
		mes varchar(8),
		idMarca int,
		pdvs int,
		facing numeric(10,2),
		promedio numeric(10,2)
	)

	insert #ResultadosMarca (idEmpresa, mes, idMarca, pdvs, facing, promedio)
	select te.idEmpresa, te.mes, te.idMarca, d.pdvs, d.facing, d.promedio
	from #MarcasMeses te
	left join #FacingPromedioMarca d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.mes=te.mes

	delete from #ResultadosMarca where mes in
	(select mes
	from #ResultadosMarca
	group by mes
	having sum(promedio)=0)

	delete from #ResultadosMarca where idEmpresa in
	(select idEmpresa
	from #ResultadosMarca
	group by idEmpresa, idMarca
	having sum(promedio)=0)

	select r.idmarca, LTRIM(rtrim(m.nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes),6),6), isnull(r.promedio,0), r.mes
	from #ResultadosMarca r
	inner join Marca m on m.idmarca=r.idMarca
	order by r.mes, r.idmarca

	create table #ProductosMeses
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		mes varchar(8)
	)

	insert #ProductosMeses (idEmpresa, idmarca, idProducto, mes)
	select distinct tmp.idEmpresa, tmp.idMarca, tmp.idProducto, m.mes
	from #FacingPromedioProducto tmp
	left join #Meses m on 1=1

	create table #ResultadosProductos
	(
		idEmpresa int,
		mes varchar(8),
		idMarca int,
		idProducto int,
		pdvs int,
		facing numeric(10,2),
		promedio numeric(10,2)
	)

	insert #ResultadosProductos (idEmpresa, idMarca, idProducto, mes, promedio)
	select te.idEmpresa, te.idmarca, te.idProducto, te.mes, SUM(isnull(d.promedio,0))
	from #ProductosMeses te
	left join #FacingPromedioProducto d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.idProducto=te.idProducto and d.mes=te.mes
	group by te.idEmpresa, te.idmarca, te.idProducto, te.mes

	delete from #ResultadosProductos where mes in
	(select mes
	from #ResultadosProductos
	group by mes
	having sum(promedio)=0)

	delete from #ResultadosProductos where idProducto in
	(select idProducto
	from #ResultadosProductos
	group by idMarca, idProducto
	having sum(promedio)=0)

	select r.idMarca, LTRIM(rtrim(m.nombre)), r.idProducto, ltrim(rtrim(p.Nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes),6),6), isnull(r.promedio,0), r.mes
	from #ResultadosProductos r
	inner join marca m on m.IdMarca=r.idMarca
	inner join producto p on p.IdProducto=r.idProducto
	order by r.idMarca, r.mes, r.idProducto
end
go

--Fac_PromedioMarcaProd_T6 44