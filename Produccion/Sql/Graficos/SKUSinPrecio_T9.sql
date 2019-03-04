IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SKUSinPrecio_T9'))
   exec('CREATE PROCEDURE [dbo].[SKUSinPrecio_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[SKUSinPrecio_T9] 	
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

	create table #datos
	(
		id int identity(1,1),
		fecha datetime,
		pdv varchar(200),
		direccion varchar(200),
		zona varchar(200),
		usuario varchar(200),
		planograma varchar(200),
		objetivo int,
		cumplimiento int 
	)

	insert #datos (fecha, pdv, direccion, zona, usuario, planograma, objetivo, cumplimiento)
	select	 r.fechacreacion
			,ltrim(rtrim(pdv.nombre))
			,ltrim(rtrim(pdv.direccion))
			,ltrim(rtrim(z.nombre))
			,u.apellido + ', ' + u.nombre collate database_default
			,ltrim(rtrim(m.nombre))
			,count(p.IdProducto) 
			,abs(((sum(rp.stock) * 100.0) / count(p.IdProducto)) - 100)
	from reporte r
	inner join reporteProducto rp on rp.idreporte = r.idreporte
	inner join producto p on p.idproducto = rp.idproducto
	inner join puntodeventa pdv on pdv.idpuntodeventa = r.idpuntodeventa
	inner join cliente c on c.idempresa = r.idempresa
	inner join zona z on z.idzona=pdv.idzona
	inner join usuario u on u.idusuario=r.idusuario
	inner join marca m on m.idmarca=p.idmarca
	where	convert(date,r.fechacreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idcliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
	group by r.fechacreacion
			,ltrim(rtrim(pdv.nombre))
			,ltrim(rtrim(pdv.direccion))
			,ltrim(rtrim(z.nombre))
			,u.apellido + ', ' + u.nombre collate database_default
			,ltrim(rtrim(m.nombre))
	
	
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
		insert #columnasConfiguracion (name, title, width) values ('fecha','Fecha',5),('pdv','Punto de Venta',5),('direccion','Direccion',5),('zona','Zona',5),('usuario','Usuario',5),('planograma','Planograma',5),('objetivo','Objetivo',5),('cumplimiento','Cumplimiento',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('fecha','Date',5),('pdv','Point of Sale',5),('direccion','Address',5),('zona','Zone',5),('usuario','User',5),('planograma','Planogram',5),('objetivo','Objetive',5),('cumplimiento','Fullfilement',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select convert(varchar,fecha,103) as fecha, pdv, isnull(direccion,'') as direccion, zona, usuario, planograma, objetivo,'<p style="color:' + CASE WHEN cumplimiento between 0 and 80 then 'red' else 'green' end + ' ">' + convert(varchar,cumplimiento)+ ' %</p>' as cumplimiento 
		  from #datos where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select convert(varchar,fecha,103) as fecha, pdv, isnull(direccion,'') as direccion, zona, usuario, planograma, objetivo,'<p style="color:' + CASE WHEN cumplimiento between 0 and 80 then 'red' else 'green' end + ' ">' + convert(varchar,cumplimiento)+ ' %</p>' as cumplimiento 
		 from #datos where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select convert(varchar,fecha,103) as fecha, pdv, isnull(direccion,'') as direccion, zona, usuario, planograma, objetivo,'<p style="color:' + CASE WHEN cumplimiento between 0 and 80 then 'red' else 'green' end + ' ">' + convert(varchar,cumplimiento)+ ' %</p>' as cumplimiento 
		 from #datos

end
go


/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20180101,20190106')
--insert into @p2 values(N'fltpuntosdeventa',N'189279')
--insert into @p2 values(N'fltusuarios',N'3976')
--insert into @p2 values(N'fltMarcas',N'2464')
exec SKUSinPrecio_T9 @IdCliente=212,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/
