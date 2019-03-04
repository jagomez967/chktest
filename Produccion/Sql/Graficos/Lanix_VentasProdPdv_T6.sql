IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_VentasProdPdv_T6'))
   exec('CREATE PROCEDURE [dbo].[Lanix_VentasProdPdv_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Lanix_VentasProdPdv_T6] 	
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

	create table #Pop
	(
		idPop int
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
	declare @cPop varchar(max)

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

	insert #Pop (idPop) select clave as idPop from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPop'),',') where isnull(clave,'')<>''
	set @cPop = @@ROWCOUNT
	
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
		idPuntoDeVenta int,
		mesStr varchar(8),
		mes varchar(8),
		qty numeric(18,5)
	)
	-------------------------------------------------------------------- END (Temp)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte)
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
	group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6)

	insert #datos (idEmpresa, idPuntoDeVenta, mesStr, mes, qty)
	select r.idEmpresa, r.idPuntoDeVenta, convert(varchar(3),r.fechaCreacion)+' '+cast(year(r.fechaCreacion) as varchar(4)), tmp.mes, SUM(isnull(rp.Cantidad,0))
	from Reporte r
	inner join ReportePop rp on rp.IdReporte=r.IdReporte
	inner join Pop_Marca pm on pm.idPop = rp.idPop
	inner join #reportesMesPdv tmp on tmp.idReporte=r.IdReporte
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = pm.IdMarca))
			and (isnull(@cPop,0) = 0 or exists(select 1 from #pop where idPop = rp.idPop))
	group by r.idEmpresa, r.idPuntoDeVenta, convert(varchar(3),r.fechaCreacion)+' '+cast(year(r.fechaCreacion) as varchar(4)), tmp.mes

	insert #Meses (mes)
	select distinct mes from #datos

	create table #ProductosMeses
	(
		idEmpresa int,
		mesStr varchar(8),
		mes varchar(8)
	)

	insert #ProductosMeses (idEmpresa, mesStr, mes)
	select distinct tmp.idEmpresa, tmp.mesStr, m.mes
	from #datos tmp
	left join #Meses m on 1=1



	create table #Resultados
	(
		idEmpresa int,
		mesStr varchar(8),
		idPuntoDeVenta int,
		mes varchar(8),
		qty numeric(18,5)
	)

	insert #Resultados (idEmpresa, mesStr, mes, qty)
	select te.idEmpresa, te.mesStr, te.mes, SUM(isnull(d.qty,0))
	from #ProductosMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.mesStr=te.mesStr and d.mes=te.mes
	group by te.idEmpresa, te.mesStr, te.mes

	delete from #Resultados where mesStr in (select mesStr from #Resultados group by mesStr having sum(qty)=0)
	delete from #Resultados where mes in (select mes from #Resultados group by mes having sum(qty)=0)

	select 0, LTRIM(rtrim(mesStr)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.qty,0), r.mes
	from #Resultados r
	order by r.mes, mesStr

	delete from #Resultados

	create table #PdvMeses
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mesStr varchar(8),
		mes varchar(8)
	)

	insert #PdvMeses (idEmpresa, idPuntoDeVenta, mesStr, mes)
	select distinct tmp.idEmpresa, tmp.idPuntoDeVenta, tmp.mesStr, m.mes
	from #datos tmp
	left join #Meses m on 1=1

	insert #Resultados (idEmpresa, idPuntoDeVenta, mesStr, mes, qty)
	select te.idEmpresa, te.idPuntoDeVenta, te.mesStr, te.mes, SUM(isnull(d.qty,0))
	from #PdvMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idPuntoDeVenta=te.idPuntoDeVenta and d.mesStr=te.mesStr and d.mes=te.mes
	group by te.idEmpresa, te.idPuntoDeVenta, te.mesStr, te.mes

	--delete from #Resultados where idPuntoDeVenta in (select idPuntoDeVenta from #Resultados group by idPuntoDeVenta having sum(qty)=0)
	--delete from #Resultados where mes in (select mes from #Resultados group by mes having sum(qty)=0)
	--delete from #Resultados where mesStr in (select mesStr from #Resultados group by mesStr having sum(qty)=0)

	delete from #Resultados where isnull(qty,0) = 0

	select 0, LTRIM(rtrim(mesStr)), r.idPuntoDeVenta, ltrim(rtrim(pdv.Nombre)), right(CONVERT(VARCHAR(11),convert(datetime,r.mes+'01'),6),6), isnull(r.qty,0), r.mes
	from #Resultados r
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
	order by r.idPuntoDeVenta, r.mes, mesStr
end