IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Sha_MarcaProdComp_T11'))
   exec('CREATE PROCEDURE [dbo].[Sha_MarcaProdComp_T11] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Sha_MarcaProdComp_T11] 	
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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

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
		qty numeric(18,5)
	)
	-------------------------------------------------------------------- END (Temp)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, idReporte)
	select r.idempresa, r.idpuntodeventa, max(r.idreporte)
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
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
	group by r.IdEmpresa, r.IdPuntoDeVenta

	insert #datos (idEmpresa, idMarca, idProducto, qty)
	select r.idEmpresa, m.idMarca, rp.IdProducto, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p2 on p2.idProducto = pc.idProducto
	left join MarcaCompetencia mc on mc.idMarcaCompetencia = m.idMarca
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p2.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = pc.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select max(idFamilia) from producto where idProducto = pc.idProducto)))
	    	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria f inner join MarcaCompetencia mct on f.idMarca = mct.idMarca where f.idMarca = mc.idMarca and mct.idMarcaCompetencia = mc.idMarcaCompetencia and isnull(mct.esCompetenciaPrimaria,0) = 1))  
	group by r.idEmpresa, m.idMarca, rp.IdProducto


	create table #MarcasMeses
	(
		idEmpresa int,
		idMarca int
	)

	insert #MarcasMeses (idEmpresa, idmarca)
	select distinct tmp.idEmpresa, tmp.idMarca from #datos tmp

	create table #Resultados
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		qty numeric(18,5)
	)

	insert #Resultados (idEmpresa, idMarca, qty)
	select te.idEmpresa, te.idMarca, SUM(isnull(d.qty,0))
	from #MarcasMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca
	group by te.idEmpresa, te.idMarca

	delete from #Resultados where idEmpresa in (select idEmpresa from #Resultados group by idEmpresa having sum(qty)=0)
	delete from #Resultados where idMarca in (select idMarca from #Resultados group by idMarca having sum(qty)=0)

	select r.idmarca, LTRIM(rtrim(m.nombre)), isnull(r.qty,0),m.sColor
	from #Resultados r
	inner join Marca m on m.idmarca=r.idMarca
	order by m.sColor, r.idmarca

	delete from #Resultados

	create table #ProductosMeses
	(
		idEmpresa int,
		idMarca int,
		idProducto int
	)

	insert #ProductosMeses (idEmpresa, idmarca, idProducto)
	select distinct tmp.idEmpresa, tmp.idMarca, tmp.idProducto from #datos tmp

	insert #Resultados (idEmpresa, idMarca, idProducto, qty)
	select te.idEmpresa, te.idmarca, te.idProducto, SUM(isnull(d.qty,0))
	from #ProductosMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.idProducto=te.idProducto
	group by te.idEmpresa, te.idmarca, te.idProducto

	delete from #Resultados where idEmpresa in (select idEmpresa from #Resultados group by idEmpresa having sum(qty)=0)
	delete from #Resultados where idMarca in (select idMarca from #Resultados group by idMarca having sum(qty)=0)
	delete from #Resultados where idProducto in (select idProducto from #Resultados group by idProducto having sum(qty)=0)

	select r.idMarca, LTRIM(rtrim(m2.nombre)), r.idProducto, ltrim(rtrim(p2.Nombre)), isnull(r.qty,0)
	from #Resultados r
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = r.idProducto
	inner join Producto p on p.idProducto = pc.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join Marca m2 on m2.idMarca = r.idMarca
	inner join Producto p2 on p2.idProducto = r.idProducto
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
		    and (isnull(@cCompetenciaPrimaria,0) = 0 
					or exists (select 1 from #CompetenciaPrimaria f 
								inner join MarcaCompetencia mct 
									on f.idMarca = mct.idMarca 
								where f.idMarca = m.idMarca 
									and mct.idMarcaCompetencia = (select max(isnull(idmarca,-1))from producto where idProducto = r.idProducto) 
								and isnull(mct.esCompetenciaPrimaria,0) = 1))
	order by r.idMarca, r.idProducto
end
GO

