IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Whirpool_Capacitaciones_T1'))
   exec('CREATE PROCEDURE [dbo].[Whirpool_Capacitaciones_T1] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Whirpool_Capacitaciones_T1] 	
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


	create table #tempReporte
	(
		
		Idpdv int,
		IdReporte int,
		fecha varchar(8),
		usuario int,
		nombre varchar(200)
	)

	-------------------------------------------------------------------- TEMPS (Filtros)

	
	insert #tempReporte ( Idpdv, IdReporte,fecha, usuario,nombre)
	select distinct  p.IdPuntoDeVenta, r.idreporte,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112), u.idusuario,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Usuario
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	inner join usuario u on u.idUsuario = r.IdUsuario
	where	c.IdCliente=@IdCliente
		and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))			
	group by p.IdPuntoDeVenta,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112),u.idusuario,
	U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT,r.idreporte
	
--select * from #tempReporte
	
	create table  #datos_fecha
	
	(
	usuario int,
	cantidad int,
	meses varchar(20),
	año int 
	)
	
	
	insert into #datos_fecha(usuario,cantidad,meses,año)
	select distinct id_user, isnull(cantidad1,0),convert(varchar(20), '01' + '-' + left(meses, 3) + '-' + convert(varchar, year(@fechaDesde))),año
	from Capacitaciones_Whirpool c
	unpivot 
	(cantidad1 for meses in(enero,febrero,marzo,abril,junio,julio,agosto,septiembre,octubre,noviembre,diciembre )) as pvt
	group by  id_user,cantidad1,convert(varchar(20), '01' + '-' + left(meses, 3) + '-' + convert(varchar, year(@fechaDesde))),año
	order by convert(varchar(20), '01' + '-' + left(meses, 3) + '-' + convert(varchar, year(@fechaDesde)))
	
    
	create table  #datos
	
	(
	usuario int,
	cantidad int,
	fecha varchar(20),
	meses varchar(20),
	año int 
		
	)

	insert into #datos(usuario,cantidad,meses,año)
	select usuario,isnull(cantidad,0),
	RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,meses),'')))),2), año 
	from #datos_fecha 
    --where  RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,meses),'')))),2)  
	--between   RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,@fechaDesde),'')))),2) and 
	--RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,CONVERT(DATE,ISNULL(CONVERT(VARCHAR,@fechaHasta),'')))),2) 
	
	create table  #datos_fecha_mes	
	(
	usuario int,
	cantidad int,
	fecha varchar(20)	
	)
	
	insert into #datos_fecha_mes(usuario,cantidad,fecha)
	select usuario,cantidad,convert(varchar(20), '01-' + left(meses, 3) + '-' + convert(varchar, año)) 
	from #datos
	
	create table  #datos_fecha_mes_final
	(
	usuario int,
	cantidad int,
	fecha varchar(20)	
	)
	
	insert into #datos_fecha_mes_final(usuario,cantidad,fecha)
	select usuario,cantidad,convert(varchar, dateadd(day, -(day(fecha) - 1), fecha),112)
	from #datos_fecha_mes
	where convert(varchar, dateadd(day, -(day(fecha) - 1), fecha),112)
	between convert(varchar, dateadd(day, -(day(@fechaDesde) - 1), @fechaDesde),112) 
	and convert(varchar, dateadd(day, -(day(@fechaHasta) - 1), @fechaHasta),112) 
	
	
	
	
	--select * from #datos_fecha_mes_final
	
	
	
	
	create table #datosRes
	(
		categoria varchar(100),
		total int,
		meses int,
		id_usuario int
	)
	create table #datos_alcance
	(
	    
		alcance varchar(100),
		total_alcance int,
		meses int,
		id_usuario int
	)
	
	
	
	
	create table #datos_alcance_cap
	(
		capacitados varchar(100),
		total_capacitados int,
		alcance varchar(100),
		total_alcance int,
		id_usuario int
	)
	
	
	--------Cantidad
	if exists(select 1 from #usuarios where idUsuario is not  null)
	begin
		insert #datosRes (categoria, total,meses,id_usuario)
		select  ('Personas Capacitadas: ' + r.nombre),
		SUM(case when dbo.CleanAndTrimString(rmi.Valor4) not like '%[^0-9]%' then convert(int,dbo.CleanAndTrimString(rmi.Valor4)) else 0 end),r.fecha,r.usuario
		from MD_ReporteModuloItem rmi
		inner join #tempReporte r on r.IdReporte = rmi.IdReporte
		inner join MD_Item mi on mi.idItem = rmi.idItem
		where rmi.IdItem = 11227 
		and mi.idmodulo = 2442
		group by r.nombre,r.fecha,r.usuario
		
		create table #capacitados_total (
		id_usuario int,
		usuario varchar(200),
		capacitados int
		)
	
		insert into #capacitados_total (id_usuario,usuario,capacitados)
		select  id_usuario,categoria,sum(total) 
		from #datosRes group by id_usuario,categoria
		
		
		-------------------------------------------------------------------------------------------------------------------------------
		insert #datos_alcance (alcance, total_alcance,meses,id_usuario)
		select  'Alcance: ' + r.nombre,isnull(cantidad,0), d.fecha, r.usuario
		from #datos_fecha_mes_final d
		inner join #tempReporte r on r.Usuario = d.Usuario
		group by d.fecha,r.nombre,cantidad,r.usuario
		
		
		create table #alcance_total (
		id_usuario int,
		usuario varchar(200),
		capacitados int
		)
	
		insert into #alcance_total (id_usuario,usuario,capacitados)
		select  id_usuario,alcance,sum(total_alcance) 
		from #datos_alcance group by id_usuario,alcance
		
		
		--select * from #alcance_total
		
		insert #datos_alcance_cap(capacitados,total_capacitados,total_alcance)
		select 'Cantidad',a.capacitados,b.capacitados
		from #capacitados_total a,#alcance_total b
		where a.id_usuario = b.id_usuario 
		
		
	end
	else
	begin
		insert #datosRes (categoria, total,meses)
		select 'Personas Capacitadas',
		SUM(case when dbo.CleanAndTrimString(rmi.Valor4) not like '%[^0-9]%' then convert(int,dbo.CleanAndTrimString(rmi.Valor4)) else 0 end),
		convert(varchar, dateadd(day, -(day(r.fecha) - 1), r.fecha),112)
		from MD_ReporteModuloItem rmi
		inner join #tempReporte r on r.IdReporte = rmi.IdReporte
		inner join MD_Item mi on mi.idItem = rmi.idItem
		where rmi.IdItem = 11227 
		and mi.idmodulo = 2442
		group by mi.nombre,r.fecha
		
		---select * from #datosRes
		
		insert #datos_alcance (alcance, total_alcance,meses )
		select  'Alcance: ', 
		sum(isnull(cantidad,0)), fecha 
		from #datos_fecha_mes_final d
		group by fecha 
		
		--select * from #datos_alcance
		
		insert #datos_alcance_cap(capacitados,total_capacitados,alcance,total_alcance)
		select b.categoria,sum(b.total),a.alcance,sum(a.total_alcance)
		from  #datos_alcance a
		left join #datosRes  b on a.meses=b.meses
		group by b.categoria,a.alcance
		
		
	end
	
	
	
	---Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50)
	)
    
	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title) values ('capacitados','capacitados'),('total_alcance','Objetivo'),('total_capacitados','Capacitados')
		
	
	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title) values ('capacitados','capacitados'),('total_alcance','Objetivo'),('total_capacitados','Capacitados')
    
	select name, title from #columnasConfiguracion
    
	select isnull(capacitados,''),isnull(total_alcance,0),isnull(total_capacitados,0) from #datos_alcance_cap
end

--go
--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20181201,2019011')
----insert into @p2 values(N'fltpuntosdeventa',N'99647')
----insert into @p2 values(N'fltusuarios',N'3915')
----insert into @p2 values(N'fltMarcas',N'614')
--
--exec Whirpool_Capacitaciones_T1 @IdCliente=201,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'