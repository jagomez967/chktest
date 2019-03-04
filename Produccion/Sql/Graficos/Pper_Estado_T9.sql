IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Pper_Estado_T9'))
   exec('CREATE PROCEDURE [dbo].[Pper_Estado_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Pper_Estado_T9 	
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	
	create table #ultimosReportes
	(
		idpuntodeventa int,
		idreporte int
	)

	insert #ultimosReportes
	select r.idpuntodeventa, max(r.idreporte)
	from reporte r
	inner join puntodeventa pdv on pdv.idpuntodeventa = r.idpuntodeventa
	inner join cliente c on c.idempresa=r.idempresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
		group by r.IdEmpresa, r.IdPuntoDeVenta

	create table #datosPper
	(
		idpuntodeventa int,
		qty int
	)

	insert #datosPper (idpuntodeventa, qty)
	select	r.idpuntodeventa
			,sum(case when isnull(rmi.Valor1,0) > 0 then 3 else 0 end + case when isnull(rmi.Valor2,0) > 0 then 2 else 0 end + case when isnull(rmi.Valor3,0) > 0 then 1 else 0 end)
	from MD_ReporteModuloItem rmi
	inner join reporte r on r.idreporte=rmi.idreporte
	inner join #ultimosReportes tmp on tmp.idreporte=r.idreporte
	inner join puntodeventa pdv on pdv.idpuntodeventa=r.idpuntodeventa
	inner join MD_item i on i.iditem = rmi.iditem
	inner join MD_modulo m on m.idmodulo = i.idmodulo
	where m.activo=1 and i.activo=1
	and (isnull(rmi.Valor1,0)<>0 or isnull(rmi.Valor2,0)<>0 or isnull(rmi.Valor3,0)<>0)
	group by r.idpuntodeventa

	create table #datos
	(
		id int identity(1,1),
		pdv varchar(200),
		localidad varchar(200),
		direccion varchar(200),
		estado varchar(100)
	)

	declare @minRojo int=1, @maxRojo int=13
	declare @minAmarillo int=14, @maxAmarillo int=21
	declare @minVerde int=22, @maxVerde int=30

	if @idcliente=6
	begin
		set @minRojo=1
		set @maxRojo=5
		set @minAmarillo=6
		set @maxAmarillo=9
		set @minVerde=10
		set @maxVerde=15
	end
	
	if @idcliente=7
	begin
		set @minRojo=1
		set @maxRojo=6
		set @minAmarillo=7
		set @maxAmarillo=14
		set @minVerde=15
		set @maxVerde=18
	end

	insert #datos (pdv, localidad, direccion, estado)
	select ltrim(rtrim(pdv.nombre))
	,ltrim(rtrim(l.nombre))
	,ltrim(rtrim(pdv.direccion))
	,case when qty between @minRojo and @maxRojo then '<img src="images/circuloRojo.png" width="16" height="16" class="circuloRojoAmarilloVerde"/>'
	when qty between @minAmarillo and @maxAmarillo then '<img src="images/circuloAmarillo.jpg" width="16" height="16" class="circuloRojoAmarilloVerde"/>'
	when qty between @minVerde and @maxVerde then '<img src="images/circuloVerde.png" width="16" height="16" class="circuloRojoAmarilloVerde"/>'
	--else 'nul' + cast(isnull(qty,-1) as varchar)
	 end
	from #datosPper p
	inner join puntodeventa pdv on pdv.idpuntodeventa = p.idpuntodeventa
	inner join localidad l on l.idlocalidad=pdv.idlocalidad
	order by ltrim(rtrim(pdv.nombre))


	--Cantidad de páginas
	declare @maxpag int
	
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag = ceiling(count(*)*1.0/@TamañoPagina) from #datos

	select @maxpag


	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('estado','Estado',1),('pdv','Punto de venta',1),('direccion','Direccion',1),('localidad','Localidad',120)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('estado','Status',5),('pdv','Point of Sale',1),('direccion','Address',1),('localidad','City',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select estado, pdv, direccion, localidad from #datos where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select estado, pdv, direccion, localidad from #datos where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select estado, pdv, direccion, localidad from #datos
end