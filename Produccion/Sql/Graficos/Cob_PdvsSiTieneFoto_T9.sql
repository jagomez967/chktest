IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_PdvsSiTieneFoto_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_PdvsSiTieneFoto_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Cob_PdvsSiTieneFoto_T9] 	
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
		ID int identity(1,1)
		,Fecha	varchar(10)
	)

	create table #zonas
	(
		IDZona int
	)

	create table #cadenas
	(
		IDCadena int
	)

	create table #localidades
	(
		IDLocalidad int
	)

	create table #puntosdeventa
	(
		IDPuntoDeVenta int
	)

	create table #usuarios
	(
		IDUsuario int
	)

	create table #marcas
	(
		IDMarca int
	)

	create table #productos
	(
		IDProducto int
	)

	create table #competenciaPrimaria
	(
		IDMarca int
	)

	create table #vendedores
	(
		IDVendedor int
	)

	create table #tipoRtm
	(
		IDTipoRtm int
	)

	create table #Provincias
	(
		IDProvincia int
	)

	create table #Tags
	(
		IDTag int
	)
	create table #Familia
	(
		IDFamilia int
	)
	create table #TipoPDV
	(
		IDTipo int
	)
	create table #Categoria
	(
		IDCategoria int
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
		IDCliente int,
		IDUsuario int,
		IDPuntoDeVenta int,
		PDV varchar(max),
		Fecha datetime,
		IDReporte int,
		Direccion varchar(max),
		Localidad varchar(max),
		Zona varchar(max),
		RTM varchar(max),
		ConFoto int
		
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (IDCliente,IDUsuario,IDPuntoDeVenta,Fecha,IDReporte,PDV,Direccion,Localidad,Zona,RTM)

	select	
	         c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,r.FechaCreacion
			,r.idReporte
			,p.Nombre
			,p.Direccion
			,l.Nombre
			,z.Nombre
			,u.Apellido + ', ' + u.Nombre COLLATE DATABASE_DEFAULT as RTM
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = p.idLocalidad
	inner join Zona z on z.idZona = p.idZona
	inner join Usuario u on u.idUsuario = r.idUsuario
	where	
			convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))

	create table #datosFinal
	(
		ID int identity(1,1),
		IDCliente int,
		IDUsuario int,
		IDPuntoDeVenta int,
		PDV varchar(max),
		Direccion varchar(max),
		Localidad varchar(max),
		Zona varchar(max),
		RTM varchar(max),
		Fecha datetime,
		IDReporte int,
		ConFoto int
		
	)

	insert #datosfinal (IDCliente,IDUsuario,IDPuntoDeVenta,Fecha,IDReporte,PDV,Direccion,Localidad,Zona,RTM,ConFoto)
	select  distinct
			 t.IdCliente
			,t.IdUsuario
			,t.IdPuntoDeVenta
			,t.Fecha
			,t.idReporte
			,t.pdv
			,t.Direccion
			,t.localidad
			,t.zona
			,t.Rtm
			,case when exists (select 1 from PuntoDeVentaFoto pdvf where pdvf.idReporte = t.idReporte) then  1
			else 0 end 
	from #tempReporte t
	left join PuntoDeVentaFoto pdvf on pdvf.idReporte = t.idReporte

	
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

	if(@lenguaje='es')	
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Fecha',5),('IDPuntoDeVenta','IDPuntoDeVenta',5),('PDV','PDV',5),('Direccion','Dirección',5),('Localidad','Localidad',5),('Zona','Zona',5),('RTM','RTM',5),('IDReporte','IDReporte',5),('ConFoto','Con Foto',5)

	if(@lenguaje='en')	
		insert #columnasConfiguracion (name, title, width) values ('Fecha','Date',5),('IDPuntoDeVenta','IDPuntoDeVenta',5),('PDV','POS',5),('Direccion','Address',5),('Localidad','Location',5),('Zona','Zone',5),('RTM','RTM',5),('IDReporte','IDReport',5),('ConFoto','With Picture',5)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select  Fecha,IDPuntoDeVenta,PDV,Direccion,Localidad,Zona,RTM,IDReporte,ConFoto from #datosFinal where ID between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select  Fecha,IDPuntoDeVenta,PDV,Direccion,Localidad,Zona,RTM,IDReporte,ConFoto from #datosFinal where ID between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select  Fecha,IDPuntoDeVenta,PDV,Direccion,Localidad,Zona,RTM,IDReporte,ConFoto from #datosFinal
end
go

 
/*
declare @p3 dbo.FiltrosReporting
insert into @p3 values(N'fltFechaReporte',N'D,20180501,20181130')
exec [Cob_PdvsTieneFoto_T9] @IdCliente=190,@Filtros=@p3,@NumeroDePagina=-1,@Lenguaje='es',@IdUsuarioConsulta=19,@TamañoPagina=8
*/




