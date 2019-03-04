IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_TiendasReportadas_T9'))
   exec('CREATE PROCEDURE [dbo].[Edding_TiendasReportadas_T9] AS BEGIN SET NOCOUNT ON; END')
GO---edding_tiendasReportadas_t9 127
alter procedure [dbo].[Edding_TiendasReportadas_T9]
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

	create table #tempReporte
	(
		idCLiente int,
		IdPuntoDeVenta int,
		idUsuario int,
		IdReporte int
	)

	create table #datos
	(
		id int identity (1,1),
		fecha datetime,
		pdv varchar(200),
		direccion varchar(200),
		usuario varchar(200),
		cadena varchar(200),
		zona varchar(200)
	)
	create table #tempPCU_final
	(
	--	idCliente int,
		usuario varchar(max),
		direccion varchar(max),
		id int	
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
		delete from #tempPCU_final

		select @currentFecha = dateadd(day,-1,dateadd(month,1,mes)) from #Asignados where id=@i
		
		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		left join PuntoDeVenta_Vendedor pv on pv.idpuntodeventa = p.idpuntodeventa
		where convert(date,Fecha)<=convert(date,@currentFecha)
		and exists(select 1 from #clientes where idCliente = pcu.idCliente)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)


				/*UNIFICAR REPORTES*/
		

		--Elimino aquellos que solo esten en uno de los dos clientes
		declare @nroClientes int
		select @nroClientes = count(distinct idCliente) from #tempPCU


		insert #tempPCU_final(usuario,direccion,id)
		select usr.Usuario,pdv.direccion,tmp.id from #tempPCU tmp
		inner join puntodeventa pdv 
		on pdv.idPuntoDeVenta = tmp.idpuntodeventa
		inner join usuario usr
		on usr.idUsuario = tmp.idusuario
		inner join(
			select pdv2.direccion,u.nombre,count(distinct t2.idCliente) as cantidad
			From #tempPCU t2
			inner join puntodeventa pdv2
			on pdv2.idPuntodeventa = t2.idpuntodeventa
			inner join usuario u
			on u.idusuario = t2.idusuario
			group by pdv2.direccion,u.nombre
			having count(distinct t2.idCliente) = @nroClientes
			)eliminados
		ON eliminados.direccion = pdv.direccion
		and eliminados.nombre = usr.nombre


		/*FIN UNIFICAR REPORTES*/



		update #Asignados set qty = 
		(
			select count(distinct direccion) from #tempPCU_final
		) where id=@i
		
		set @i=@i+1
	end
	
	insert #tempReporte (IdCliente,IdPuntoDeVenta, idUsuario, IdReporte)
	select	distinct
			c.idCliente
			,r.IdPuntoDeVenta
			,r.IdUsuario
			,min(r.IdReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Usuario u on u.IdUsuario = r.IdUsuario
	left join PuntoDeVenta_Vendedor pv on pv.idpuntodeventa = p.idpuntodeventa
	where convert(date,r.FechaCreacion) between convert(date,@fechadesde) and convert(date,@fechahasta)
	and exists(select 1 from #clientes where idCliente = c.idCliente)
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and isnull(u.escheckpos,0) = 0
	and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	group by 
			c.idCliente,r.IdPuntoDeVenta, r.IdUsuario


	/*UNIFICAR REPORTES*/
	create table #tempReporte_final
	(
	--	idCliente int,
		Usuario varchar(max),
		direccion varchar(max),
		mes varchar(8)	
	)
	if exists (select 1 from FamiliaClientes where IdCliente = @IdCliente) 
	BEGIN
		--Elimino aquellos que solo esten en uno de los dos clientes
		select @nroClientes = count(distinct idCliente) from #tempPCU

		insert #tempReporte_final(usuario,direccion)
		select distinct usr.Usuario,pdv.direccion from #tempReporte tmp
		inner join puntodeventa pdv 
		on pdv.idPuntoDeVenta = tmp.idpuntodeventa
		inner join usuario usr
		on usr.idUsuario = tmp.idusuario
		inner join(
			select pdv2.direccion,u.nombre,count(distinct t2.idCliente) as cantidad
			From #tempReporte t2
			inner join puntodeventa pdv2
			on pdv2.idPuntodeventa = t2.idpuntodeventa
			inner join usuario u
			on u.idusuario = t2.idusuario
			group by pdv2.direccion,u.nombre
			having count(distinct t2.idCliente) = @nroClientes
			)eliminados
		ON eliminados.direccion = pdv.direccion
		and eliminados.nombre = usr.nombre

		/*Ahora elimino de tempReporte todos los datos, e inserto solo aquellos que existan en los dos clientes*/	
		delete from #tempReporte

		insert #tempreporte (IdPuntoDeVenta, idUsuario, IdReporte)
		select pdv.idPuntoDeVenta, u.idUsuario, max(r.idReporte)
		from #tempreporte_final t
		inner join puntodeventa pdv on pdv.direccion = t.direccion collate database_default
		inner join usuario u on u.usuario = t.usuario collate database_default
		inner join usuario_cliente uc on uc.idUsuario = u.idUsuario
		inner join cliente c on c.idCliente = uc.idCliente
			and c.idCliente = pdv.idCliente
		inner join reporte r on r.idUsuario = u.idUsuario
			and r.idPuntoDeVenta = pdv.idPuntoDeVenta
			and r.idEmpresa = c.idEmpresa
		where convert(date,r.FechaCreacion) between convert(date,@fechadesde) and convert(date,@fechahasta)
			and c.idCliente = (select min(idCliente) from #tempPCU) 
		group by pdv.idPuntoDeVenta, u.idUsuario	
		/*FIN UNIFICAR REPORTES*/
	END 

	insert #datos
	select	r.FechaCreacion,
			ltrim(rtrim(pdv.nombre)),
			ltrim(rtrim(pdv.direccion)),
			u.Apellido,
			ltrim(rtrim(c.nombre)),
			ltrim(rtrim(z.nombre))
	from #tempReporte t
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = t.IdPuntoDeVenta
	inner join Reporte r on r.IdReporte = t.IdReporte
	inner join Usuario u on u.IdUsuario = t.idUsuario
	left join Cadena c on c.IdCadena = pdv.IdCadena
	inner join Zona z on z.IdZona = pdv.IdZona
	order by r.FechaCreacion, ltrim(rtrim(pdv.nombre))

	

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
		insert #columnasConfiguracion (name, title, width) values ('fecha','Fecha',5), ('pdv','PuntoDeVenta',5),('direccion','Direccion',5), ('usuario','Usuario',5), ('cadena','Cadena',5), ('zona','Zona',5)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('fecha','Date',5), ('pdv','PointOfSale',5),('direccion','Address',5), ('usuario','User',5), ('cadena','Retail',5), ('zona','Location',5)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select fecha, pdv, direccion, usuario, cadena, zona from #datos where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select fecha, pdv, direccion, usuario, cadena, zona from #datos where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select fecha, pdv, direccion, usuario, cadena, zona from #datos
		
end
go



declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20190102,20190131')
insert into @p2 values(N'fltusuarios',N'2280')

exec Edding_TiendasReportadas_T9 @IdCliente=239,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'


