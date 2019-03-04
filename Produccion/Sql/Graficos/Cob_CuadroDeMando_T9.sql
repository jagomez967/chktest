IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_CuadroDeMando_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_CuadroDeMando_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Cob_CuadroDeMando_T9]
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
		idEmpresa int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	
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
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta)
		select @i, idUsuario, IdPuntoDeVenta
		from #tempPCU
		
		set @i=@i+1
	end


	insert #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	r.idEmpresa
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and r.idEmpresa = @idEmpresa
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by r.idEmpresa ,r.IdUsuario ,r.IdPuntoDeVenta ,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #datos (idMarca, qty)
	select m.idMarca, count(distinct a.idpuntodeventa) 
	from #asignados a, Marca m
	where m.idEmpresa = @idEmpresa and m.Reporte = 1
	group by m.idMarca


	create table #datosDist
	(
		idMarca int,
		qty1 int,
		qty2 decimal(18,2),
		mes varchar(8)
	)

	insert #datosDist (idMarca, qty1, qty2, mes)
	select m.idMarca, count(distinct t.idPuntoDeventa), count(distinct t.idPuntoDeVenta)*100/d.qty, t.mes 
	from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join #datos d on d.idMarca = m.idMarca
	where isnull(rp.Stock,0) = 0
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by m.idMarca, d.qty, t.mes


	create table #datosExh
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	insert #datosExh (idMarca, qty, mes)
	select m.idMarca, count(distinct t.idPuntoDeventa), t.mes from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join #datos d on d.idMarca = m.idMarca
	where isnull(rp.Cantidad,0) > 0
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.IdProducto))
	group by m.idMarca, d.qty, t.mes
	

	create table #datosFac
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	insert #datosFac (idMarca, qty, mes)
	select m.idMarca, sum(isnull(Cantidad,0))+sum(isnull(cantidad2,0)), t.mes from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join #datos d on d.idMarca = m.idMarca
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.IdProducto))
	group by m.idMarca, t.mes


	create table #datosPOP
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	insert #datosPOP (idMarca, qty, mes)
	select rp.idMarca, sum(isnull(rp.Cantidad,0)), t.mes from #tempReporte t
	inner join ReportePop rp on rp.idReporte = t.idReporte
	group by rp.idMarca, t.mes
		
	
	create table #datosQuiebre
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	insert #datosQuiebre (idMarca, qty, mes)
	select m.idMarca, count(distinct t.idPuntoDeVenta), t.mes from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto p on p.idProducto = rp.idProducto
	inner join Marca m on m.idMarca = p.idMarca
	inner join #datos d on d.idMarca = m.idMarca
	where isnull(rp.Stock,0) = 1
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = p.IdProducto))
	group by m.idMarca, t.mes

	
	create table #datosFacComp
	(
		idMarca int,
		qty int,
		mes varchar(8)
	)

	insert #datosFacComp (idMarca, qty, mes)
	select d.idMarca, sum(isnull(Cantidad,0))+sum(isnull(cantidad2,0)), t.mes from #tempReporte t
	inner join ReporteProductoCompetencia rp on rp.idReporte = t.idReporte
	inner join ProductoCompetencia pc on pc.idProductoCompetencia = rp.idProducto
	inner join Producto p on p.idProducto = pc.idProducto
	inner join #datos d on d.idMarca = p.IdMarca
	where (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
			and (isnull(@cCompetenciaPrimaria,0) = 0 
					or exists (select 1 from #CompetenciaPrimaria f 
								inner join MarcaCompetencia mct 
									on f.idMarca = mct.idMarca 
								where f.idMarca = p.idMarca 
									and mct.idMarcaCompetencia = (select max(isnull(idmarca,-1))from producto where idProducto = pc.idProductoCompetencia) 
								and isnull(mct.esCompetenciaPrimaria,0) = 1))
	group by d.idMarca, t.mes


	create table #datosFinal
	(
		id int identity (1,1),
		mes varchar(8),
		marca varchar(max),
		q int,
		q2 int,
		q3 decimal(18,2),
		q4 int,
		q5 decimal(18,2),
		q6 int,
		q7 decimal(18,2),
		q8 int,
		q9 int,
		q10 int,
		q11 decimal(18,1)
	)

	insert #datosFinal (mes, marca, q, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11)
	select	right(CONVERT(VARCHAR(11),convert(datetime, d1.mes),6),6),
			ltrim(rtrim(m.Nombre)),
			isnull(d.qty,0),
			count(distinct t.idPuntoDeVenta),
			count(distinct t.idPuntoDeVenta)*100.00/isnull(d.qty,0),
			isnull(d2.qty,0),
			isnull(d2.qty,0)*100.00/count(distinct t.idPuntoDeVenta),
			isnull(d3.qty,0),
			isnull(d3.qty,0)*1.00/isnull(d2.qty,0),
			isnull(d4.qty,0),
			isnull(d5.qty,0),
			isnull(d6.qty,0),
			isnull(d3.qty,0)*100.00/(isnull(d3.qty,0)+isnull(d6.qty,0))
	from #datos d
	left join #datosDist d1 on d.idMarca = d1.idMarca
	left join #datosExh d2 on d.idMarca = d2.idMarca
	left join #datosFac d3 on d.idMarca = d3.idMarca
	left join #datosPOP d4 on d.idMarca = d4.idMarca
	left join #datosQuiebre d5 on d.idMarca = d5.idMarca
	left join #datosFacComp d6 on d.idMarca = d6.idMarca
	inner join Marca m on m.idMarca = d.idMarca
	inner join #tempReporte t on t.mes = d1.mes
	group by d1.mes, m.Nombre, d.qty, d2.qty, d3.qty, d4.qty, d5.qty, d6.qty
		


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
		insert #columnasConfiguracion (name, title, width) values ('mes','Mes',0), ('marca','NombreMarca',50),('q','PDV Activos',30),('q2','Visitados',30),('q3','%',30),('q4','Exhibidos',30),('q5','%',30),('q6','Facing',30),('q7','Facing prom',30),('q8','POP',30),('q9','Faltantes (Q PDV)',30),('q10','Facing Comp',30),('q11','Share',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('mes','Month',0), ('marca','Brand',50),('q','Q PDV',30),('q2','Visited',30),('q3','%',30),('q4','Exhibition',30),('q5','%',30),('q6','Facing',30),('q7','Avg Facing',30),('q8','POP',30),('q9','(Q PDV)',30),('q10','Facing Comp',30),('q11','Share',30)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select mes, marca, q, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11 from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select mes, marca, q, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11 from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select mes, marca, q, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11 from #datosFinal
end

--[Cob_CuadroDeMando_T9] 44