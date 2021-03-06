IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_ShaPropio_Usuario_T12'))
   exec('CREATE PROCEDURE [dbo].[Mattel_ShaPropio_Usuario_T12] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].[Mattel_ShaPropio_Usuario_T12]
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
	declare @difDias int
	declare @strFDesdePeriodoAnterior varchar(30)
	declare @strFHastaPeriodoAnterior varchar(30)
	
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


	set @difDias = DATEDIFF(DAY, @fechaDesde, @fechaHasta)
	set @strFDesdePeriodoAnterior = CONVERT(varchar,dateadd(day,-@difDias-1,@fechaDesde),112)
	set @strFHastaPeriodoAnterior = convert(varchar,dateadd(day,-@difDias-1,@fechaHasta),112)

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int,
		idUsuarioCargo int
	)

		create table #reportesMesPdvPeriodoAnterior
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idUsuario int,
		idUsuarioCargo int
	)

	create table #datos
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int,
		idUsuario int,
		idUsuarioCargo int
	)

	create table #datosPeriodoAnterior
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int,
		idUsuario int,
		idUsuarioCargo int
	)

	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte, idUsuario, idUsuarioCargo)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), r.idreporte, r.IdUsuario, uua.IdUsuario
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Usuario_UsuarioACargo uua on uua.IdUsuarioACargo = r.IdUsuario
	where	uua.activo = 1 and c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))

			
	insert #reportesMesPdvPeriodoAnterior (idEmpresa, idPuntoDeVenta, mes, idReporte, idUsuario, idUsuarioCargo)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), r.idreporte, r.IdUsuario, uua.idusuario
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join Usuario_UsuarioACargo uua on uua.IdUsuarioACargo = r.IdUsuario
	where	uua.activo = 1 and c.IdCliente=@IdCliente
			and r.FechaCreacion between @strFDesdePeriodoAnterior and @strFHastaPeriodoAnterior
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))


	insert #datos(idEmpresa, idUsuarioCargo, valor)
	select r.idempresa, r.idUsuarioCargo, sum(isnull(rp.precio,0))
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where isnull(rp.precio,0)>0
	group by  r.idUsuarioCargo, r.idEmpresa

	insert #datos (idEmpresa, idUsuarioCargo, valor)
	select m.idempresa, r.idUsuarioCargo, sum(isnull(rp.precio,0))
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.precio,0)>0
	group by  r.idUsuarioCargo, m.IdEmpresa

	update #datos set valor=valor*100.0/(select sum(valor) from #datos)
		
	insert #datosPeriodoAnterior(idEmpresa, idUsuarioCargo, valor)
	select r.idempresa, r.idUsuarioCargo, sum(isnull(rp.precio,0))
	from #reportesMesPdvPeriodoAnterior r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where isnull(rp.precio,0)>0
	group by  r.IdEmpresa, r.idUsuarioCargo

	insert #datosPeriodoAnterior (idEmpresa, idUsuarioCargo, valor)
	select m.idempresa, r.idUsuarioCargo, sum(isnull(rp.precio,0))
	from #reportesMesPdvPeriodoAnterior r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.precio,0)>0
	group by  m.idempresa, r.idUsuarioCargo

	update #datosPeriodoAnterior set valor=valor*100.0/(select sum(valor) from #datosPeriodoAnterior)

	create table #sharePorSupervisor
	(
		id int identity(1,1),
		idEmpresa int,
		idSupervisor int,
		valor decimal(10,2),
		varianza decimal(10,2)
	)


	create table #sharePorSupervisorAnterior
	(
		idEmpresa int,
		idSupervisor int,
		valor decimal(10,2),
		varianza decimal(10,2)
	)

	insert #sharePorSupervisor (idEmpresa, idSupervisor, valor, varianza)
	select d.idEmpresa, d.idUsuarioCargo, d.valor*100.0/(select sum(#datos.valor) from #datos where #datos.idUsuarioCargo=d.idUsuarioCargo), 0
	from #datos d
	inner join cliente c on c.IdEmpresa=d.idempresa
	where c.IdCliente=@IdCliente


	insert #sharePorSupervisorAnterior (idEmpresa, idSupervisor, valor, varianza)
	select d.idEmpresa, d.idUsuarioCargo, d.valor*100.0/(select sum(#datosPeriodoAnterior.valor) from #datosPeriodoAnterior where #datosPeriodoAnterior.idUsuarioCargo=d.idUsuarioCargo), 0
	from #datosPeriodoAnterior d
	inner join cliente c on c.IdEmpresa=d.idempresa
	where c.IdCliente=@IdCliente 


	update A
	set A.varianza = A.valor - B.valor
	from #sharePorSupervisor A, #sharePorSupervisorAnterior B
	where A.idEmpresa = B.idEmpresa and A.idSupervisor = B.idSupervisor

	select d.id as id
	,'7EA568' as color
	,u.imagen as logo
	,0 as nivel
	,d.valor as valor
	,isnull(d.varianza,0) as varianza
	,0 as parentId
	,u.Apellido+', '+u.nombre collate database_default as nombre
	from #sharePorSupervisor d
	inner join Usuario u on u.IdUsuario = d.idSupervisor
	inner join Empresa e on e.IdEmpresa = d.idempresa
	order by d.id

	
end
/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181101,20181130')
--insert into @p2 values(N'fltpuntosdeventa',N'187189')
---insert into @p2 values(N'fltusuarios',N'3915')
--insert into @p2 values(N'fltMarcas',N'648')

exec Mattel_ShaPropio_Usuario_T12 @IdCliente=6,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/


