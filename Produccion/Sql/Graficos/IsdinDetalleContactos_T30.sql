IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IsdinDetalleContactos_T30'))
   exec('CREATE PROCEDURE [dbo].[IsdinDetalleContactos_T30] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[IsdinDetalleContactos_T30]
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
	declare @difDias int
	declare @fechaDesdeAnterior varchar(30)
	declare @fechaHastaAnterior varchar(30)

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
	
	create table #Clientes
	(
		idCliente int
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
	declare @cClientes varchar(max)

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

	insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''
	set @cClientes = @@ROWCOUNT
	
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end

	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)
	
	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)

	insert #Zonas(idZona)
	select z.idZona 
	from Zona z
	inner join
	(select nombre from Zona
	where idZona in (select idZona from #Zonas))pdx
	on pdx.nombre = z.nombre
	where z.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Zonas where idZona = z.idZona)

	insert #Localidades(idLocalidad)
	select l.idLocalidad
	from Localidad l
	inner join
	(select nombre from Localidad
	where idLocalidad in (select idLocalidad from #Localidades))pdx
	on pdx.nombre = l.nombre
	inner join Provincia p on p.idProvincia = l.idProvincia
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Localidades where idLocalidad = l.idLocalidad)

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
		IdReporte int,
		IdPuntodeventa int,
		dia date
	)
	
	create table #datosFinal
	(id int identity(1,1), 
	dia date,
	  dia2 varchar(10),
	  idUsuario int,
	  usuario varchar(max),
	  tipo varchar(10),
	  idModulo int,
	  modulo varchar(max),
	  contactos decimal(18,2),
	  idPuntodeventa int,
	  idCliente int,
	  nombrePDV varchar(max),
	  direccion varchar(max),
	  concepto varchar(max),
	  respuesta varchar(max),
	  nombreItem varchar(max),
	  idReporte int
	  )

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdReporte,IdPuntodeventa, dia)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdReporte
			,r.idPuntodeventa
			,cast(fechaCreacion as date) as dia
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente in (select idCliente from #clientes)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))

	
	--STAGE
	create table #baseObjetivo
	(	
		idUsuario int,
		Objetivo int,
		fecha date
	)
	
	create table #baseContactos
	(	idPuntodeventa int,
		idUsuario int,
		idModulo int,
		nombreModulo varchar(500),
		nombreItem varchar(100),
		respuesta varchar(500),
		contactos float,
		idReporte int,
		fecha date,
		idcliente int 
	)

	----------
	exec [IsdinBaseObjetivo] @fechaDesde, @fechaHasta, @idCliente
	exec [IsdinBaseContactos] 1
	----------
	
	update bc set contactos =
		isnull(bc.contactos,
		case c.idCliente
		when 153 then 1
		when 154 then 1
		when 152 then 1
		when 156 then 3
		when 158 then 2
		when 159 then (
			case nombreItem
			when '25%' then 1.5
			when '50%' then 3.0
			when '75%' then 4.5
			when '100%' then 6
			end
			)
		when 157 then (
			case nombreItem
			when '25%' then 1.5
			when '50%' then 3.0
			when '75%' then 4.5
			when '100%' then 6
			end
			)
		when 162 then (
			case nombreItem
			when '25%' then 1.5
			when '50%' then 3.0
			when '75%' then 4.5
			when '100%' then 6
			end
			)
		else 0
		end),
		bc.fecha = CONVERT(DATE,R.FechaCreacion)
	from #basecontactos bc
	inner join Reporte R on bc.idReporte = r.idReporte
	inner join Cliente C on R.idEmpresa = C.idEmpresa
	
	UPDATE bc SET bc.contactos = A.contactos
	FROM  #basecontactos bc
	INNER JOIN MD_ReporteModuloItem RMI ON bc.idReporte = RMI.idReporte
	INNER JOIN MD_Item I ON RMI.idItem = i.idItem
	INNER JOIN MD_Modulo M ON I.idModulo = M.idModulo
	INNER JOIN IsdinActividades A ON I.idItem = A.idItem
	AND M.idModulo = A.idModulo
	and RMI.Valor1 > 0

	---SELECT  DISTINCT * FROM  #basecontactos 

	insert #baseContactos(idPuntodeventa,idUsuario,nombreModulo,nombreItem,respuesta,contactos,fecha,idReporte,idModulo)
	SELECT R.idPuntoDeVenta,R.idUsuario,MC.Descripcion,'','',1,R.FechaCreacion,R.idReporte,NULL
	FROM #tempReporte T
	INNER JOIN Reporte R ON T.idReporte = R.idReporte
	INNER JOIN Cliente C ON R.idEmpresa = C.idEmpresa
	INNER JOIN M_ModuloCliente MC ON C.idCliente = MC.idCliente
		AND MC.idModulo = 1
	WHERE R.AuditoriaNoAutorizada = 1
	UNION
	SELECT R.idPuntoDeVenta,R.idUsuario,'Reporte Vacio','','',1,R.FechaCreacion,R.idReporte,NULL
	FROM #tempReporte T
	INNER JOIN Reporte R ON T.idReporte = R.idReporte
	LEFT JOIN MD_ReporteModuloItem RMI ON R.idReporte = RMI.idReporte
	WHERE R.AuditoriaNoAutorizada = 0 AND ISNULL(RMI.idReporte,0) = 0
	
	insert #datosFinal(dia,usuario,NombrePDV,direccion,concepto,contactos,respuesta,nombreItem,idReporte)
	select bc.fecha,u.apellido + ', ' + u.nombre collate database_default,pdv.nombre,pdv.direccion,bc.nombreModulo,bc.contactos,bc.respuesta,bc.nombreItem,bc.idReporte
	from #baseContactos bc
	inner join usuario u on u.idUsuario = bc.idUsuario
	left join puntodeventa pdv on pdv.idPuntodeventa = bc.idPuntodeventa
	

	SELECT idReporte, Mods = STUFF((
    SELECT N'<br> ' + '<b>' + concepto + '</b>' +case when isnull(nombreItem,'') != '' then nombreItem else '' end + case when isnull(respuesta,'') != '' then ': ' + respuesta else '' end FROM #datosfinal
    WHERE idReporte = df.idReporte
    FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')
	into #tmpModulos
	FROM #datosfinal AS df
	GROUP BY idReporte
	ORDER BY idReporte



	update #tmpModulos set Mods = RIGHT(Mods,len(Mods) - 3)

	delete df from #datosfinal df where isnull(Contactos,0) = 0 and (select count(1) from #datosfinal where idreporte = df.idReporte) != 1

	select CONVERT(VARCHAR,dia,103) Dia,usuario Usuario,NombrePDV PuntoDeVenta,direccion Direccion,(select Mods from #tmpModulos where idReporte = df.idReporte) Detalle,Contactos,idReporte Reporte from #datosfinal df group by dia,usuario,NombrePDV,direccion, contactos,idreporte


		
end

--go
--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20181211,20181211')
-----insert into @p2 values(N'fltpuntosdeventa',N'203325')
----insert into @p2 values(N'fltusuarios',N'2736')
-----insert into @p2 values(N'fltProductos',N'12656')
--
--exec IsdinDetalleContactos_T30 @IdCliente=160,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'
