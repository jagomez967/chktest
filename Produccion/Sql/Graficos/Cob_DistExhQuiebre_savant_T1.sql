IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_DistExhQuiebre_savant_T1'))
   exec('CREATE PROCEDURE [dbo].[Cob_DistExhQuiebre_savant_T1] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Cob_DistExhQuiebre_savant_T1]
---create procedure [dbo].[Cob_DistExhQuiebre_savant_T1] 	
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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #Asignados
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	create table #Relevados
	(
		mes varchar(8)
		,qty int
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

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and r.idusuario=cu.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #Relevados (mes, qty)
	select mes, count(distinct IdPuntoDeVenta)
	from #tempReporte
	group by mes

	create table #NOAuditados
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	insert #NOAuditados (mes, qty)
	select mes, isnull(count(distinct r.idPuntoDeventa),0) 
	from #tempReporte t
	inner join Reporte r on r.idReporte = t.idReporte
	where r.AuditoriaNoAutorizada = 1
	group by mes

	create table #aud
	(
		id int identity(1,1),
		mes varchar(8),
		qty int
	)
	
	insert #aud (mes, qty)
	select r.mes, isnull(r.qty,0)-isnull(n.qty,0) 
	from #Relevados r
	left join #NOAuditados n on n.mes = r.mes

	---Distribucion sin Exhibicion
	
	create table #dist
	(
		id int identity(1,1),
		mes varchar(8),
		qty int
	)

	insert #dist (mes, qty)
	select mes, count(distinct t.idpuntodeventa)
	from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto prod on prod.idproducto = rp.idproducto
	inner join reporte r on r.idreporte=t.idreporte
	inner join marca m on m.idMarca = prod.idMarca 
	where  	not exists(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 
				and (isnull(ReporteProducto.notrabaja,0)>0
				or isnull(ReporteProducto.cantidad,0) > 0
				or isnull(ReporteProducto.cantidad2,0)> 0				
				or isnull(ReporteProducto.Stock,0) > 0)
	)
	and r.AuditoriaNoAutorizada = 0	
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by t.mes
	
	
	--exhibicion
	create table #exh
	(
		id int identity(1,1),
		mes varchar(8),
		qty int
	)

	insert #exh (mes,qty)
	select mes, count(distinct t.idpuntodeventa)
	from #tempReporte t
	inner join ReporteProducto rp on rp.idReporte = t.idReporte
	inner join Producto prod on prod.idproducto = rp.idproducto
	inner join Reporte r on r.idreporte=t.idreporte
	where ((isnull(rp.Cantidad,0) > 0 or isnull(rp.Cantidad2,0) > 0))
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	and r.AuditoriaNoAutorizada = 0
	and not exists (select 1 from reporteProducto rp2
					inner join producto p2 on p2.idProducto =rp2.idProducto
					where rp2.idReporte = rp.idReporte
					and isnull(rp.Cantidad,0) + isnull(rp.Cantidad2,0) = 0 
						and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p2.idMarca))
						and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p2.idProducto))
				  )
	group by mes

	----Quiebre
	
	create table #quiebre
	(
		id int identity(1,1),
		mes varchar(8),
		qty int
	)

	insert #quiebre (mes, qty)
	select t.mes, count(distinct t.idpuntodeventa)
	---select distinct t.idpuntodeventa, t.idReporte
	from #tempreporte t
	inner join reporte r on r.idreporte=t.idreporte
	inner join reporteProducto rp on rp.idreporte=r.idreporte
	inner join producto prod on prod.idproducto = rp.idproducto
	where r.auditorianoautorizada=0
	and not exists
	(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 			
				and ReporteProducto.stock=0
	)
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by mes

	---No trabaja
	
	create table #notrabaja
	(
		id int identity(1,1),
		mes varchar(8),
		qty int
	)

	insert #notrabaja (mes,qty)
	select t.mes, count(distinct t.idpuntodeventa)
	from #tempreporte t
	inner join reporte r on r.idreporte=t.idreporte
	inner join reporteProducto rp on rp.idreporte=r.idreporte
	inner join producto prod on prod.idproducto = rp.idproducto
	where r.auditorianoautorizada=0
	and not exists
	(
		select 1 from reporteproducto
		inner join producto on producto.idproducto = reporteproducto.idproducto
		where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where #marcas.idMarca = producto.idMarca))
				and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where #productos.idProducto = producto.idProducto))
				and reporteproducto.idreporte=r.idreporte 
				and ReporteProducto.notrabaja=0
	)
	and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = prod.idMarca))
	and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = prod.idProducto))
	group by mes

	---Quiebre Parcial
	
	create table #quiebreparcial
	(
		id int identity(1,1),
		qty int
	)
	
	
	
	declare @sumTotal numeric(18,5)
	select @sumTotal=SUM(qty) 
	from #Asignados
	if(@sumTotal=0)
	begin
		delete from #dist
		delete from #exh
		delete from #quiebre
		delete from #PdvsNoTrabajanNada
	end
	

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50)
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title) values ('mes','mes'),('cobertura','Cobertura'),('Auditoria No autorizada','Auditoria No autorizada'),('distribucion','Distribucion sin exhibicion'),('exhibicion','Exhibicion'),('quiebre','Quiebre'),('notrabaja','No Trabajan')
		,('quiebreparcial','Quiebreparcial')
	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title) values ('mes','month'),('cobertura','Cobertura'),('auditados','Audited'),('distribucion','Distribucion sin exhibicion'),('exhibicion','Exhibition'),('quiebre','Quiebre'),('notrabaja','No Trabajan')
		,('quiebreparcial','Quiebreparcial')
	select name, title from #columnasConfiguracion

	select	right(CONVERT(VARCHAR(11),convert(datetime, A.mes),6),6) as mes,
			isnull(tc.qty,0) as cobertura,
			--isnull(A.qty,0) as auditados,
			isnull(tc.qty,0) - isnull(a.qty,0) as 'Auditoria No autorizada',
			isnull(d.qty,0) as distribucion,
			isnull(e.qty,0) as exhibicion,
			isnull(q.qty,0) as quiebre,
			isnull(n.qty,0) as notrabaja,
			--isnull(p.qty,0) as quiebreparcial
			isnull(A.qty,0) - (isnull(d.qty,0)+ isnull(e.qty,0) + isnull(q.qty,0) +isnull(n.qty,0) ) as quiebreparcial
			from #aud A
			left join #dist d on d.mes=A.mes
			left join #exh e on e.mes=A.mes
			left join #quiebre q on q.mes=A.mes
			left join #notrabaja n on n.mes=A.mes
			left join #Relevados tc on tc.mes=A.mes
			left join #quiebreparcial p on tc.mes=A.mes
end
go