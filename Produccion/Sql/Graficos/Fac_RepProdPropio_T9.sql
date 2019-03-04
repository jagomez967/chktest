IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_RepProdPropio_T9'))
   exec('CREATE PROCEDURE [dbo].[Fac_RepProdPropio_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_RepProdPropio_T9]
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
	
	create table #SubCategoria
	(
		idSubCategoria int
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
	declare @cCategoria int = 0
	declare @cSubCategoria int = 0

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
	
	insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
	set @cSubCategoria = @@ROWCOUNT

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


	---NUEVO: Unificacion de filtros (Productos)
	
	declare @idEmpresa int 
	select @idEmpresa = idEmpresa from cliente where idCliente = @idCliente

	if(@cProductos + @cMarcas + @cFamilia + @cSubCategoria + @cCompetenciaPrimaria > 0)
	BEGIN
		insert #productos(idProducto)
		select distinct p.idProducto 
		from producto p 
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
		and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
													inner join subCategoriaProducto scp 
														on sc.idSubCategoria = scp.idSubCategoria
													where scp.idProducto = p.IdProducto))
		and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = m.idMarca)) 
		set @cProductos = @cProductos + @cMarcas + @cFamilia + @cSubCategoria + @cCompetenciaPrimaria
	END
	--Unificacion de filtros (Puntos de venta)
	
	if(@cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores + @cCategoria > 0)
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
		and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))
		select @cPuntosDeVenta = @cPuntosDeVenta + @cCadenas + @cZonas + @cLocalidades + @cTipoPDV + @cProvincias + @cEquipo + @cVendedores + @cCategoria
	END
	--Fin Unificacion Filtros
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

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		idReporte int,
		fechaCreacion datetime,
		idPuntoDeVenta int,
		PuntoDeVenta varchar(100),
		TipoPDV varchar(100),
		Direccion varchar(300),
		Usuario varchar(100),
		FechaReporte varchar(10),
		Zona varchar(100),
		Provincia varchar(100),
		Cadena varchar(100),
		idMarca int,
		Marca varchar(100),
		idProducto int,
		Producto varchar(100),
		Familia varchar(100),
		Empresa varchar(100),
		Precio numeric(18,2),
		Frentes1 int,
		Exhibidor1 varchar(50),
		Frentes2 int,
		Exhibidor2 varchar(50)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte)
	select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte)
	from Reporte r
	where	r.idEmpresa = @idEmpresa
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = r.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6)


	insert #datosFinal (idReporte,idPuntoDeVenta,fechaCreacion, PuntoDeVenta,TipoPDV, Direccion, Usuario, FechaReporte, Zona, Provincia, Cadena, idMarca, Marca, idProducto, Producto, Familia, Empresa, Precio, Frentes1, Exhibidor1, Frentes2, Exhibidor2)
	select	r.idReporte,
			pdv.IdPuntoDeVenta,
			rep.FechaCreacion,
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(tp.Nombre)),
			ltrim(rtrim(pdv.Direccion)),			
			ltrim(rtrim(u.Nombre))+', '+ltrim(rtrim(u.Apellido)) collate database_default,
			CONVERT(VARCHAR(10),rep.FechaCreacion,103),
			ltrim(rtrim(z.Nombre)),
			ltrim(rtrim(pr.Nombre)),
			ltrim(rtrim(ca.Nombre)),
			m.IdMarca,
			ltrim(rtrim(m.Nombre)),
			p.IdProducto,
			ltrim(rtrim(p.Nombre)),
			ltrim(rtrim(f.Nombre)),
			ltrim(rtrim(emp.Nombre)),
			isnull(rp.Precio,0),
			isnull(rp.Cantidad,0),
			ltrim(rtrim(e.Nombre)),
			isnull(rp.Cantidad2,0),
			ltrim(rtrim(e2.Nombre))
	from #reportesMesPdv r 
		inner join ReporteProducto rp on rp.idReporte = r.idReporte
		inner join reporte rep on rep.IdReporte=r.idReporte
		inner join Producto p on p.IdProducto = rp.IdProducto
		inner join Marca m on m.IdMarca = p.IdMarca
		inner join Empresa emp on emp.idEmpresa = m.idEmpresa		
		inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = r.IdPuntoDeVenta
		inner join Usuario u on u.IdUsuario = rep.idUsuario
		inner join Zona z on z.IdZona = pdv.IdZona
		inner join Localidad l on l.IdLocalidad = pdv.IdLocalidad
		inner join Provincia pr on pr.IdProvincia = l.IdProvincia
		left join Familia f on f.idFamilia = p.idFamilia
		left join Exhibidor e on e.IdExhibidor = rp.IdExhibidor
		left join Exhibidor e2 on e2.IdExhibidor = rp.IdExhibidor2
		left join tipo tp on tp.idTipo = pdv.idtipo
		left join Cadena ca on ca.idCadena = pdv.idCadena
	where (isnull(rp.Cantidad,0)>0 or isnull(rp.Cantidad2,0)>0 or isnull(Precio,0)>0)
		and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))

	order by pdv.Nombre

	
	--Cantidad de páginas
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
		insert #columnasConfiguracion (name, title, width) values ('idReporte','idReporte',5),('idPuntoDeVenta','idPuntoDeVenta',5),('FechaReporte','Fecha Reporte',5),('PuntoDeVenta','PuntoDeVenta',5),('TipoPDV','TipoPDV',5),('Direccion','Direccion',5),('Usuario','RTM',5),('FechaReporte','FechaReporte',5),('Zona','Zona',5),('Provincia','Provincia',5),('Cadena','Cadena',5),('Marca','Categoria',5),('Producto','Producto',5),('Familia','Familia',5),('Empresa','Empresa',5),('Precio','Precio',5),('Frentes1','Frentes 1',5),('Exhibidor1','Exhibidor 1',5),('Frentes2','Frentes 2',5),('Exhibidor2','Exhibidor 2',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('idReporte','idReporte',5),('idPuntoDeVenta','idPdv',5),('FechaReporte','Fecha Reporte',5),('PuntoDeVenta','PDV',5),('TipoPDV','TipoPDV',5),('Direccion','Address',5),('Usuario','RTM',5),('FechaReporte','ReportDate',5),('Zona','Zone',5),('Provincia','Province',5),('Cadena','Retail',5),('Marca','Category',5),('Producto','Product',5),('Familia','Family',5),('Empresa','Company',5),('Precio','Price',5),('Frentes1','Qty 1',5),('Exhibidor1','Exhibition 1',5),('Frentes2','Qty 2',5),('Exhibidor2','Exhibition 2',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select idReporte,idPuntoDeVenta,fechaCreacion, PuntoDeVenta,TipoPDV, Direccion, Usuario, FechaReporte, Zona, Provincia, Cadena, Marca, Producto, Familia, Empresa, Precio, Frentes1, Exhibidor1, Frentes2, Exhibidor2 from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select idReporte,idPuntoDeVenta,fechaCreacion, PuntoDeVenta,TipoPDV, Direccion, Usuario, FechaReporte, Zona, Provincia, Cadena, Marca, Producto, Familia, Empresa, Precio, Frentes1, Exhibidor1, Frentes2, Exhibidor2 from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select idReporte,idPuntoDeVenta,fechaCreacion, PuntoDeVenta,TipoPDV, Direccion, Usuario, FechaReporte, Zona, Provincia, Cadena, Marca, Producto, Familia, Empresa, Precio, Frentes1, Exhibidor1, Frentes2, Exhibidor2 from #datosFinal
	
	end
GO
