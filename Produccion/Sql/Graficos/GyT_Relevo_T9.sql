IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GyT_Relevo_T9'))
   exec('CREATE PROCEDURE [dbo].[GyT_Relevo_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[GyT_Relevo_T9]
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

	create table #asignados
	(
		idUsuario int
		,idPuntoDeVenta int
		,idreporte int
	)

	create table #Relevados
	(
		idUsuario int
		,idreporte int
		,idpuntodeventa int
		,fecha datetime
	)

	create table #maxidasignado
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		idMaxAsignado int
	)

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes date,
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		pdv varchar(max),
		usuario varchar(max),
		fecha varchar(15),
		checkin varchar(5),
		checkout varchar(5)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------


		insert #maxidasignado (idCliente, idUsuario, IdPuntoDeVenta, idMaxAsignado)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join usuario_cliente cu on cu.idcliente=pcu.idcliente and pcu.idusuario=cu.idusuario
		where convert(date,Fecha)<=convert(date,@fechaHasta)
		and pcu.idCliente = @idcliente
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #maxidasignado where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#maxidasignado.idMaxAsignado and p.Activo=0)

		insert #asignados (idUsuario, idPuntoDeVenta)
		select idUsuario, IdPuntoDeVenta
		from #maxidasignado

	/*busco relevados*/
	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(date,r.Fechacreacion)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by c.IdCliente ,r.idReporte ,r.IdUsuario ,r.IdPuntoDeVenta ,r.Fechacreacion


	insert #Relevados (idpuntodeventa, idreporte, idusuario, fecha)
	select distinct IdPuntoDeVenta, idreporte, idusuario, mes from #tempReporte

	create table #Resultados
	(
		idpdv int,
		idreporte int,
		idusuario int,
		propiedad int
	)

	insert #Resultados (idpdv, idreporte, idusuario, propiedad)
	select	a.idpuntodeventa, r.idreporte, a.idusuario,
			case when exists (select 1 from #relevados r where r.idpuntodeventa = a.idpuntodeventa) then (select top 1 idMarcaPropiedad from ReporteMarcaPropiedad rm where rm.idReporte = r.idReporte)
			else 0 end
	from #asignados a
	left join #relevados r on a.idpuntodeventa = r.idpuntodeventa and a.idusuario = r.idusuario

	
	create table #checkIn
	(
		idpdv int,
		idusuario int,
		fecha date,
		idreporte int
	)
	
	insert #checkIn (idpdv, idusuario, fecha, idreporte)
	select res.idpdv, res.idusuario, convert(date,r.FechaCreacion), max(res.idreporte) from #Resultados res
	inner join Reporte r on r.idReporte = res.idReporte
	inner join MarcaPropiedad mp on mp.idMarcaPropiedad = res.propiedad
	where mp.Nombre like '%Check In%'
	group by res.idpdv, res.idusuario, convert(date,r.FechaCreacion)


	create table #checkOut
	(
		idpdv int,
		idusuario int,
		fecha date,
		idreporte int
	)

	insert #checkOut (idpdv, idusuario, fecha, idreporte)
	select res.idpdv, res.idusuario, convert(date,r.FechaCreacion), max(res.idreporte) from #Resultados res
	inner join Reporte r on r.idReporte = res.idReporte
	inner join MarcaPropiedad mp on mp.idMarcaPropiedad = res.propiedad
	where mp.Nombre like '%Check Out%'
	group by res.idpdv, res.idusuario, convert(date,r.FechaCreacion)


	insert #datosFinal (pdv, usuario, fecha, checkin, checkout)
	select	ltrim(rtrim(pdv.Nombre)),
			u.Nombre+', '+u.Apellido collate database_default,
			Convert(varchar(10),CONVERT(date,c1.fecha,106),103),
			substring(convert(varchar, re.FechaCreacion,108),1,5),
			substring(convert(varchar, re2.FechaCreacion,108),1,5)
	from #checkIn c1
	inner join #checkOut c2 on c1.idpdv = c2.idpdv and c1.idusuario = c2.idusuario and c1.fecha = c2.fecha
	inner join Reporte re on re.idReporte = c1.idreporte
	inner join Reporte re2 on re2.idReporte = c2.idreporte
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = c1.idpdv
	inner join Usuario u on u.idUsuario = c1.idusuario
	order by Convert(varchar(10),CONVERT(date,c1.fecha,106),103) desc
	
	insert #datosFinal (pdv, usuario, fecha, checkin, checkout)
	select	ltrim(rtrim(pdv.Nombre)),
			u.Nombre+', '+u.Apellido collate database_default,
			'Sin Reporte',
			NULL,
			NULL
	from #Resultados r
	inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idpdv
	inner join Usuario u on u.idUsuario = r.idusuario


	--insert #datosFinal (pdv, usuario, fecha, estado)
	--select pdv, usuario, fecha, estado from
	--(
	--select	ltrim(rtrim(pdv.Nombre)) as pdv,
	--		u.Apellido+', '+u.Nombre collate database_default as usuario,
	--		case when r.propiedad is not null then re.FechaCreacion end as fecha,
	--		case when @NumeroDePagina>=0 then
	--			case when mprop.Nombre = 'Check in' then '<img src="images/circuloVerde.png" width="16" height="16"/>'
	--			when mprop.Nombre = 'Check out' then '<img src="images/circuloAzul.jpg" width="16" height="16"/>'
	--			else '<img src="images/circuloRojo.png" width="16" height="16"/>' end
	--		else
	--			ltrim(rtrim(isnull(mprop.Nombre,'Sin Reporte'))) end as estado
	--from #Resultados r
	--left join Reporte re on r.idReporte = re.idReporte
	--left join PuntoDeVenta pdv on pdv.idPuntoDeVenta = r.idpdv
	--left join Usuario u on u.idUsuario = r.idUsuario
	--left join MarcaPropiedad mprop on mprop.idMarcaPropiedad = r.propiedad
	--) x
	--order by fecha desc



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
		insert #columnasConfiguracion (name, title, width) values ('pdv','PuntoDeVenta',80),('usuario','Usuario',50),('fecha','Fecha',30),('checkin','Check In',30),('checkout','Check Out',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('pdv','Point Of Sale',80),('usuario','User',50),('fecha','Date',30),('checkin','Check In',30),('checkout','Check Out',30)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select pdv, usuario, fecha, checkin, checkout from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select pdv, usuario, fecha, checkin, checkout from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select pdv, usuario, fecha, checkin, checkout from #datosFinal
end

