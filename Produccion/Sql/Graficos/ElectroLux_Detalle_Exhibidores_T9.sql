IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ElectroLux_Detalle_Exhibidores_T9'))
   exec('CREATE PROCEDURE [dbo].[ElectroLux_Detalle_Exhibidores_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[ElectroLux_Detalle_Exhibidores_T9]
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
	declare @idCadena int = 0
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
	
	insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
	set @cSubCategoria = @@ROWCOUNT

	select @idCadena = cast(Valores as int) from @Filtros where IdFiltro = 'IdCadena'

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
	
	create table #tempReporte
	(
		
		Idpdv int,
		IdReporte int,
		fecha varchar(8),
		id_usuario int,
		usuario varchar(200)
	)

	
	create table #datos_resueltos
	(
		pdv int,
		idProducto int,
		Producto varchar(200),
		id_usuario int,
		nombre varchar(200),
		id_producto int
	)


	-------------------------------------------------------------------- TEMPS (Filtros)

	
	insert #tempReporte ( Idpdv, IdReporte,fecha, id_usuario,usuario)
	select distinct  p.IdPuntoDeVenta, r.idreporte,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112), u.idusuario,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Usuario
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join usuario u on u.idUsuario = r.IdUsuario
	where	c.IdCliente=@IdCliente
		and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))			
	group by p.IdPuntoDeVenta,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),u.idusuario,
	U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT,r.idreporte,p.nombre
	
	
	
		create table #datos_pedido
	(
		id int identity(1,1),
		Fecha_Reporte varchar(30),
		Usuario varchar(200),		
		PuntoDeVenta varchar(300),	
		Direccion varchar(300),
		Zona varchar (300),
		Localidad varchar(300),
		Producto varchar(200), 		
		nombre_familia varchar(200),
		Marca varchar(200),
		exhibidor varchar(200)
		
	)
	
	
	insert #datos_pedido (Fecha_Reporte,PuntoDeVenta,Direccion,Zona, Localidad,Usuario,Producto,Marca,nombre_familia,Exhibidor) 
	select convert(varchar(10),CONVERT(date,t.FechaCreacion,106),103),pdv.nombre,pdv.direccion,z.nombre,l.nombre,r.usuario,p.nombre,m.nombre,isnull(f.nombre,''),e.nombre
	from #tempReporte r
	inner join reporte t on r.idReporte = t.idReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.Idpdv
	inner join localidad l on l.idLocalidad = pdv.idLocalidad
	inner join zona z on pdv.idZona =z.idzona
	inner join ReporteProducto rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join marca m on m.idMarca = p.IdMarca
	left join familia f on f.IdFamilia = p.IdFamilia
	inner join exhibidor e on e.idexhibidor = rp.IdExhibidor
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
			and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
														  inner join subCategoriaProducto scp 
																on sc.idSubCategoria = scp.idSubCategoria
														 where scp.idProducto = rp.IdProducto))
	


	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datos_pedido
    
	select @maxpag
    
	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		esclave bit,
		mostrar bit,
		name varchar(50),
		title varchar(50),
		width int
	)
    
	if(@lenguaje = 'es')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (1,0,'Fecha_Reporte','Fecha_Reporte',0), (0,1,'PuntoDeVenta','PuntoDeVenta',5),(0,1,'Usuario','Usuario',5),(0,1,'Direccion','Direccion',5),(0,1,'Zona','Zona',5),(0,1,'Localidad','Localidad',5),(0,1,'Producto','Producto',5),(0,1,'Marca','Marca',5),(0,1,'nombre_familia','nombre_familia',5),(0,1,'Exhibidor','Exhibidor',5)
    
	if(@lenguaje = 'en')
		insert #columnasConfiguracion (esclave, mostrar, name, title, width) values (1,0,'Fecha_Reporte','Fecha_Reporte',0), (0,1,'PuntoDeVenta','PuntoDeVenta',5),(0,1,'Usuario','Usuario',5),(0,1,'Direccion','Direccion',5),(0,1,'Zona','Zona',5),(0,1,'Localidad','Localidad',5),(0,1,'Producto','Producto',5),(0,1,'Marca','Marca',5),(0,1,'nombre_familia','Nombre familia',5),(0,1,'Exhibidor','Exhibidor',5)
	select esclave, mostrar, name, title, width from #columnasConfiguracion
    
	--Datos
	if(@NumeroDePagina>0)
		select Fecha_Reporte,PuntoDeVenta,Usuario,Direccion,Zona, Localidad,Producto,Marca,nombre_familia,Exhibidor 
		from #datos_pedido where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina) order by id
	
	if(@NumeroDePagina=0)
		select Fecha_Reporte,PuntoDeVenta,Usuario,Direccion,Zona, Localidad,Producto,Marca,nombre_familia,Exhibidor 
		from #datos_pedido where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina) order by id
		
	if(@NumeroDePagina<0)
		select Fecha_Reporte,PuntoDeVenta,Usuario,Direccion,Zona, Localidad,Producto,Marca,nombre_familia,Exhibidor 
		from #datos_pedido order by id
end
go


/*
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p2 values(N'fltSubCategoria',N'1000')
exec ElectroLux_Detalle_Exhibidores_T9 @IdCliente=235,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

declare @p3 dbo.FiltrosReporting
insert into @p3 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p3 values(N'fltSubCategoria',N'1001')
exec ElectroLux_Detalle_Exhibidores_T9 @IdCliente=235,@Filtros=@p3,@NumeroDePagina=-1,@Lenguaje='es'
*/