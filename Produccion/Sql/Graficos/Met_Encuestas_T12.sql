IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Met_Encuestas_T12'))
   exec('CREATE PROCEDURE [dbo].[Met_Encuestas_T12] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Met_Encuestas_T12]
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
	declare @difDias int
	declare @fechaDesdeAnterior varchar(30)
	declare @fechaHastaAnterior varchar(30)

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
	set @fechaDesdeAnterior = CONVERT(varchar,dateadd(day,-@difDias-1,@fechaDesde),112)
	set @fechaHastaAnterior = convert(varchar,dateadd(day,-@difDias-1,@fechaHasta),112)

	create table #Meses
	(
		mes varchar(8)
	)

	--Tablas periodo actual
	create table #datos
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor int,
		varianza decimal,
		nivel int,
		nombre varchar(50),
		idfamilia int,
		idMarca int
	)

	create table #encuestas
	(
		idReporte int,
		idPuntoDeVenta int,
		idCliente int,
		idMarca int,
		idModulo int,
		ponderacion numeric(18,2)
	)

	create table #encuestasMarca
	(
		idReporte int,
		idPuntoDeVenta int,
		idCliente int,
		idMarca int,
		ponderacion numeric(18,2)
	)

	create table #ponderacionMarca
	(
		idMarca int,
		ponderacion numeric(5,1)
	)

	--Tablas periodo anterior
	create table #datosPeriodoAnterior
	(
		id int,
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor int,
		varianza decimal,
		nivel int,
		nombre varchar(50),
		idfamilia int,
		idMarca int
	)

	create table #encuestasPeriodoAnterior
	(
		idReporte int,
		idPuntoDeVenta int,
		idCliente int,
		idMarca int,
		idModulo int,
		ponderacion numeric(18,2)
	)

	create table #encuestasMarcaPeriodoAnterior
	(
		idReporte int,
		idPuntoDeVenta int,
		idCliente int,
		idMarca int,
		ponderacion numeric(18,2)
	)

	create table #ponderacionMarcaPeriodoAnterior
	(
		idMarca int,
		ponderacion numeric(5,1)
	)

	create table #ItemsObligatorios
	(
		idMarca int,
		idModulo int,
		idItem int,
		peso numeric(18,2)
	)

	create table #PresenciaPorFamiliaMarca
	(
		idReporte int,
		idFamiliaMarca int,
		idItem int
	)
	
	-------------------------------------------------------------------------------

	create table #homologacion
	(
		idFamilia int,
		idDatos int
	)

	insert #ItemsObligatorios (idmarca, idmodulo, idItem, peso)
	select mdmi.IdMarca, i.idmodulo, i.iditem, mdmi.ponderacion
	from MD_Item i
	inner join MD_ModuloMarcaItem mdMI on mdmi.IdItem=i.IdItem
	where i.nombre = 'Precio igual o superior al sugerido ?'

	insert #PresenciaPorFamiliaMarca (idreporte, iditem)
	Select r.IdReporte, mdrep.IdItem
	from cliente c
	inner join reporte r on r.idempresa = c.idempresa
	inner join MD_ReporteModuloItem mdRep on mdRep.idreporte = r.idreporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and mdrep.IdMarca=35 and mdrep.IdItem in (444,445,446,447,448) and mdrep.valor1=1

	update #PresenciaPorFamiliaMarca set idFamiliaMarca = 2 where idItem=444
	update #PresenciaPorFamiliaMarca set idFamiliaMarca = 3 where idItem=445
	update #PresenciaPorFamiliaMarca set idFamiliaMarca = 1 where idItem=446
	update #PresenciaPorFamiliaMarca set idFamiliaMarca = 4 where idItem=447
	update #PresenciaPorFamiliaMarca set idFamiliaMarca = 5 where idItem=448

	insert #encuestas (idReporte, idPuntoDeVenta, idCliente, idMarca, idModulo, ponderacion)
	Select r.idreporte, r.IdPuntoDeVenta, c.IdCliente, m.IdMarca, mmod.IdModulo, sum(mdrep.valor1*mdmi.Ponderacion) + 50
	from cliente c
	inner join reporte r on r.idempresa = c.idempresa
	inner join MD_ReporteModuloItem mdRep on mdRep.idreporte = r.idreporte
	inner join MD_ModuloMarcaItem mdMI on mdMI.idmarca = mdRep.idmarca and mdMI.iditem = mdRep.IdItem
	inner join MD_Item mi on mi.iditem = mdmi.iditem
	inner join MD_ModuloMarca mmar on mmar.idmodulo = mi.IdModulo and mmar.IdMarca = mdrep.IdMarca
	inner join MD_Modulo mMod on mMod.idmodulo = mi.IdModulo
	inner join Marca m on m.idmarca = mdMI.idmarca
	inner join FamiliaMarcaPonderacion fmp on fmp.idMarca=m.IdMarca
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and mmod.Activo=1
			and mmar.Activo=1
			and m.Reporte=1
			and not exists (select 1 from #ItemsObligatorios where #ItemsObligatorios.idItem=mi.IdItem)
			and not exists (select 1 from #PresenciaPorFamiliaMarca where #PresenciaPorFamiliaMarca.idFamiliaMarca=fmp.idFamilia and #PresenciaPorFamiliaMarca.idReporte=r.IdReporte)
	group by r.idreporte, r.IdPuntoDeVenta, c.IdCliente, m.IdMarca, mmod.IdModulo

	insert #encuestasPeriodoAnterior (idReporte, idPuntoDeVenta, idCliente, idMarca, idModulo, ponderacion)
	Select r.idreporte, r.IdPuntoDeVenta, c.IdCliente, m.IdMarca, mmod.IdModulo, sum(mdrep.Valor1*mdmi.Ponderacion) + 50
	from cliente c
	inner join reporte r on r.idempresa = c.idempresa
	inner join MD_ReporteModuloItem mdRep on mdRep.idreporte = r.idreporte
	inner join MD_ModuloMarcaItem mdMI on mdMI.idmarca = mdRep.idmarca and mdMI.iditem = mdRep.IdItem
	inner join MD_Item mi on mi.iditem = mdmi.iditem
	inner join MD_ModuloMarca mmar on mmar.idmodulo = mi.IdModulo and mmar.IdMarca = mdrep.IdMarca
	inner join MD_Modulo mMod on mMod.idmodulo = mi.IdModulo
	inner join Marca m on m.idmarca = mdMI.idmarca
	inner join FamiliaMarcaPonderacion fmp on fmp.idMarca=m.IdMarca
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesdeAnterior) and convert(date,@fechaHastaAnterior)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and mmod.Activo=1
			and mmar.Activo=1
			and m.Reporte=1
			and not exists (select 1 from #ItemsObligatorios where #ItemsObligatorios.idItem=mi.IdItem)
			and not exists (select 1 from #PresenciaPorFamiliaMarca where #PresenciaPorFamiliaMarca.idFamiliaMarca=fmp.idFamilia and #PresenciaPorFamiliaMarca.idReporte=r.IdReporte)
	group by r.idreporte, r.IdPuntoDeVenta, c.IdCliente, m.IdMarca, mmod.IdModulo

	--Total por Marca.
	insert #encuestasMarca (idReporte, idPuntoDeVenta, idCliente, idMarca, ponderacion)
	select e.idreporte, e.idPuntoDeVenta, e.idCliente, mmar.IdMarca, sum(e.ponderacion*mmar.Ponderacion/100)
	from #encuestas e
	inner join MD_ModuloMarca mmar on mmar.idmodulo = e.idModulo and mmar.IdMarca=e.idMarca
	group by e.idreporte, e.idPuntoDeVenta, e.idCliente, mmar.IdMarca

	insert #encuestasMarcaPeriodoAnterior (idReporte, idPuntoDeVenta, idCliente, idMarca, ponderacion)
	select e.idreporte, e.idPuntoDeVenta, e.idCliente, mmar.IdMarca, sum(e.ponderacion*mmar.Ponderacion/100)
	from #encuestasPeriodoAnterior e
	inner join MD_ModuloMarca mmar on mmar.idmodulo = e.idModulo and mmar.IdMarca=e.idMarca
	group by e.idreporte, e.idPuntoDeVenta, e.idCliente, mmar.IdMarca

	--NIVEL 0
	insert #ponderacionMarca (idMarca, ponderacion)
	select em.idMarca, avg(ponderacion)
	from #encuestasMarca em
	group by em.idMarca

	insert #ponderacionMarcaPeriodoAnterior (idMarca, ponderacion)
	select em.idMarca, avg(ponderacion)
	from #encuestasMarcaPeriodoAnterior em
	group by em.idMarca

	insert #datos(color, logo, parentId, valor, varianza, nivel, nombre, idfamilia)
	select fm.color,fm.logo,0,cast(sum(pm.ponderacion*fmp.Ponderacion/100) as numeric(5,1)),0,0,fm.nombre,fm.idFamilia
	from #ponderacionMarca pm
	inner join FamiliaMarcaPonderacion	fmp on fmp.idMarca=pm.IdMarca
	inner join FamiliaMarca fm on fm.idFamilia = fmp.idfamilia
	group by fm.color,fm.logo,fm.nombre,fm.nombre,fm.idFamilia
	order by fm.nombre

	insert #datosPeriodoAnterior (color, logo, parentId, valor, varianza, nivel, nombre, idfamilia)
	select fm.color,fm.logo,0,cast(sum(pm.ponderacion*fmp.Ponderacion/100) as numeric(5,1)),0,0,fm.nombre,fm.idFamilia
	from #ponderacionMarcaPeriodoAnterior pm
	inner join FamiliaMarcaPonderacion	fmp on fmp.idMarca=pm.IdMarca
	inner join FamiliaMarca fm on fm.idFamilia = fmp.idfamilia
	group by fm.color,fm.logo,fm.nombre,fm.nombre,fm.idFamilia
	order by fm.nombre

	insert #datos(color, logo, parentId, valor, varianza, nivel, nombre, idfamilia)
	select distinct fm.color,fm.logo,0,0,0,0,fm.nombre,fm.idFamilia
	from FamiliaMarca fm
	inner join FamiliaMarcaPonderacion fmp on fmp.idFamilia=fm.idFamilia
	where not exists(select 1 from #datos where #datos.idfamilia=fm.idFamilia)
					and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = fmp.IdMarca))

	insert #datosPeriodoAnterior(color, logo, parentId, valor, varianza, nivel, nombre, idfamilia)
	select fm.color,fm.logo,0,0,0,0,fm.nombre,fm.idFamilia
	from FamiliaMarca fm
	inner join FamiliaMarcaPonderacion fmp on fmp.idFamilia=fm.idFamilia
	where not exists(select 1 from #datos where #datos.idfamilia=fm.idFamilia)
					and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = fmp.IdMarca))

	insert #homologacion (idFamilia,idDatos) select idfamilia, id from #datos

	--NIVEL 1: por marca

	insert #datos(color, logo, parentId, valor, varianza, nivel, nombre,idMarca)
	select '7ea568',m.Imagen,h.idDatos,cast(pm.ponderacion as int),0,1,m.nombre,m.IdMarca
	from #ponderacionMarca pm
	inner join FamiliaMarcaPonderacion	fmp on fmp.idMarca=pm.IdMarca
	inner join marca m on m.IdMarca=fmp.idmarca
	inner join #homologacion h on h.idFamilia=fmp.idfamilia
	order by m.nombre

	--completo las marcas que no estan por tener 0, aunque no ponderen hay que mostrarlas
	insert #datos(color, logo, parentId, valor, varianza, nivel, nombre,idMarca)
	select '7ea568',m.Imagen,h.idDatos,0,0,1,m.nombre,m.IdMarca
	from FamiliaMarcaPonderacion fmp
	inner join marca m on m.IdMarca=fmp.idmarca
	inner join #homologacion h on h.idFamilia=fmp.idfamilia
	where not exists(select 1 from #datos where #datos.nivel=1 and #datos.idMarca=m.IdMarca) and m.Reporte=1
					and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = fmp.IdMarca))
	order by m.nombre

	insert #datosPeriodoAnterior(color, logo, parentId, valor, varianza, nivel, nombre,idMarca)
	select '7ea568',m.Imagen,h.idDatos,cast(pm.ponderacion as int),0,1,m.nombre,m.IdMarca
	from #ponderacionMarcaPeriodoAnterior pm
	inner join FamiliaMarcaPonderacion	fmp on fmp.idMarca=pm.IdMarca
	inner join marca m on m.IdMarca=fmp.idmarca
	inner join #homologacion h on h.idFamilia=fmp.idfamilia
	order by m.nombre

	--completo las marcas que no estan por tener 0, aunque no ponderen hay que mostrarlas
	insert #datosPeriodoAnterior(color, logo, parentId, valor, varianza, nivel, nombre,idMarca)
	select '7ea568',m.Imagen,h.idDatos,0,0,1,m.nombre,m.IdMarca
	from FamiliaMarcaPonderacion fmp
	inner join marca m on m.IdMarca=fmp.idmarca
	inner join #homologacion h on h.idFamilia=fmp.idfamilia
	where not exists(select 1 from #datosPeriodoAnterior where #datosPeriodoAnterior.nivel=1 and #datosPeriodoAnterior.idMarca=m.IdMarca) and m.Reporte=1
					and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = fmp.IdMarca))
	order by m.nombre

	UPDATE A
	SET A.varianza = A.valor-B.valor
	FROM #datos A, #datosPeriodoAnterior B
	where A.nivel=B.nivel
			and 
			(
				(A.idfamilia is not null and B.idfamilia is not null and A.idfamilia=B.idfamilia)
				or
				(A.idMarca is not null and B.idMarca is not null and A.idMarca=B.idMarca)
			)

	select id, color, logo, parentId, valor, varianza, nivel,nombre,idfamilia,idMarca
	from #datos
	order by nivel, parentId, id
end