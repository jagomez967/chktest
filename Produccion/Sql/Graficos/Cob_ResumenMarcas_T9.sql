IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_ResumenMarcas_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_ResumenMarcas_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Cob_ResumenMarcas_T9]
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

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #meses
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes,qty) select convert(varchar, @fechaDesdeMeses,112),0
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end


	create table #asignados
	(
		id int
		,idUsuario int
		,idPuntoDeVenta int
	)

	create table #Relevados
	(
		idUsuario int,
		qty int
	)

	create table #datos
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)


	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	declare @i int = 1
	declare @max int
	declare @currentFechaHasta datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU

		select @fechaHasta=dateadd(day,-1,DATEADD(month,1,mes)) from #meses where id=@i
		set @currentFechaHasta = dateadd(month,1,dateadd(day,-day(@fechaHasta),@fechaHasta))

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join usuario_cliente cu on cu.idcliente=pcu.idcliente and pcu.idusuario=cu.idusuario
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
				and pcu.idCliente = @idcliente
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta)
		select @i, idUsuario, IdPuntoDeVenta
		from #tempPCU
		
		set @i=@i+1
	end


	insert #tempReporte ( idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and r.idEmpresa = @idEmpresa			
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))	
	group by r.IdUsuario ,r.IdPuntoDeVenta ,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #Relevados (idUsuario, qty)
	select idUsuario, count(distinct idPuntoDeVenta) from #tempReporte
	where mes = (select max(mes) from #tempReporte)
	group by idUsuario
	

	create table #RelevadosTotal
	(
		idUsuario int,
		qty int
	)

	insert #RelevadosTotal (idUsuario, qty)
	select idUsuario, count(IdPuntoDeVenta) from #tempReporte group by idUsuario

	create table #CantAsignados
	(
		idUsuario int,
		qty int
	)

	insert #CantAsignados (idUsuario, qty)
	select idUsuario, count(distinct idPuntoDeVenta) from #asignados group by idUsuario

	
	declare @porcentajetotal numeric(12,5)
	select @porcentajetotal = r.qty*100.0/a.qty
	from
	 (select sum(qty) as qty from #Relevados) r
	 ,(select sum (qty) as qty from #CantAsignados) a
	
	
	declare @PdvsExhibicionAnterior int
	select @PdvsExhibicionAnterior = count(distinct idPuntoDeVenta) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	where isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select idFamilia from producto where idProducto = rp.idProducto)))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = (select idMarca from producto where idProducto = rp.idProducto))) 

	declare @PdvsExhibicion int
	select @PdvsExhibicion = count(distinct idPuntoDeVenta) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	where (isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0) and mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select idFamilia from producto where idProducto = rp.idProducto)))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = (select idMarca from producto where idProducto = rp.idProducto)))
	

	--EXHIBICION (varios meses)
	create table #ExhFinal
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #ExhFinal (idMarca, qty1)
	select p.IdMarca, count(distinct t.idpuntodeventa)*100.00/@PdvsExhibicionAnterior from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on rp.IdProducto = p.IdProducto
	where isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
	group by p.IdMarca

	--EXHIBICION (ultimo mes)
	create table #ExhFinalTAM
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #ExhFinalTAM (idMarca, qty1)
	select p.IdMarca, count(distinct t.idpuntodeventa)*100.00/@PdvsExhibicion from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on rp.IdProducto = p.IdProducto
	where (isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0) and mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
	group by p.IdMarca


	declare @totalFrentesAnterior int
	select @totalFrentesAnterior = sum(isnull(rp.Cantidad,0))+sum(isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	where (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select idFamilia from producto where idProducto = rp.idProducto)))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = (select idMarca from producto where idProducto = rp.idProducto)))

	declare @totalFrentes int
	select @totalFrentes = sum(isnull(rp.Cantidad,0))+sum(isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	where mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select idFamilia from producto where idProducto = rp.idProducto)))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = (select idMarca from producto where idProducto = rp.idProducto)))
	

	--FACING PROM (varios meses)
	create table #FacPromFinal
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #FacPromFinal (idMarca, qty1)
	select p.idMarca, (sum(isnull(rp.Cantidad,0))+sum(isnull(rp.Cantidad2,0)))*1.0/count(distinct t.idPuntoDeVenta) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	where (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = (select idFamilia from producto where idProducto = rp.idProducto)))	
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
	group by p.IdMarca


	--FACING PROM (ultimo mes)
	create table #FacPromFinalTAM
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #FacPromFinalTAM (idMarca, qty1)
	select p.idMarca, (sum(isnull(rp.Cantidad,0))+sum(isnull(rp.Cantidad2,0)))*1.0/count(distinct t.idPuntoDeVenta) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	where mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))

	group by p.IdMarca


	create table #datosFac
	(
		idMarca int,
		qty int
	)

	insert #datosFac (idMarca, qty)
	select p.idMarca, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
	group by p.IdMarca

	
	create table #datosFacComp
	(
		idMarca int,
		qty int
	)

	insert #datosFacComp (idMarca, qty)
	select p.idMarca, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProductoCompetencia rp on rp.IdReporte = t.idReporte
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p on p.idProducto = pc.idProducto
	where (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
		and p.idMarca not in (607, 611)
	group by p.IdMarca
	

	insert #datosFacComp (idMarca, qty)
	select etl.[id marca], SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProductoCompetencia rp on rp.IdReporte = t.idReporte
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p on p.idProducto = pc.idProductoCompetencia
	inner join Producto p2 on p2.idProducto = pc.idProducto
	inner join competenciaPrimariaAndromaco etl on etl.ID_MARCACOMP = p.idMarca and etl.[ID MARCA] = p2.idMarca
	where (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
		and etl.[id marca] in (607, 611)
	group by etl.[id marca]


	--FAC SHARE (varios meses)
	create table #FacShareFinal
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #FacShareFinal (idMarca, qty1)
	select d.idMarca, isnull(d.qty,0)*100.00/sum(isnull(d.qty,0)+isnull(d2.qty,0)) from #datosFac d
	inner join #datosFacComp d2 on d.idMarca = d2.idMarca
	group by d.idMarca, d.qty



	create table #datosFacUlt
	(
		idMarca int,
		qty int
	)

	insert #datosFacUlt (idMarca, qty)
	select p.idMarca, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where t.mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))
	group by p.IdMarca

	
	create table #datosFacCompUlt
	(
		idMarca int,
		qty int
	)

	insert #datosFacCompUlt (idMarca, qty)
	select p.idMarca, SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0)) from #tempReporte t
	inner join ReporteProductoCompetencia rp on rp.IdReporte = t.idReporte
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p on p.idProducto = pc.idProducto
	where t.mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.idFamilia))
				and (isnull(@cCompetenciaPrimaria,0) = 0 
					or exists (select 1 from #CompetenciaPrimaria f 
								inner join MarcaCompetencia mct 
									on f.idMarca = mct.idMarca 
								where f.idMarca = p.idMarca 
									and mct.idMarcaCompetencia = (select max(isnull(idmarca,-1))from producto where idProducto = rp.idProducto) 
								and isnull(mct.esCompetenciaPrimaria,0) = 1))
	group by p.IdMarca

	--FAC SHARE (ultimo mes)
	create table #FacShareFinalTAM
	(
		idMarca int,
		qty1 decimal(18,2)
	)

	insert #FacShareFinalTAM (idMarca, qty1)
	select d.idMarca, isnull(d.qty,0)*100.00/sum(isnull(d.qty,0)+isnull(d2.qty,0)) from #datosFacUlt d
	inner join #datosFacCompUlt d2 on d.idMarca = d2.idMarca
	group by d.idMarca, d.qty

	---Quiebre Total
	create table #QuiebreFinal(idMarca int, qty decimal(18,2))

	insert #QuiebreFinal(idMarca,qty)
	select p.idMarca, SUM(isnull(rp.Stock,0))*100.0/COUNT(ISNULL(rp.stock,1))*1.0 
	from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where (isnull(@cFamilia,0) = 0 or exists(select 1 
											 from #Familia 
											 where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 
													    from #CompetenciaPrimaria 
														where idMarca = p.idMarca))
	group by p.IdMarca

	---Quiebre Total TAM
	create table #QuiebreFinalTAM(idMarca int, qty decimal(18,2))

	insert #QuiebreFinalTAM(idMarca,qty)
	select p.idMarca, SUM(isnull(rp.Stock,0))*100.0/COUNT(ISNULL(rp.stock,1))*1.0 
	from #tempReporte t
	inner join ReporteProducto rp on rp.IdReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	where t.mes = (select max(mes) from #tempReporte)
	and (isnull(@cFamilia,0) = 0 or exists(select 1 
											 from #Familia 
											 where idFamilia = p.idFamilia))
	and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 
													    from #CompetenciaPrimaria 
														where idMarca = p.idMarca))
	group by p.IdMarca



	---Datos final
	create table #datosFinal
	(
		id int identity(1,1),
		NomMarca varchar(max),
		objcob decimal(18,2),
		cobpdv decimal(18,2),
		cobtam decimal(18,2),
		objexh decimal(18,2),
		exhlin decimal(18,2),
		exhlintam decimal(18,2),
		objfacp decimal(18,2),
		facprom decimal(18,2),
		facpromtam decimal(18,2),
		objfacs decimal(18,2),
		facshare decimal(18,2),
		facsharetam decimal(18,2),
		objquieb decimal(18,2), 
		quiebres decimal(18,2),
		quiebresTAM decimal(18,2) 
	)

	insert #datosFinal (NomMarca, objcob, cobpdv, cobtam, objexh, exhlin, exhlintam, objfacp, facprom, facpromtam, objfacs, facshare, facsharetam,objquieb, quiebres, quiebresTAM )
	select	ltrim(rtrim(e.NombreMarca)),
			isnull(e.Obj_Cobertura,0)*100.0,
			@porcentajetotal,
			@porcentajetotal/(select count(distinct mes) from #tempReporte),
			isnull(e.Obj_Cob_Linea,0)*100.0,
			isnull(ef.qty1,0),
			isnull(eft.qty1,0),
			isnull(e.Obj_Facing_Prom,0),
			isnull(fpf.qty1,0),
			isnull(fpft.qty1,0),
			isnull(e.Obj_Facing_Share,0)*100.0,
			isnull(fsf.qty1,0),
			isnull(fsft.qty1,0),
			ISNULL(e.Obj_Quiebres,0)*100.0,
			ISNULL(qf.qty,0),
			ISNULL(qft.qty,0)
	from ETL_Andromaco_ObjetivoMarcas e
	inner join #ExhFinal ef on ef.idMarca = e.IdMarca
	inner join #ExhFinalTAM eft on eft.idMarca = e.IdMarca
	inner join #FacPromFinal fpf on fpf.idMarca = e.IdMarca
	inner join #FacPromFinalTAM fpft on fpft.idMarca = e.IdMarca
	inner join #FacShareFinal fsf on fsf.idMarca = e.IdMarca
	inner join #FacShareFinalTAM fsft on fsft.idMarca = e.IdMarca
	inner join #quiebreFinal qf on qf.idMarca = e.IdMarca 
	inner join #quiebreFinalTAM qft on qft.idMarca = e.idMarca
	where ((isnull(@cTipoRTM,0) = 0 and isnull(e.idTipoRTM,0) = 0) or exists(select 1 from Perfil p where p.IdPerfil = e.idTipoRTM and p.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	


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

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) 
		values ('NomMarca','Marca',0), 
			   ('objcob','Objetivo',50),
			   ('cobpdv','Cobertura de Pdv',30),
			   ('cobtam','Cobertura WAM',30),
			   ('objexh','Objetivo',30),
			   ('exhlin','Exhibicion Lineario',30),
			   ('exhlintam','Cob Linea WAM',30),
			   ('objfacp','Objetivo',30),
			   ('facprom','Facing prom',30),
			   ('facpromtam','Facing Prom WAM',30),
			   ('objfacs','Objetivo',30),
			   ('facshare','Facing Share',30),
			   ('facsharetam','Facing Share WAM',30),
			   ('objquieb','Objetivo',30),
			   ('quiebres','Quiebres',30),
			   ('quiebresTAM','Quiebres WAM',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) 
		values ('NomMarca','Marca',0), 
			   ('objcob','Objetivo',50),
			   ('cobpdv','Cobertura de Pdv',30),
			   ('cobtam','Cobertura WAM',30),
			   ('objexh','Objetivo',30),
			   ('exhlin','Exhibicion Lineario',30),
			   ('exhlintam','Cob Linea WAM',30),
			   ('objfacp','Objetivo',30),
			   ('facprom','Facing prom',30),
			   ('facpromtam','Facing Prom WAM',30),
			   ('objquieb','Objetivo',30),
			   ('quiebres','Quiebres',30),
			   ('quiebresTAM','Quiebres WAM',30)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select NomMarca, objcob, cobpdv, cobtam, objexh, exhlin, exhlintam, objfacp, facprom, facpromtam, objfacs, facshare, facsharetam, objquieb, quiebres, quiebresTAM from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select NomMarca, objcob, cobpdv, cobtam, objexh, exhlin, exhlintam, objfacp, facprom, facpromtam, objfacs, facshare, facsharetam, objquieb, quiebres, quiebresTAM from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select NomMarca, objcob, cobpdv, cobtam, objexh, exhlin, exhlintam, objfacp, facprom, facpromtam, objfacs, facshare, facsharetam, objquieb, quiebres, quiebresTAM from #datosFinal
end
go

--[Cob_ResumenMarcas_T9] 44