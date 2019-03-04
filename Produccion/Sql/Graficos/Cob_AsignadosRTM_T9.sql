IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Cob_AsignadosRTM_T9'))
   exec('CREATE PROCEDURE [dbo].[Cob_AsignadosRTM_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Cob_AsignadosRTM_T9]
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

	create table #Categoria
	(
		idCategoria int
	)

	declare @cMarcas int = 0
	declare @cProductos int = 0
	declare @cCadenas int = 0
	declare @cZonas int = 0
	declare @cLocalidades int = 0
	declare @cUsuarios int = 0
	declare @cPuntosDeVenta int = 0
	declare @cCompetenciaPrimaria int = 0
	declare @cVendedores int = 0
	declare @cTipoRtm int = 0
	declare @cProvincias int = 0
	declare @cTags int = 0
	declare @cFamilia int = 0
	declare @cTipoPDV int = 0
	declare @cCategoria int = 0

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

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #Asignados
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	create table #Relevados
	(
		mes varchar(8)
		,qty int
	)

	create table #tempPCU
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		id int
	)

	create table #datosFinal(
		id int identity(1,1),
		idUsuario int,
		Usuario varchar(100),
		idPDV int,
		NombrePdv varchar(100),
		DireccionPdv varchar(200),
		Cuit varchar(50),
		Telefono varchar(50),
		Localidad varchar(100),
		Zona varchar(100),
		Provincia varchar(100),
		CodigoSAP varchar(100),
		CodigoAdicional varchar(50),
		Latitud numeric(11,8),
		Longitud numeric(11,8),
		Cadena varchar(100),
		Vendedor varchar(100),
		Equipo varchar(100),
		Correo varchar(100),
		Contacto varchar(100)
	)
	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #Asignados(mes,qty)
	select mes, 0 from #Meses

	declare @i int = 1
	declare @max int
	declare @currentFecha datetime
	select @max = MAX(id) from #Asignados
	while(@i<=@max)
	begin
		delete from #tempPCU
		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #Asignados where id=@i
		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where convert(date,Fecha)<=convert(date,@currentFecha)
		and pcu.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		update #Asignados set qty = 
		(
			select count(distinct IdPuntoDeVenta) from #tempPCU
		) where id=@i
		
		set @i=@i+1
	end

	insert #datosFinal
	select	t.idUsuario,
			u.Apellido+', '+u.Nombre collate database_default,
			t.IdPuntoDeVenta,
			ltrim(rtrim(pdv.Nombre)),
			ltrim(rtrim(pdv.Direccion)),
			pdv.Cuit,
			pdv.Telefono,
			ltrim(rtrim(l.Nombre)) as Localidad,
			ltrim(rtrim(z.Nombre)) as Zona,
			ltrim(rtrim(pr.Nombre)) as Provincia,
			pdv.CodigoSAP,
			pdv.CodigoAdicional,
			pdv.Latitud,
			pdv.Longitud,
			ltrim(rtrim(c.Nombre)) as Cadena,
			ltrim(rtrim(v.Nombre)) as Vendedor,
			ltrim(rtrim(eq.Nombre)) as Equipo,
			pdv.Email,
			pdv.Contacto			
	from #tempPCU t
inner join Usuario u on u.IdUsuario = t.idUsuario
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = t.IdPuntoDeVenta
	left join Localidad l on l.IdLocalidad = pdv.IdLocalidad
	left join Zona z on z.IdZona = pdv.IdZona
	left join Provincia pr on pr.IdProvincia = l.IdProvincia
	left join Cadena c on c.IdCadena = pdv.IdCadena
	left join PuntoDeVenta_Vendedor pdvv on pdvv.IdPuntoDeVenta = pdv.IdPuntoDeVenta
	left join Vendedor v on v.IdVendedor = pdvv.IdVendedor
	left join Equipo eq on eq.IdEquipo = v.IdEquipo
	order by t.IdPuntoDeVenta

	--Cantidad de páginas
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
		insert #columnasConfiguracion (name, title, width) values ('idUsuario','idUsuario',5),('Usuario','Usuario',5),('idPDV','idPDV',5),('NombrePdv','NombrePdv',5),('DireccionPdv','DireccionPdv',5),('Cuit','Cuit',5),('Telefono','Telefono',5),('Localidad','Localidad',5),('Zona','Zona',5),('Provincia','Provincia',5),('CodigoSAP','CodigoSAP',5),('CodigoAdicional','CodigoAdicional',5),('Latitud','Latitud',5),('Longitud','Longitud',5),('Cadena','Cadena',5),('Vendedor','Vendedor',5),('Equipo','Equipo',5),('Correo','Correo',5),('Contacto','Contacto',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('idUsuario','idUser',5),('Usuario','User',5),('idPDV','idPDV',5),('NombrePdv','NamePdv',5),('DireccionPdv','Address',5),('Cuit','Cuit',5),('Telefono','Phone',5),('Localidad','Location',5),('Zona','Zone',5),('Provincia','Province',5),('CodigoSAP','SAP',5),('CodigoAdicional','AdditionalCode',5),('Latitud','Lat',5),('Longitud','Long',5),('Cadena','Retail',5),('Vendedor','Seller',5),('Equipo','Team',5),('Correo','Email',5),('Contacto','Contact',10)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select idUsuario,Usuario,idPDV,NombrePdv,DireccionPdv,Cuit,Telefono,Localidad,Zona,Provincia,CodigoSAP,CodigoAdicional,Latitud,Longitud,Cadena,Vendedor,Equipo,Correo,Contacto from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select idUsuario,Usuario,idPDV,NombrePdv,DireccionPdv,Cuit,Telefono,Localidad,Zona,Provincia,CodigoSAP,CodigoAdicional,Latitud,Longitud,Cadena,Vendedor,Equipo,Correo,Contacto from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select idUsuario,Usuario,idPDV,NombrePdv,DireccionPdv,Cuit,Telefono,Localidad,Zona,Provincia,CodigoSAP,CodigoAdicional,Latitud,Longitud,Cadena,Vendedor,Equipo,Correo,Contacto from #datosFinal
	
	end
GO