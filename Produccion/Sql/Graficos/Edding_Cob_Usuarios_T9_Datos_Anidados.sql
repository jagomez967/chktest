IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Edding_Cob_Usuarios_T9_Datos_Anidados'))
   exec('CREATE PROCEDURE [dbo].[Edding_Cob_Usuarios_T9_Datos_Anidados] AS BEGIN SET NOCOUNT ON; END')
GO --Edding_Cob_Usuarios_T9_Datos_Anidados 127
/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20170701,20171031')
insert into @p2 values(N'idUsuario',N'849')

exec Edding_Cob_Usuarios_T9_Datos_Anidados @IdCliente=127,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es',@IdUsuarioConsulta=827,@TamaņoPagina=0

*/

alter procedure [dbo].[Edding_Cob_Usuarios_T9_Datos_Anidados]
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
	declare @IdUsuario int
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
		
	select @IdUsuario = cast(Valores as int) from @Filtros where IdFiltro = 'IdUsuario'

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

	


	create table #Asignados
	(
		direccion varchar(max),
		clientes int,
		idPuntodeventa int
	)

	insert #Asignados (direccion,clientes)
	select pdv.direccion,count(distinct pc.idCliente) 
	from puntodeventa pdv
	inner join(
		Select IdPuntoDeVenta,idCliente from PuntoDeVenta_Cliente_Usuario where idPuntodeventa_Cliente_usuario in
		(
			select max(pcu.idpuntodeventa_cliente_usuario)as id
			from puntodeventa_cliente_usuario pcu
			inner join PuntoDeVenta p on p.idpuntodeventa = pcu.idpuntodeventa
			where	pcu.idUsuario = @IdUsuario
					and  exists(select 1 from #clientes where idCliente = pcu.idCliente)
					and convert(date,Fecha)<=convert(date,@fechaHasta)
					and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			group by pcu.idpuntodeventa
		)
		and activo = 1
	)pc
	on	pc.idPuntodeventa = pdv.idPuntodeventa
 		group by pdv.direccion

	delete from	#Asignados
	where clientes < (select max(clientes) from #Asignados)

	create table #Relevados
	(
		direccion varchar(max),
		clientes int,
		idPuntodeventa int
	)	

	insert #Relevados (direccion,clientes)
	select pdv.direccion, count(distinct pc.idCliente)
	 from puntodeventa PDV
	 inner join
	 (
		select r.idpuntodeventa,c.idCliente
		from reporte r
		inner join Puntodeventa p on p.idpuntodeventa = r.idpuntodeventa
		inner join cliente c on c.idempresa = r.idempresa
		where	 exists(select 1 from #clientes where idCliente = c.idCliente)
				and r.idusuario = @idusuario
				and convert(date,r.fechacreacion) between convert(Date, @fechadesde) and convert(date, @fechahasta)
				and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
				and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
				and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
				and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
				and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
				and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
				and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
				and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		)pc 
		on pc.idPuntodeventa = pdv.idPuntodeventa
 		group by pdv.direccion
		--having count(distinct pc.idCliente) = @nroClientes

	delete from #Relevados
	where Clientes < (select max(clientes) from #relevados)

	create table #datosFinal
	(
		id int identity(1,1),
		nested1 varchar(max),
		nested2 varchar(10)
	)


	update a
	set idPuntodeventa = pdv.idPuntodeventa
	from #asignados a
	inner join puntodeventa pdv 
	on a.direccion = pdv.direccion collate database_default
	where pdv.idCliente = (select min(idCliente) from #clientes) --EL CLIENTE MAS "ALTO" ES QUE CONTIENE A LOS OTROS
	
	update r 
	set idPuntodeventa = pdv.idPuntodeventa
	from #relevados r
	inner join puntodeventa pdv 
	on r.direccion = pdv.direccion collate database_default
	where pdv.idCliente = (select min(idCliente) from #clientes) 
	

	insert #datosFinal (nested1, nested2)
	select ltrim(rtrim(pdv.nombre)), case when r.direccion is null then 'NO' else 'SI' end
	from #Asignados a
	inner join PuntoDeVenta pdv on pdv.idPuntodeventa = a.idPUntodeventa
	left join #Relevados r on r.direccion = a.direccion
	order by case when r.direccion is null then 'NO' else 'SI' end, ltrim(rtrim(pdv.nombre))

	select 1 --pagina

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('nested1','Punto de Venta',50),('nested2','Relevado',30)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('nested1','Point of Sale',50),('nested2','Visited',30)

	select name, title, width from #columnasConfiguracion

	select nested1, nested2 from #datosFinal order by nested2 desc
end
go