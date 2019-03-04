IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Met_Pop_T6'))
   exec('CREATE PROCEDURE [dbo].[Met_Pop_T6] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Met_Pop_T6] 	
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #Meses
	(
		mes varchar(8)
	)
	
	create table #datos
	(
		idEmpresa int,
		idMarca int,
		idPop int,
		mes varchar(20),
		qty numeric(18,5),
		idreporte int
	)
	
	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		idPuntoDeVenta int,
		idCadena int,
		mes varchar(20),
		idReporte int,
		IdEmpresa int
	)
	-------------------------------------------------------------------- END (Temp)
	
	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, idCadena, mes, idReporte,IdEmpresa)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,p.idCadena
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes		
			,max(r.idReporte)
			,r.idempresa
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, p.idCadena, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),r.idempresa
	

	insert #datos (idEmpresa, idMarca,idPop, mes, qty,idreporte)
	select c.idempresa, m.IdMarca, p.idpop, r.mes, sum(isnull(rp.cantidad,0)),r.idReporte
	from pop p
	inner join ReportePop rp on rp.IdPop = p.IdPop
	inner join #tempReporte r on r.IdReporte=rp.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Marca m on m.IdMarca=rp.IdMarca
	where	
			(isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = m.idMarca)) 
			and (isnull(@cMarcas,0) = 0 or exists (select 1 from #marcas where idMarca = m.idMarca))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
		
	group by c.idempresa, m.IdMarca, p.idpop, r.mes,r.idreporte,isnull(rp.cantidad,0)
	order by c.idempresa, m.IdMarca, p.idpop
	

	insert #Meses (mes)
	select distinct mes from #datos
    
	create table #MarcasMeses
	(
		idEmpresa int,
		idMarca int,
		mes varchar(20)
	)
    
	insert #MarcasMeses (idEmpresa, idmarca, mes)
	select distinct tmp.idEmpresa, tmp.idMarca, m.mes
	from #datos tmp
	left join #Meses m on 1=1
    
	create table #Resultados
	(
		idEmpresa int,
		idMarca int,
		idPop int,
		mes varchar(8),
		qty numeric(18,5)
	)
    
	insert #Resultados (idEmpresa, idMarca, mes, qty)
	select te.idEmpresa, te.idMarca, te.mes, SUM(isnull(d.qty,0))
	from #MarcasMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.mes=te.mes
	group by te.idEmpresa, te.idMarca, te.mes
    
	select r.idmarca, LTRIM(rtrim(m.nombre)), r.mes, isnull(r.qty,0), r.mes
	from #Resultados r
	inner join Marca m on m.idmarca=r.idMarca
	order by r.mes, r.idmarca
    
	delete from #Resultados
    
	create table #ProductosMeses
	(
		idEmpresa int,
		idMarca int,
		idPop int,
		mes varchar(8)
	)
    
	insert #ProductosMeses (idEmpresa, idmarca, idPop, mes)
	select distinct tmp.idEmpresa, tmp.idMarca, tmp.idPop, m.mes
	from #datos tmp
	left join #Meses m on 1=1
    
	insert #Resultados (idEmpresa, idMarca, idPop, mes, qty)
	select te.idEmpresa, te.idmarca, te.idPop, te.mes, SUM(isnull(d.qty,0))
	from #ProductosMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.idPop=te.idPop and d.mes=te.mes
	group by te.idEmpresa, te.idmarca, te.idPop, te.mes
    
	select r.idMarca, LTRIM(rtrim(m.nombre)), r.idPop, ltrim(rtrim(p.Nombre)), r.mes, isnull(r.qty,0), r.mes
	from #Resultados r
	inner join marca m on m.IdMarca=r.idMarca
	inner join pop p on p.idpop=r.idPop
	order by r.idMarca, r.mes, r.idPop
end
GO


