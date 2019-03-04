IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.IsdinMesUsuario_T7'))
   exec('CREATE PROCEDURE [dbo].[IsdinMesUsuario_T7] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[IsdinMesUsuario_T7]
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
		set @fechaHasta = DATEADD(DAY,-1,(DATEADD(MONTH, 1, DATEADD(DAY,(DAY(GETDATE())*-1)+1,GETDATE()))))
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

	create table #datos
	(
		id int identity(1,1),
		valor decimal(6,2),		
		idUsuario int
	)

	/*
	create table #OtrasActividades
	(
		contactos float,
		objetivo float,
		idUsuario int,
		idPuntodeventa int,
		idModulo int,
		idItem	int,
		idCLiente int,
		dia date,
		respuesta varchar(500)
	)
	*/
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
	where	convert(date,FechaCreacion) >= convert(date,@fechaDesde) and convert(date,FechaCreacion) <= convert(date,@fechaHasta)
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
		nombreModulo varchar(100),
		nombreItem varchar(100),
		respuesta varchar(MAX),
		contactos float,
		idReporte int,
		fecha date
	)

	----------
	exec [IsdinBaseObjetivo] @fechaDesde, @fechaHasta, @idCliente
	exec [IsdinBaseContactos]
	----------

	---1 Resultset = 'DIA','FormatoDia','Cobertura/objetivo','Valor'
		select left(convert(varchar(10),fecha,112),6) as dia,
			   right(CONVERT(VARCHAR(11),fecha,6),6) as dia2,
			   'Objetivo' as Tipo,
			   sum(objetivo) as Valor
		from #baseObjetivo b
		where (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = b.IdUsuario)) and b.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		group by left(convert(varchar(10),fecha,112),6),right(CONVERT(VARCHAR(11),fecha,6),6)
	union
		select left(convert(varchar(10),fecha,112),6) as dia,
			   right(CONVERT(VARCHAR(11),fecha,6),6) as dia2,
			   'Contactos' as tipo,
			   sum(contactos) as valor
		from #baseContactos
		group by left(convert(varchar(10),fecha,112),6),right(CONVERT(VARCHAR(11),fecha,6),6)
	order by 3 desc

	
	--2 ResultSet = 'DIA','FormatoDIA','idUsuario','NombreUsuario','COBERTURA/OBJETIVO','Valor'
		select left(convert(varchar(10),b.fecha,112),6) as dia,
			   right(CONVERT(VARCHAR(11),b.fecha,6),6) as dia2,
			   b.idUsuario,
			   u.apellido + ', ' + u.nombre collate database_default usuario,
			   'Objetivo' as tipo,
			   sum(b.objetivo) as valor
		from #baseObjetivo b
		inner join usuario u on u.idUsuario = b.idUsuario
		where (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = b.IdUsuario)) and b.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		group by left(convert(varchar(10),b.fecha,112),6),b.idUsuario,u.apellido + ', ' + u.nombre collate database_default,right(CONVERT(VARCHAR(11),b.fecha,6),6)
	union
		select left(convert(varchar(10),b.fecha,112),6) as dia,
			   right(CONVERT(VARCHAR(11),b.fecha,6),6) as dia2,
			   b.idUsuario,
			   u.apellido + ', ' + u.nombre collate database_default usuario,
			   'Contactos' as tipo,
			   sum(b.contactos) as valor
		from #baseContactos b
		inner join usuario u on u.idUsuario = b.idUsuario
		group by left(convert(varchar(10),b.fecha,112),6),b.idUsuario,u.apellido + ', ' + u.nombre collate database_default,right(CONVERT(VARCHAR(11),b.fecha,6),6)
	order by 1,3 
		
	--3 ResultSet = 'DIA','FORMATODIA','IdUsuario','NombreUsuario','COBERTURA/OBJETIVO','idModulo','NombreModulo','Valor'
	select left(convert(varchar(10),b.fecha,112),6)  as dia,
			   right(CONVERT(VARCHAR(11),b.fecha,6),6) as dia2,
			   b.idUsuario,
			   u.apellido + ', ' + u.nombre collate database_default as nombreUsuario,
			   'Contactos' as tipo,
			   b.idModulo,
			   b.nombreModulo,			   
			   sum(b.contactos) as valor
		from #baseContactos b
		inner join usuario u on u.idUsuario = b.idUsuario
		group by left(convert(varchar(10),b.fecha,112),6),b.idUsuario,b.idModulo,b.nombreModulo,u.apellido + ', ' + u.nombre collate database_default,right(CONVERT(VARCHAR(11),b.fecha,6),6)
	order by 3 desc

end
go
