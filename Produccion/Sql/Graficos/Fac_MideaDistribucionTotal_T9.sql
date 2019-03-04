IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Fac_MideaDistribucionTotal_T9'))
   exec('CREATE PROCEDURE [dbo].[Fac_MideaDistribucionTotal_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Fac_MideaDistribucionTotal_T9]
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

	--if (@cMarcas = 0)
	--BEGIN
	--	insert #marcas(idMarca)
	--	select idMarca from producto where idProducto in (select idProducto from #productos)
	--	set @cMarcas = @@ROWCOUNT
	--END
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

	create table #TempReporte
	(
		idUsuario int,
		idPuntoDeVenta int,
		fechacreacion datetime,
		idReporte int
	)

	
	create table #tempFrentes
		(idReporte int,
		idMarca int,
		cantidad int,
		cantidad2 int)

	create table #datosFinal
	(
		id int identity(1,1),
		fecha varchar(20) collate database_default,
		idReporte int,
		nombrePDV varchar(200) collate database_default,
		NombreUsuario varchar(200) collate database_default,
		Direccion varchar(500) collate database_default,
		Localidad varchar(50) collate database_default,
		Zona varchar(100) collate database_default
	)
	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #Tempreporte (idPuntoDeVenta, idUsuario, fechaCreacion, idReporte)
	select distinct r.idpuntodeventa, r.IdUsuario, 
	r.fechacreacion	, r.idreporte
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
--	group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6)

	insert #tempFrentes(idReporte,idMarca,cantidad,cantidad2)
	select tmp.idReporte,p.idMarca, max(isnull(rp.cantidad,0)),max(isnull(rp.cantidad2,0))
	from #TempReporte tmp
	inner join reporteProducto rp on rp.idReporte = tmp.idReporte
	inner join producto p on p.idProducto = rp.idProducto
	group by tmp.idReporte,p.idMarca

	insert #datosFinal (fecha,idReporte,nombrePDV,NombreUsuario,Direccion,Localidad,Zona)
	select convert(varchar,fechacreacion,103), idReporte, 
	pdv.nombre  collate database_default, u.Apellido+', '+u.Nombre collate database_default,
	pdv.direccion  collate database_default,l.nombre collate database_default,z.nombre collate database_default
	from #tempReporte tmp
	inner join puntodeventa pdv on pdv.idPuntoDeVenta = tmp.idPuntoDeVenta
	inner join usuario u on u.idUsuario = tmp.idUsuario
	inner join localidad l on l.idLocalidad = pdv.idLocalidad 
	inner join zona z on z.idZona = pdv.idzona
	where 1 = 
	(select min(cantidad) from #tempFrentes  where idReporte = tmp.idReporte ) --AGRUPO POR MARCA 
	--	(select max(cantidad) from #tempFrentes where idReporte = tmp.idReporte) 
	--or	  1 = (select max(cantidad2) from #tempFrentes where idReporte = tmp.idReporte) 
	
	
	

	--inner join puntodeventa pdv on pdv.idPuntodeventa = tmp.idPUntodeventa
	--inner join usuario u on u.idUsuario = tmp.idUsuario


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
		insert #columnasConfiguracion (name, title, width) 
		values	('fecha','Fecha',5)
				,('idReporte','Reporte',5)
				,('NombreUsuario','Usuario',5)
				,('nombrePDV','Punto de Venta',5)
				,('Direccion','Direccion',5)
				,('Localidad','Localidad',5)
				,('Zona','Zona',5)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) 
		values	('fecha','Date',5)
				,('idReporte','Report',5)
				,('NombreUsuario','User',5)
				,('nombrePDV','PDV',5)
				,('Direccion','Address',5)
				,('Localidad','State',5)
				,('Zona','Zone',5)


	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select 	fecha,idReporte,NombreUsuario,nombrePDV,Direccion,Localidad,Zona
		from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select 	fecha,idReporte,NombreUsuario,nombrePDV,Direccion,Localidad,Zona
		from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
	
	if(@NumeroDePagina<0)
		select 	fecha,idReporte,NombreUsuario,nombrePDV,Direccion,Localidad,Zona
		from #datosFinal
	
end

/*
[Fac_MideaDistribucionTotal_T9] 30



select p.idMarca,max(isnull(rp.cantidad,0)),max(isnull(rp.cantidad2,0)) from reporteProducto rp  
inner join producto p on p.idProducto = rp.idProducto
where rp.idReporte = 474447
group by p.idmarca
*/


