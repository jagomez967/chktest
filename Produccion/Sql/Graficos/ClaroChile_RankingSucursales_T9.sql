IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.ClaroChile_RankingSucursales_T9'))
   exec('CREATE PROCEDURE [dbo].[ClaroChile_RankingSucursales_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[ClaroChile_RankingSucursales_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
	,@mejores           bit = 0
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
	declare @strFDesdePeriodoAnterior varchar(30)
	declare @strFHastaPeriodoAnterior varchar(30)
	
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
	
	--PREGUNTAR SI ESTO ESTA BIEN ASI O SACARLO (PARA EL CASO EN EL QUE NO SE INGRESE FILTRO POR CLIENTE)
	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values (@idCliente) 
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

	create table #tempReporte
	(
		idEmpresa int,
		idPuntoDeVenta int,
		fechacreacion datetime,
		idReporte int
	)

	create table #TotalModulos 
	(
		IdReporte int,
		IdMarca int,
		TotalModulos Decimal(18,8)
	) 



	create table #datosFinal_pre
	(
		id int identity(1,1),
		idPDV int,
		idReporte int,
		qty numeric(18,7)
	)	

	
		create table #tablaPonderaciones
	(	idReporte int,
		idMarca int,
		ponderacionMarca decimal(9,5),
		idModulo int,
		ponderacionModulo decimal(9,5),
		idItem int,
		PonderacionItem decimal(9,5),
		Valor bit
	)
	CREATE NONCLUSTERED INDEX IX_reporte  
	ON #tablaPonderaciones (idReporte)  
	INCLUDE ([PonderacionMarca]);  
 


	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idEmpresa, IdPuntoDeVenta, fechaCreacion, idReporte)
	select	r.idEmpresa
			,r.IdPuntoDeVenta
			,--convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			  max(fechacreacion)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	where	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and exists(select 1 from #clientes where idCliente = c.idCliente)			
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	group by r.IdEmpresa, r.IdPuntoDeVenta--, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)
	
	
	--SI EL MODULO O ITEM NO LLEGA A CUBIR EL 100%, ENTONCES TENGO QUE ACTUALIZAR LAS PONDERACIONES.
	
	exec ClaroChile_Calculo_Ponderacion

		;with ModulosSobrecalificados(idReporte,idModulo,repeticiones)
	as
	(
	select idReporte,idModulo,count(distinct idItem) From #tablaPonderaciones 
	where valor = 1
	group by idReporte,idModulo
	having count(iditem) > 1
	)
	
	delete tp from #tablaPonderaciones as tp
	where exists(
	select 1 
	from modulosSobreCalificados
	where idReporte = tp.idReporte
	and idModulo = tp.idModulo
	)

	--select * From #TablaPonderaciones 

	insert #datosFinal_pre (idPDV, idReporte, qty)
	SELECT temp.idPuntoDeVenta as IdPDV 
		  ,temp.idReporte
		  ,(sum((t.Valor * t.PonderacionItem / 100.0)* (t.PonderacionModulo /100.0) * (t.PonderacionMarca / 100.0))/count(distinct t.idReporte))*100.0
			--avg(cast(i.Nombre as numeric(18,7))) as qty
	FROM #tempReporte temp
	inner join #tablaPonderaciones t on t.IdReporte = temp.IdReporte
	GROUP BY temp.idPuntoDeVenta, temp.idReporte	
	

	--Agrupo por mes para cada punto de venta

	create table #datosFinal
	(	id int identity,
		nombrePDV nvarchar(255),
		direccion nvarchar(500),
		cumplimiento decimal(18,2)
	)
	

	if @mejores = 0
	begin
		insert #datosFinal(nombrePDV,Direccion,cumplimiento)
		select top 10 p.nombre,
				p.direccion,
			   avg(d.qty) 'Cumplimiento'
		from #datosFinal_pre d
		inner join puntodeventa p on p.idPuntoDeVenta = d.idPDV
		group by p.nombre,p.direccion
		order by cumplimiento desc
	end
	else
	begin
		insert #datosFinal(nombrePDV,Direccion,cumplimiento)
		select top 10 p.nombre,
				p.direccion,
			   avg(d.qty) 'Cumplimiento'
		from #datosFinal_pre d
		inner join puntodeventa p on p.idPuntoDeVenta = d.idPDV
		group by p.nombre,p.direccion
		order by cumplimiento asc
	end
			   		
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
	begin
		insert #columnasConfiguracion (name, title, width) values ('Posicion','Posicion', 5)
		insert #columnasConfiguracion (name, title, width) values ('NombrePDV','Punto de Venta', 5)
		insert #columnasConfiguracion (name, title, width) values ('Direccion','Direccion', 5)
		insert #columnasConfiguracion (name, title, width) values ('cumplimiento','Cumplimiento', 5)
	end
	if(@lenguaje='en')
	begin
		insert #columnasConfiguracion (name, title, width) values ('Posicion','Posicion', 5)
		insert #columnasConfiguracion (name, title, width) values ('NombrePDV','Punto de Venta', 5)
		insert #columnasConfiguracion (name, title, width) values ('Direccion','Direccion', 5)
		insert #columnasConfiguracion (name, title, width) values ('cumplimiento','Cumplimiento', 5)
	end		

	select name,title,width from #columnasConfiguracion
		
	--Datos
	if @mejores = 0
	begin
		select top 10 row_number() OVER(ORDER BY cumplimiento DESC) AS Posicion,NombrePDV,Direccion,
		'<div style="text-align:center">'+cast(cast(cumplimiento as numeric(5,2)) as varchar) + '%  ' +
			case
			 when cumplimiento < 4.0 then '<img src="images/circuloRojo.png" width="16" height="16">'
			 when cumplimiento >=4.0 and cumplimiento < 6.0 then '<img src="images/circuloAmarillo.jpg" width="16" height="16">'
			 when cumplimiento >= 6 then '<img src="images/circuloVerde.png" width="16" height="16">'
			 else ''
			end
		+'</div>'
			as cumplimiento from #datosFinal
		order by cumplimiento desc,Posicion asc
	end
	else
	begin
		select top 10 row_number() OVER(ORDER BY cumplimiento ASC) AS Posicion,NombrePDV,Direccion,
		'<div style="text-align:center">' + cast(cast(cumplimiento as numeric(5,2)) as varchar) + '%  ' +
			case
			 when cumplimiento < 4.0 then '<img src="images/circuloRojo.png" width="16" height="16">'
			 when cumplimiento >=4.0 and cumplimiento < 6.0 then '<img src="images/circuloAmarillo.jpg" width="16" height="16">'
			 when cumplimiento >= 6 then '<img src="images/circuloVerde.png" width="16" height="16">'
			 else ''
			end
		 + '</div>'
			as cumplimiento from #datosFinal
		order by cumplimiento asc,Posicion asc
	end

end
	
go


