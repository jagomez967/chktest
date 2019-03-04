SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMarkersCoberturaCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetMarkersCoberturaCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetMarkersCoberturaCliente]
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
	--if @idCliente = 147
	--BEGIN
	--	Execute dbo.GetMarkersCobertura_lanix
	--		@IdCliente			= @IdCliente
	--		,@Filtros			= @Filtros
	--		,@NumeroDePagina	= @NumeroDePagina
	--		,@Lenguaje			= @Lenguaje
	--		,@IdUsuarioConsulta = @IdUsuarioConsulta
	--		,@TamañoPagina		= @TamañoPagina

	--	return;
	--END

	
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

	insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''		
	if (@@rowcount = 0)
	BEGIN
		insert #fechaCreacionReporte(fecha)
		select cast('M' as char(10))
			
		insert #fechaCreacionReporte(fecha)
		select convert(char(6), getdate(), 112) + '01'
	
		insert #fechaCreacionReporte(fecha)
		select convert(char(10), dateadd(DAY,-1,dateadd(MONTH,1,cast(convert(char(6), getdate(), 112) + '01' as datetime))),112)

		
	END

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

	select @strFDesde = fecha from #fechaCreacionReporte where id = 2
	select @strFHasta = fecha from #fechaCreacionReporte where id = 3

	if(@strFDesde='00010101' or @strFDesde is null)
		set @fechaDesde=dateadd(day,-day(getdate()) + 1, getdate())	
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2

	if(@strFHasta='00010101' or @strFHasta is null)
		set @fechaHasta = getdate()
	else
		select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3
	

	
	create table #Clientes (idCliente int)

	insert  #clientes(idCliente)
	select idCliente 
	From familiaClientes 
	where familia in (
		select familia 
		from familiaclientes 
		where idCliente  = @idCliente  
			and activo = 1 )
	if @@ROWCOUNT = 0
	insert #clientes(idCliente)
	values(@idCliente)
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	create table #tempPDV(idUsuario int,idPuntodeventa int,visitado int,icono varchar(50),latitud decimal(11,8),longitud decimal(11,8),FechaUltimoReporte datetime)

	insert #tempPDV(idUsuario,idPuntodeventa,visitado,icono,latitud,longitud)
	select pcu.IdUsuario,pcu.IdPuntoDeVenta,0,'sinReporte.png',pdv.Latitud,pdv.Longitud 
	from PuntoDeVenta_Cliente_Usuario pcu 
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = pcu.IdPuntoDeVenta
	where not exists(select 1 from PuntoDeVenta_Cliente_Usuario		
					 where IdPuntoDeVenta = pcu.IdPuntoDeVenta 
					 and   IdUsuario = pcu.IdUsuario
					 and   IdCliente = pcu.idCliente
					 and   IdPuntoDeVenta_Cliente_Usuario > pcu.IdPuntoDeVenta_Cliente_Usuario 
					 and CONVERT(date,Fecha) <= CONVERT(date,@fechaHasta))
	and convert(date,pcu.Fecha) <= convert(date,@fechaHasta)
	and pcu.Activo = 1 
	and pcu.IdCliente in(select IdCliente from #Clientes)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario))
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and isnull(pdv.latitud,0) <> 0
	and isnull(pdv.longitud,0) <> 0

	--Solo cuento un pdv por usuario
	;WITH tempDelete AS(
	select repeticion = ROW_NUMBER()OVER(PARTITION BY IdPuntoDeVenta ORDER BY IdPuntoDeVenta),idPuntodeventa
	from #tempPDV)
	DELETE FROM tempDelete where repeticion > 1 


	create table #tempReporte(idUsuario int,idPuntodeventa int,idReporte int,fecha datetime,latitud decimal(11,8), longitud decimal(11,8))	
	insert #tempReporte(idUsuario,idPuntodeventa,idReporte,fecha,latitud,longitud)
	select r.idUsuario,p.IdPuntoDeVenta, r.IdReporte, r.FechaCreacion,ISNULL(r.Latitud,p.Latitud), ISNULL(r.Longitud,p.Longitud)   
	from Reporte r 
	inner join cliente c on c.idempresa=r.idempresa
	inner join puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
	where c.IdCliente in(select IdCliente from #Clientes)
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario))
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and COALESCE(r.Latitud,p.Latitud,0) <> 0
			and COALESCE(r.Longitud,p.Longitud,0) <> 0
	update t 
	set icono = 'PdvPosition.png',
		FechaUltimoReporte = tr.Maxfecha,
		visitado = 1 
	from #tempPDV t
	inner join (select idPuntodeventa, max(fecha) as MaxFecha 
				from #tempReporte 
				group by idPuntodeventa) tr on tr.idPuntodeventa = t.idPuntodeventa
	
	select t.latitud,
		   t.longitud,
		   t.visitado,
		   t.icono as icon, 
		   t.idPuntodeventa,
		   t.FechaUltimoReporte,
		   u.apellido + ', ' + u.nombre collate database_default as Usuario
	from #tempPDV t 
	inner join usuario u on u.idUsuario = t.idUsuario 
	where t.longitud between -180 and 180
	and t.latitud between -90 and 90
	UNION
	select t.latitud,
		   t.longitud,
		   1 as visitado,
		   'conReporte.png' as icon,
		   t.idPuntodeventa,
		   t.fecha as FechaUltimoReporte,
		   u.Apellido +', '+ u.Nombre collate database_default as Usuario
	from #tempReporte t	
	inner join Usuario u on u.IdUsuario = t.idUsuario
	where t.longitud between -180 and 180
	and t.latitud between -90 and 90

end
GO


[GetMarkersCoberturaCliente] 44