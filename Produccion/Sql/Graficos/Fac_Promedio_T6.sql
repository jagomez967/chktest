IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_Promedio_T6'))
   exec('CREATE PROCEDURE [dbo].[Fac_Promedio_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_Promedio_T6] 	
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

	insert #competenciaPrimaria (idMarca) select clave as idMarcaComp from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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

	create table #Meses
	(
		mes varchar(8)
	)

	create table #FacingPromedioMarca
	(
		idEmpresa int,
		mes varchar(6),
		idMarca int,
		pdvs int,
		facing numeric(10,2),
		promedio numeric(10,2)
	)

	create table #FacingPromedioProducto
	(
		idEmpresa int,
		mes varchar(6),
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
		mes varchar(6),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temp)
	insert #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.idEmpresa
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,left(convert(varchar,r.fechacreacion,112),6)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	where	c.idCliente = @idcliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))	
	group by c.idEmpresa, r.IdUsuario, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6)

	insert #FacingPromedioMarca (idEmpresa, mes, idMarca, pdvs, facing, promedio)
	select m.idEmpresa
			,rt.mes
			,p.IdMarca
			,count(distinct rt.idpuntodeventa) as pdvs
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0 as facing
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0/count(distinct rt.idpuntodeventa) as promedio
	from #tempReporte rt
	inner join cliente c on c.IdEmpresa=rt.IdEmpresa
	inner join ReporteProductoCompetencia rp on rp.IdReporte = rt.IdReporte
	inner join producto p on p.IdProducto = rp.IdProducto
	inner join marca m on m.IdMarca=p.IdMarca
	left join productoCompetencia pc on pc.idProductoCompetencia = p.idProducto
	left join producto propio on propio.idProducto = pc.idProducto
	where	c.IdCliente=@IdCliente
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = propio.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = propio.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = propio.IdFamilia))
			and (isnull(@cCompetenciaPrimaria,0) = 0 
					or exists (select 1 from #CompetenciaPrimaria f 
								inner join MarcaCompetencia mct 
									on f.idMarca = mct.idMarca 
								where f.idMarca = propio.idMarca 
									and mct.idMarcaCompetencia = (select max(isnull(idmarca,-1))from producto where idProducto = p.idProducto) 
								and isnull(mct.esCompetenciaPrimaria,0) = 1))
	group by m.IdEmpresa, rt.mes, p.IdMarca

	insert #FacingPromedioProducto (idEmpresa, mes, idMarca, idProducto, pdvs, facing, promedio)
	select m.idEmpresa
			,rt.mes
			,p.IdMarca
			,p.IdProducto
			,count(distinct rt.idpuntodeventa) as pdvs
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0 as facing
			,sum(isnull(rp.cantidad,0) + isnull(rp.cantidad2,0))*1.0/count(distinct rt.idpuntodeventa) as promedio
	from #tempReporte rt
	inner join cliente c on c.IdEmpresa=rt.IdEmpresa
	inner join ReporteProductoCompetencia rp on rp.IdReporte = rt.IdReporte
	inner join producto p on p.IdProducto = rp.IdProducto
	inner join marca m on m.IdMarca=p.IdMarca
	left join productoCompetencia pc on pc.idProductoCompetencia = p.idProducto
	left join producto propio on propio.idProducto = pc.idProducto
	where	c.IdCliente=@IdCliente
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = propio.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = propio.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = propio.IdFamilia))
			and (isnull(@cCompetenciaPrimaria,0) = 0 
					or exists (select 1 from #CompetenciaPrimaria f 
								inner join MarcaCompetencia mct 
									on f.idMarca = mct.idMarca 
								where f.idMarca = propio.idMarca 
									and mct.idMarcaCompetencia = (select max(isnull(idmarca,-1))from producto where idProducto = p.idProducto) 
								and isnull(mct.esCompetenciaPrimaria,0) = 1))
	group by m.IdEmpresa, rt.mes, p.IdMarca, p.IdProducto

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
		mes varchar(6),
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

	select r.idmarca, LTRIM(rtrim(m.nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.promedio,0), r.mes
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
		mes varchar(6),
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

	select r.idMarca, LTRIM(rtrim(m.nombre)), r.idProducto, ltrim(rtrim(p.Nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.promedio,0), r.mes
	from #ResultadosProductos r
	inner join marca m on m.IdMarca=r.idMarca
	inner join producto p on p.IdProducto=r.idProducto
	order by r.idMarca, r.mes, r.idProducto
end
go
