IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Andromaco_Permanencia_T9_Datos_Anidados'))
   exec('CREATE PROCEDURE [dbo].[Andromaco_Permanencia_T9_Datos_Anidados] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Andromaco_Permanencia_T9_Datos_Anidados]
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
	declare @valores varchar(max)
	declare @usuario varchar(max)
	declare @fecha varchar(max)


	select @valores = valores from @Filtros where IdFiltro = 'idUsuario'

	Select @usuario = Substring(@valores,0,CharIndex(';',@valores))
	select @fecha = Substring(@valores,CharIndex(';',@valores)+1,len(@valores) - CharIndex(';',@valores))





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

	--insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros2 where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	--set @cUsuarios = @@ROWCOUNT

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

	declare @IdUsuario int

	--select @IdUsuario = cast(Valores as int) from @Filtros where IdFiltro = 'IdUsuario'

	if(@strFDesde='00010101' or @strFDesde is null)
		set @fechaDesde = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
	else
		select @fechaDesde=fecha from #fechaCreacionReporte where id = 2

	if(@strFHasta='00010101' or @strFHasta is null)
		set @fechaHasta = getdate()
	else
		select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------


	create table #tempReporte
	(
		IdPuntoDeVenta int,
		idReporte int,
		InicioReporte datetime,
		FinReporte datetime
	)

	create table #datosFinal
	(
		id int identity(1,1),
		PuntoDeVenta varchar(max),
		Inicio varchar(5),
		Fin varchar(5),
		Permanencia varchar(8)
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (IdPuntoDeVenta, idReporte,InicioReporte,FinReporte)
	select	r.IdPuntoDeVenta
			,max(r.idReporte)
			,r.FechaCreacion
			,r.FechaCierre
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) = convert(date,@fecha)
	and c.idCliente = @idcliente
	and r.idUsuario = @Usuario
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
	and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	group by r.IdUsuario ,r.IdPuntoDeVenta ,r.Fechacreacion,r.fechaCierre


	insert #datosFinal (PuntoDeVenta,Inicio,Fin)
	select	pdv.nombre collate database_default,
			substring(convert(varchar, t.InicioReporte,108),1,5),
			substring(convert(varchar, t.FinReporte,108),1,5)
	from #TempReporte t
	inner join puntodeventa pdv on pdv.idPuntodeventa = t.idPuntodeventa
	where day(t.inicioReporte) = day(t.finReporte)
	order by t.InicioReporte

	insert #datosFinal (PuntoDeVenta,Inicio,Fin)
	select	pdv.nombre collate database_default,
			substring(convert(varchar, t.InicioReporte,108),1,5),
			'24:00'
	from #TempReporte t
	inner join puntodeventa pdv on pdv.idPuntodeventa = t.idPuntodeventa
	where day(t.inicioReporte) <> day(t.finReporte)
	order by t.InicioReporte
	
	--SET TIEMPO EN PDV
	update #datosFinal
	set Permanencia =  
	right('00'+cast(
			datediff(second,0,
				cast('20160101 00:'+ cast(Fin as varchar) as datetime)-
				cast('20160101 00:'+ cast(Inicio as varchar) as datetime))%3600/60
			as varchar)
	,2)
	+':'+
	right('00'+cast(
			datediff(second,0,
				cast('20160101 00:'+ cast(Fin as varchar)  as datetime)-
				cast('20160101 00:'+ cast(Inicio as varchar) as datetime))%3600%60
			as varchar)
	,2)
	from #datosFinal
	where Inicio is not null
	and Fin is not null
	and Inicio <= Fin

	update #datosFinal
	set Permanencia = '-'
	where Inicio is not null
	and Fin is not null
	and Inicio > Fin

	update #datosFinal
	set Permanencia = '-'
	where Fin = '24:00'

	select 1 --pagina

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(500),
		title varchar(500),
		width int
	)

	declare @maxlenPDV int
	
	select @maxLenPDV = max(len(Puntodeventa)) from #DatosFinal

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values 
		('nested1',replicate('_', (@maxLenPDV - 14)/2) + '<u>Punto de Venta</u>'+ replicate('_', (@maxLenPDV - 14)/2),50)
		,('nested2',+ replicate('_',4) + '<u>Inicio</u>'+ replicate('_',4)+' ' ,30)
		,('nested3',+ replicate('_',5) + '<u>Fin</u>' + replicate('_',6)+' ' ,30)
		,('nested4','<u>Permanencia</u>',30)



	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values 
		('nested1','Point of Sale',50)
		,('nested2','Address',30)
		,('nested3','Visited',30)
		,('nested4','Permanence',30)

	select name, title, width from #columnasConfiguracion

	select PuntoDeVenta as nested1,
		   '<div style align="center">' +Inicio+ ' hs'+ '<div>' as nested2,
		   CASE when fin = '24:00' then '<div style align="center">Finalizado luego de 24hs<div>'
		   ELSE'<div style align="center">' +Fin  + ' hs' + '<div>'
		   END as nested3, 
		   '<div style align="center">' + 
		   case when len(permanencia) > 1 
			then Permanencia + 'hs' 
			else permanencia
			end 
			+ '<div>' 
			as nested4 
	 from #datosFinal-- order by nested2 desc

END
GO

