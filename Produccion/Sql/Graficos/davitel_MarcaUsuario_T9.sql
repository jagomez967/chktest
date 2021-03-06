IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.davitel_MarcaUsuario_T9'))
   exec('CREATE PROCEDURE [dbo].[davitel_MarcaUsuario_T9] AS BEGIN SET NOCOUNT ON; END')
GO --[davitel_MarcaUsuario_T9] 84
alter procedure [dbo].[davitel_MarcaUsuario_T9]
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

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #Meses
	(
		mes varchar(8)
	)

	create table #TempReporte
	(
		idReporte int,
		idUsuario int
	)

	create table #datos
	(
		id int identity,
		idUsuario int,
		idMarca int,
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps)

	insert #tempReporte (idReporte,idUsuario)
	select r.idReporte,r.idUsuario
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			

	insert #datos (idUsuario, idMarca, idReporte)
	select r.idUsuario,m.idMarca,r.idReporte
	from #TempReporte r
	inner join md_reporteModuloItem rmi
		on rmi.idReporte = r.idReporte
	inner join marca m on m.idMarca = rmi.idMarca
	--left join familia f on f.idMarca = m.idMarca
	where	(isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = m.IdMarca))
			--and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))
			--and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = f.IdFamilia))
			--and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = m.idMarca)) 
		order by r.idUsuario,r.idReporte

	
	declare @maxpag int
	
	set @TamaņoPagina = @TamaņoPagina - 1

	if(@TamaņoPagina=-1)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamaņoPagina) from #datos

	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
	begin
		insert #columnasConfiguracion (name, title, width) values ('fecha','Fecha', 5)
		insert #columnasConfiguracion (name, title, width) values ('usuario','Instalador', 10)
		insert #columnasConfiguracion (name, title, width) values ('nombrePdv','Cliente', 10)
		insert #columnasConfiguracion (name, title, width) values ('direccion','Direccion', 10)
		insert #columnasConfiguracion (name, title, width) values ('tarea','Tarea Realizada', 10)
	end
	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width) values ('fecha','Fecha', 5)
		insert #columnasConfiguracion (name, title, width) values ('usuario','Instalador', 10)
		insert #columnasConfiguracion (name, title, width) values ('nombrePdv','Cliente', 10)
		insert #columnasConfiguracion (name, title, width) values ('direccion','Direccion', 10)
		insert #columnasConfiguracion (name, title, width) values ('tarea','Tarea Realizada', 10)
	end		

	select name,title,width from #columnasConfiguracion
		

	if(@NumeroDePagina>0)
		select convert(varchar,r.fechaCreacion,103) as fecha,
				u.usuario as usuario,
				pdv.nombre as nombrePdv,
				pdv.direccion as direccion,
				m.nombre as tarea
		from #datos d
		inner join reporte r on r.idReporte = d.idReporte
		inner join usuario u on u.idUsuario = d.idUsuario
		inner join puntodeventa pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
		inner join marca m on m.idMarca = d.idMarca
		where id between ((@NumeroDePagina - 1) * @TamaņoPagina + 1) and (@NumeroDePagina * @TamaņoPagina)
	
	if(@NumeroDePagina=0)
		select convert(varchar,r.fechaCreacion,103) as fecha,
				u.usuario as usuario,
				pdv.nombre as nombrePdv,
				pdv.direccion as direccion,
				m.nombre as tarea
		from #datos d
		inner join reporte r on r.idReporte = d.idReporte
		inner join usuario u on u.idUsuario = d.idUsuario
		inner join puntodeventa pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
		inner join marca m on m.idMarca = d.idMarca
		where id between ((@maxpag - 1) * @TamaņoPagina + 1) and (@maxpag * @TamaņoPagina)
		
	if(@NumeroDePagina<0)
		select convert(varchar,r.fechaCreacion,103) as fecha,
				u.usuario as usuario,
				pdv.nombre as nombrePdv,
				pdv.direccion as direccion,
				m.nombre as tarea
		from #datos d
		inner join reporte r on r.idReporte = d.idReporte
		inner join usuario u on u.idUsuario = d.idUsuario
		inner join puntodeventa pdv on pdv.idPuntoDeVenta = r.idPuntoDeVenta
		inner join marca m on m.idMarca = d.idMarca
		
end

go