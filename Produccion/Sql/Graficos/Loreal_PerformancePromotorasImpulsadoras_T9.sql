IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Loreal_PerformancePromotorasImpulsadoras_T9'))
   exec('CREATE PROCEDURE [dbo].[Loreal_PerformancePromotorasImpulsadoras_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Loreal_PerformancePromotorasImpulsadoras_T9]
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

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(10),
		idReporte int
	)

	create table #datos
	(
		fecha varchar(10),
		idPuntoDeVenta int,
		idUsuario int,
		MarcaPropiedad int,
		valor decimal(18,2)
	)

	create table #datosFinal
	(
		id int identity(1,1),
		fecha varchar(10),
		pdv varchar(500),
		direccion varchar(500),
		usuario varchar(500),
		pais varchar(500),
		porcentaje decimal(18,2)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(date, r.FechaCreacion)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias where idProvincia = l.idProvincia))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by c.IdCliente, r.IdUsuario, r.IdPuntoDeVenta, convert(date, r.FechaCreacion)
	

	insert #datos (fecha, idPuntoDeVenta, idUsuario, MarcaPropiedad, valor)
	select t.mes, t.idPuntoDeVenta, t.idUsuario, rmi.idItem, (sum(mmi.Ponderacion)*mm.Ponderacion)/100.0 from #tempReporte t
	inner join MD_ReporteModuloItem rmi on rmi.idReporte = t.idReporte
	inner join MD_ModuloMarcaItem mmi on mmi.idItem = rmi.idItem
	inner join MD_Item mi on mi.idItem = rmi.idItem
	inner join MD_Modulo m on m.idModulo = mi.idModulo
	inner join MD_ModuloMarca mm on mm.idModulo = m.idModulo
	where isnull(rmi.Valor1,0) = 1
	group by t.mes, t.idPuntoDeVenta, t.idUsuario, rmi.idItem, mm.Ponderacion
	order by t.idPuntoDeVenta, rmi.idItem


	
	insert #datosFinal (fecha, pdv, direccion, usuario, pais, porcentaje)
	select	d.fecha,
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(pdv.Direccion)),
			u.Apellido+', '+u.Nombre collate database_default,
			ltrim(rtrim(p.Nombre)),
			sum(isnull(d.valor,0))
	from #datos d
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = d.idPuntoDeVenta
	inner join Usuario u on u.idUsuario = d.idUsuario
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	inner join Provincia p on p.idProvincia = l.idProvincia
	group by d.fecha, pdv.Nombre, pdv.Direccion, u.Apellido, u.Nombre, p.Nombre



	declare @maxpag int
	
	if(@TamaņoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamaņoPagina) from #datosFinal

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('fecha','Fecha',0), ('pdv','Nombre Pdv',5),('direccion','Direccion',5),('usuario','Usuario',10),('pais','Pais',10),('porcentaje','% Cumplimiento',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('fecha','Date',0), ('pdv','POS Name',5),('direccion','Address',5),('usuario','User',10),('pais','Country',10),('porcentaje','%',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select fecha, pdv, direccion, usuario, pais, porcentaje from #datosFinal where id between ((@NumeroDePagina - 1) * @TamaņoPagina + 1) and (@NumeroDePagina * @TamaņoPagina) order by id
	
	if(@NumeroDePagina=0)
		select fecha, pdv, direccion, usuario, pais, porcentaje from #datosFinal where id between ((@maxpag - 1) * @TamaņoPagina + 1) and (@maxpag * @TamaņoPagina) order by id
		
	if(@NumeroDePagina<0)
		select fecha, pdv, direccion, usuario, pais, porcentaje from #datosFinal order by id
end
go