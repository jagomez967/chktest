IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_FacingMarcaPropia_T7'))
   exec('CREATE PROCEDURE [dbo].[Savant_FacingMarcaPropia_T7] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Savant_FacingMarcaPropia_T7] 	
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

	declare @asignadoTexto varchar(20)
	declare @relevadoTexto varchar(20)

	if @lenguaje = 'es'
	begin
		set language spanish
		set @asignadoTexto = 'Asignado'
		set @relevadoTexto = 'Relevado'
	end

	if @lenguaje = 'en'
	begin
		set language english
		set @asignadoTexto = 'Assigned'
		set @relevadoTexto = 'Visited'
	end

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

	create table #Clientes
	(
		idCliente int
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
	declare @cClientes varchar(max)
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
	
	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end
		
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
		id int identity(1,1),
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)

	create table #asignados
	(
		idUsuario int
		,mes varchar(6)
		,idPuntoDeVenta int
	)

	create table #Relevados
	(
		idUsuario int
		,mes varchar(6)
		,qty int
	)
	
	create table #reporte
	(
		idReporte int,
		IdPuntoDeVenta int,
		idEmpresa int,
		mes varchar(8),
		mesD char(8)
	)
	
	-------------------------------------------------------------------- TEMPS (Filtros)

	declare @i int = 1
	declare @max int
	declare @currentFecha datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU
		
		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #meses where id=@i

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, mes, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,left(@currentFecha,6)
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where	convert(date,Fecha)<=convert(date,@currentFecha)
				and exists(select 1 from #clientes where idCliente = pcu.idCliente)
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
				and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
				and	(isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in (select idProvincia from Localidad where idLocalidad = p.idLocalidad)))
				and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
				in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))		
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (idUsuario, mes, idPuntoDeVenta)
		select idUsuario, left(convert(varchar,@currentFecha,112),6),  IdPuntoDeVenta
		from #tempPCU

		set @i=@i+1
	end
	----------------------------------REPORTE
	insert #reporte (idReporte, IdPuntoDeVenta,idEmpresa,mes,mesd)
	SELECT DISTINCT
		MAX(R.idReporte),
		R.idPuntoDeVenta,
		R.idEmpresa,
		--convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), r.FechaCreacion),112) as mes
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		CONVERT(VARCHAR(10), DATEADD(month, DATEDIFF(month, 0, R.FechaCreacion), 0), 112)

	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		INNER JOIN Usuario_Cliente CU on CU.idCliente = C.idCliente and CU.idUsuario = r.idUsuario

	WHERE 
		CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND C.idCliente = @idCliente
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cVendedores,0) = 0 OR EXISTS (SELECT 1 FROM PuntoDeVenta_Vendedor PVE WHERE PVE.IdPuntoDeVenta = R.IdPuntoDeVenta AND PVE.IdVendedor IN (SELECT idVendedor FROM #vendedores)))
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
			
		
	GROUP BY
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		--convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),
		R.idPuntoDeVenta,
		R.idEmpresa,
		CONVERT(VARCHAR(10), DATEADD(month, DATEDIFF(month, 0, R.FechaCreacion), 0), 112)
	---------------------------------- RELEVADOS
	
	insert #relevados (mes, qty)
	select mes, count(distinct idpuntodeventa) 
	from #reporte
	group by mes
	
	-----------------------------------PRODUCTOS, MARCAS -------------------------------------------
	create table #datos
	(
	
		mes varchar(8),
		descr varchar(8),
		idEmpresa int,
		idProducto int,
		nombre_prod varchar(80),
		idMarca int,
		nombre_marca varchar(80),
		qty int
		
	)
	
	insert #datos (mes,descr,idEmpresa, idProducto, nombre_prod, idMarca,nombre_marca,qty)
	select  r.mesD,r.mes, r.idEmpresa, rp.IdProducto,p.nombre, m.idMarca, m.nombre,SUM(isnull(rp.Cantidad,0)+isnull(rp.Cantidad2,0))
	from #reporte r
	inner join ReporteProducto rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	where (ISNULL(rp.Cantidad,0) + ISNULL(rp.Cantidad2,0) != 0)
		and (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		and  (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #productos WHERE idProducto = p.IdProducto))		
	group by r.idEmpresa, m.idMarca, rp.IdProducto, p.nombre,m.nombre,r.mes,r.mesD
         
		
	select mes,descr,nombre_marca, sum(qty) as qty
	from #datos
	group by mes,descr,nombre_marca
	order by mes desc
	
	create table #resultados 
	(
	 mes varchar (8),
	 Descr VARCHAR (20),
	 id_producto int,
	 producto varchar(80),
	 cantidad int,
	 id_marca int, 
	 nombre_marca varchar(80),
	 cant_marca int
	 )
	 
	 insert #resultados (mes,Descr, id_producto,producto,cantidad,id_marca, nombre_marca)
	 select mes,mes,idProducto, nombre_prod, isnull(sum(qty),0), idMarca, nombre_marca
	 from #datos
	 group by mes, idproducto, nombre_prod,qty, idMarca, nombre_marca,descr


	select mes, descr, id_producto, producto,nombre_marca,cantidad,1 Visiblelabel from #resultados order by mes desc	
end
go


[Savant_FacingMarcaPropia_T7] 49 