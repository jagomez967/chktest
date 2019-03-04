IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Savant_CoberturaZonaUsuario_T20'))
   EXEC('CREATE PROCEDURE [dbo].[Savant_CoberturaZonaUsuario_T20] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Savant_CoberturaZonaUsuario_T20]
(
	@IdCliente			INT,
	@Filtros			FiltrosReporting READONLY,
	@NumeroDePagina		INT = -1,
	@Lenguaje			VARCHAR(3) = 'es',
	@IdUsuarioConsulta	INT = 0,
	@TamañoPagina		INT = 0
)

AS
BEGIN

	SET LANGUAGE spanish
	set nocount on

	--if @lenguaje = 'es' set language spanish
	--if @lenguaje = 'en' set language english

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
	create table #Categoria
	(
		idCategoria int
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
	declare @cCategoria varchar(max)

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
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	

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

		
	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	set @fechaDesdeMeses=@fechaDesde
	set @fechaHastaMeses=@fechaHasta

	create table #meses
	(
		id int identity(1,1)
		,mes varchar(8)
		,qty int
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes,qty) select convert(varchar, @fechaDesdeMeses,112),0
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end

	create table #asignados
	(
		id int
		,idUsuario int
		,idPuntoDeVenta int
		,mes varchar(8)
	)

	create table #Relevados
	(
		idUsuario int
		,qty int
		,mes varchar(8)
	)

	create table #ReVisitados
	(
		idUsuario int
		,qty int
		,mes varchar(8)
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
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	declare @i int = 1
	declare @max int
	declare @currentFechaHasta datetime
	select @max = MAX(id) from #meses
	while(@i<=@max)
	begin
		delete from #tempPCU

		--select @fechaHasta=dateadd(day,-1,DATEADD(month,1,mes)) from #meses where id=@i
		set @currentFechaHasta = dateadd(month,1,dateadd(day,-day(@fechaHasta),@fechaHasta))

		insert #tempPCU (idCliente, idUsuario, IdPuntoDeVenta, id)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		where convert(date,Fecha)<=convert(date,@currentFechaHasta)
		and exists(select 1 from #clientes where idCliente = pcu.idCliente)
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=pcu.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
		and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
		and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
		and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	
		group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta


		delete from #tempPCU where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#tempPCU.id and p.Activo=0)

		insert #asignados (id, idUsuario, idPuntoDeVenta,mes)
		select @i, idUsuario, IdPuntoDeVenta,convert(varchar, dateadd(day, -(day(@currentFechaHasta) - 1), @currentFechaHasta),112)
		from #tempPCU
		
		set @i=@i+1
	end

	/*busco relevados*/
	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes,idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,r.idReporte 
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = p.idCategoria))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	
	insert #Relevados (idUsuario, qty,mes )
	select idUsuario, count(distinct IdPuntoDeVenta),mes from #tempReporte group by idUsuario,mes
	


	insert #ReVisitados(idUsuario,qty,mes)
	select idUsuario, count(distinct IdPuntodeventa),mes from
		(select idUsuario,IdPuntodeventa,count(distinct idReporte)as qtyRepos ,mes
		from #tempReporte
		group by idUsuario,IdPuntoDeVenta,mes
		having count(distinct idReporte) > 1)x
	group by idUsuario ,mes

	create table #resultados
	(
		idUsuario int,
		nombre nvarchar(max),
		asignados int,
		relevados int,
		revisitados int,
		restantes int, 
		objetivoReVisita int
	)
	
	insert #resultados (idUsuario,nombre,asignados,relevados,revisitados,restantes,objetivoReVisita)
	select u.idUsuario 
	,u.Apellido+', '+u.Nombre collate database_default
	,COUNT(distinct a.idpuntodeventa)
	,isnull(r.qty,0)
	,isnull(v.qty,0)
	,COUNT(distinct a.idpuntodeventa) - isnull(r.qty,0)
	,isnull(sr.Revisitas,0)
	from #asignados a
	inner join Usuario u on u.IdUsuario=a.idUsuario	
	left join SavantObjetivoRevisita sr on sr.idUsuario = u.idUsuario and a.mes = convert(varchar, dateadd(day, -(day(sr.fecha) - 1), sr.fecha),112)
	left join #Relevados r on r.idUsuario = a.idUsuario and a.mes = r.mes 
	left join #ReVisitados v on v.idUsuario = a.idUsuario and a.mes = v.mes
	group by  u.idUsuario,u.Apellido+', '+u.Nombre collate database_default, r.qty,v.qty,sr.Revisitas
	order by  u.idUsuario,u.Apellido+', '+u.Nombre collate database_default
	
	---select sum(asignados)asignados,sum(relevados),sum(revisitados) revisitados,sum (restantes) restantes,sum(objetivoReVisita) objetivoReVisita from #resultados
	
	create table #datosFinal
	(
		id int identity(1,1),
		idUsuario int,
		usuarionombre varchar(200),
		asignados int,
		relevados int,
		porcentaje decimal(18,2),
		reVisitados int,
		objetivoReVisita int,
		CoberturaReVisita decimal(18,2),
		totalObjetivo int,
		totalContactos int,
		totalPorcentaje decimal(18,2)
	)
	
	create table #VisitaTotales(idUsuario int,qty int)
	
	insert #VisitaTotales(idUsuario,qty)
	SELECT idUsuario, count(idReporte) from
	#tempReporte
	group by idUsuario

	
	insert #datosFinal (idUsuario, usuarionombre, asignados, relevados, porcentaje,reVisitados,objetivoReVisita,CoberturaReVisita,totalObjetivo,totalContactos,totalPorcentaje)
	select	r.idUsuario
			,r.nombre 
			,r.asignados 
			,r.relevados 
			,isnull(r.Relevados * 100.0 / NULLIF(r.asignados,0) ,0)
			,r.revisitados
			,r.objetivoReVisita
			,isnull(r.revisitados * 100.0 / NULLIF(r.objetivoReVisita,0),0)
			,r.asignados + r.objetivoReVisita
			,isnull(vt.qty,0)
			,isnull( (vt.qty)*100.0 / NULLIF(r.asignados + r.objetivoReVisita,0),0)
	from #resultados r	
	left join #VisitaTotales vt on vt.idUsuario = r.idUsuario 
	order by r.idUsuario 
	
	

	insert #datosFinal(idUsuario,usuarionombre,asignados,relevados,porcentaje,reVisitados,objetivoReVisita,CoberturaReVisita,totalObjetivo,totalContactos,totalPorcentaje)
		select 99999,'TOTAL' , sum(asignados),sum(relevados),
		cast(sum(relevados) *100.0 /NULLIF(sum(asignados),0) as decimal(10,2)),
		sum(revisitados),sum(objetivoReVisita),
		cast(sum(revisitados) * 100.0 / NULLIF(sum(objetivoReVisita),0) as decimal(10,2)),
		sum(totalObjetivo),sum(totalContactos),
		cast(sum(totalContactos) * 100.0 / NULLIF(sum(TotalObjetivo),0)	as decimal(10,2))
		from #datosFinal


	SELECT 1

	create table #ColumnasDef(name varchar(1000),title varchar(1000), width int, orden int)

	IF ISNULL(@Lenguaje,'ES') = 'ES' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Usuario','Usuario',10,2),
		('Asignados','Asignados',10,3),
		('Relevados','Relevados',10,4),
		('Restantes','Restantes',10,5),
		('Porcentaje','Porcentaje',10,6),
		('ObjetivoVisitas','Objetivo Re-Visitas',10,7),
		('Visitas','Re-Visitas',10,8),
		('CoberturaVisitas','Cobertura Re-Visitas',10,9),
		('TotalObjetivo','Total Objetivo', 10,10),
		('TotalContactos','Total Contactos',10,11),
		('TotalPorcentaje','% Total',10,12)
	END

	IF ISNULL(@Lenguaje,'EN') = 'EN' BEGIN
		INSERT INTO #ColumnasDef (name, title, width, orden) VALUES 
		('Usuario','User',10,2),
		('Asignados','Assigned',10,3),
		('Relevados','Done',10,4),
		('Restantes','Left',10,5),
		('Porcentaje','Percent',10,6),
		('ObjetivoVisitas','Visit Target',10,7),
		('Visitas','Visits',10,8),		
		('CoberturaVisitas','Visits Coverage',10,9),
		('TotalObjetivo','Target Total', 10,10),
		('TotalContactos','Visit Total',10,11),
		('TotalPorcentaje','% Total',10,12)
	END

	select name,title,width from #ColumnasDef

	select usuarionombre as Usuario, asignados as Asignados, relevados as Relevados,
	asignados - relevados as Restantes, cast(porcentaje as varchar(100)) + ' %' as Porcentaje,
	objetivoReVisita as ObjetivoVisitas,reVisitados as Visitas,
	cast(CoberturaReVisita as varchar(100)) + ' %' as CoberturaVisitas,
	TotalObjetivo,TotalContactos,
	cast(TotalPorcentaje as varchar(100))+ ' %' as TotalPorcentaje
	from #datosFinal
END


