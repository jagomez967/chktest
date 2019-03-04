 IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.andromaco_BaseDatosPDV_T9'))
   exec('CREATE PROCEDURE [dbo].[andromaco_BaseDatosPDV_T9] AS BEGIN SET NOCOUNT ON; END')
GO
--[andromaco_BaseDatosPDV_T9] 47
alter procedure [dbo].[andromaco_BaseDatosPDV_T9]
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
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = p.idLocalidad)))
	and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = p.idPuntodeventa  and pve2.idVendedor
	 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
		
	group by c.IdCliente ,r.IdUsuario ,r.IdPuntoDeVenta ,convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	create table #datosFinal
	(
		id int identity(1,1),      ClienteMobile varchar(max),IdPuntoDeVenta int,       Nombre varchar(200),
		Direccion varchar(500),    CUIT bigint,				  Telefono varchar(50),     email varchar(100),
		totalgondolas int,         totalEstantesGondola int,  TotalEstantesInterior int,TotalEstantesExterior int,
		TieneVidriera bit,         EspacioBacklight int    ,  Provincia varchar(50),    localidad varchar(50),
		CadenaMobile varchar(50),  tipo varchar(50),          Categoria varchar(50),    Dimension varchar(50),
		potencial varchar(50),     CodigoCadena varchar(50),  CodigoClienteMobile varchar(50),
		NombreVendedor varchar(50),Equipo varchar(50),        GiroCiudadAsiento varchar(50),
		PorfolioAVENO varchar(50), PorfolioDLB varchar(50),   PorfolioDLS varchar(50),  Visitas int,
		PropiedadAdicional varchar(max)
    )


	insert #datosFinal (ClienteMobile,IdPuntoDeVenta,Nombre,Direccion,CUIT,Telefono,email,totalgondolas,totalEstantesGondola,TotalEstantesInterior,TotalEstantesExterior,TieneVidriera,EspacioBacklight,Provincia,
		localidad,CadenaMobile,tipo,Categoria,Dimension,Potencial,CodigoCadena,CodigoClienteMobile,NombreVendedor,Equipo,GiroCiudadAsiento,PorfolioAVENO,PorfolioDLB,PorfolioDLS,Visitas,propiedadAdicional)
	 select ( usr.nombre collate database_default + ' ' +usr.apellido collate database_default ) as ClienteMovile ,
	  pdv.idPuntoDeVenta, pdv.nombre, pdv.direccion,pdv.CUIT, pdv.telefono, pdv.email, 
	 pdv.totalGondolas,pdv.TotalEstantesGondola,pdv.TotalEstantesInterior,pdv.TotalEstantesExterior
	 ,pdv.TieneVidriera, pdv.EspacioBacklight, p.nombre as provincia,l.nombre as localidad,c.nombre as cadenaMobile
	 ,t.nombre as tipo,cat.nombre as Categoria, dim.nombre as dimension, pot.Nombre 
	 ,isnull(cast(pdv.codigoSAP as varchar),'-') as CodigoCadena, 
	 isnull(cast(pdv.codigoAdicional as varchar),'-') as CodigoClienteMobile, ven.nombre as NombreVendedor,eq.nombre as Equipo,
	 cv.CuidadAsiento as GiroCiudadAsiento ,cv.PorfolioAveno as PorfolioAVENO, cv.PorfolioDLB as PorfolioDLB,
	 cv.PorfolioDLS as PorfolioDLS,cv.CantidadVisitas as VISITAS
	 --,isnull(pdvadic.nombre,'') as PROPIEDADADICIONAL
	 , STUFF((
       SELECT '- '+pdvadic.nombre + ' '
	   from propiedad_Puntodeventa pdvprop 
	   inner join Propiedad pdvadic 
	   on pdvadic.idPropiedad = pdvprop.idPropiedad
	   where pdvprop.idPuntodeventa = pdv.idPuntodeventa
       FOR XML PATH('')
		),1,2, '')
	from puntodeVenta pdv
	inner join PuntoDeVenta_Cliente_usuario pcu on pcu.idPuntoDeVenta = pdv.idPuntoDeVenta
	and pcu.idCliente = pdv.idCliente
	--inner join ETL_Andromaco_objetivoRTM rtm on rtm.idRTM = pcu.idUsuario
	inner join usuario usr on usr.idUsuario = pcu.idUsuario
	inner join localidad l on l.idLocalidad = pdv.idLocalidad
	inner join provincia p on p.idProvincia = l.idProvincia
	inner join cadena c on c.idCadena = pdv.idCadena
	inner join tipo t on t.idTipo = pdv.idTipo
	left join categoria cat on cat.idCategoria = pdv.idCategoria 
	left join Dimension dim on dim.idDimension = pdv.idDimension
	left join Potencial pot on pot.idPotencial = pdv.idPotencial
	left join puntoDeVenta_Vendedor pvv on pvv.idPuntoDeVenta = pdv.idPuntoDeVenta
	left join Vendedor ven on ven.idVendedor = pvv.idVendedor
	left join equipo eq on eq.idEquipo = ven.idEquipo
	and eq.idCliente = pdv.idCliente
	left join ETL_Andromaco_CantidadVisitas cv on cv.idPuntoDeVenta = pdv.idPuntoDeVenta 
	--left join propiedad_Puntodeventa pdvprop on pdvprop.idPuntodeventa = pdv.idPuntodeventa
	--left join Propiedad pdvadic on pdvadic.idPropiedad = pdvprop.idPropiedad		

		
	where pdv.idCliente = @idCliente
	and pcu.activo = 1
	and not exists ( select 1 from puntoDeVenta_cliente_usuario new 
					where new.idPuntoDeVenta = pcu.idPuntoDeVenta and new.idCliente = pcu.idCliente
					and new.idUsuario = pcu.idUsuario
					and new.idPuntoDeVenta_Cliente_usuario > pcu.idPuntoDeVenta_Cliente_usuario)
						and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario =usr.IdUsuario)) and usr.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=usr.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
			 in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
	order by 1 asc,3 asc

	

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


		insert #columnasConfiguracion (name, title, width) 
		values ('ClienteMobile','ClienteMobile',50),
			   ('IdPuntoDeVenta','IdPuntoDeVenta',50),
			   ('Nombre','Nombre',50),
			   ('Direccion','Direccion',50),
			   ('CUIT','CUIT',50),
			   ('Telefono','Telefono',50),
			   ('email','email',50),
			   ('totalgondolas','totalgondolas',50),
			   ('totalEstantesGondola','totalEstantesGondola',50),
			   ('TotalEstantesInterior','TotalEstantesInterior',50),
			   ('TotalEstantesExterior','TotalEstantesExterior',50),
			   ('TieneVidriera','TieneVidriera',50),
			   ('EspacioBacklight','EspacioBacklight',50),
			   ('Provincia','Provincia',50),
			   ('localidad','localidad',50),
			   ('CadenaMobile','CadenaMobile',50),
			   ('tipo','tipo',50),
			   ('Categoria','Categoria',50),
			   ('Dimension','Dimension',50),
			   ('Potencial','Potencial',50),
			   ('CodigoCadena','CodigoCadena',50),
			   ('CodigoClienteMobile','CodigoClienteMobile',50),
			   ('NombreVendedor','NombreVendedor',50),
			   ('Equipo','Equipo',50),
			   ('GiroCiudadAsiento','GiroCiudadAsiento',50),
			   ('PorfolioAVENO','PorfolioAVENO',50),
			   ('PorfolioDLB','PorfolioDLB',50),
			   ('PorfolioDLS','PorfolioDLS',50),
			   ('Visitas','Visitas',50),
			   ('PropiedadAdicional','Propiedades Adicionales',50)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select ClienteMobile,IdPuntoDeVenta,Nombre,Direccion,CUIT,Telefono,email,totalgondolas,totalEstantesGondola,TotalEstantesInterior,TotalEstantesExterior,TieneVidriera,EspacioBacklight,Provincia,
		localidad,CadenaMobile,tipo,Categoria,Dimension,Potencial,CodigoCadena,CodigoClienteMobile,NombreVendedor,Equipo,GiroCiudadAsiento,PorfolioAVENO,PorfolioDLB,PorfolioDLS,Visitas,PropiedadAdicional from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select ClienteMobile,IdPuntoDeVenta,Nombre,Direccion,CUIT,Telefono,email,totalgondolas,totalEstantesGondola,TotalEstantesInterior,TotalEstantesExterior,TieneVidriera,EspacioBacklight,Provincia,
		localidad,CadenaMobile,tipo,Categoria,Dimension,Potencial,CodigoCadena,CodigoClienteMobile,NombreVendedor,Equipo,GiroCiudadAsiento,PorfolioAVENO,PorfolioDLB,PorfolioDLS,Visitas,PropiedadAdicional from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select ClienteMobile,IdPuntoDeVenta,Nombre,Direccion,CUIT,Telefono,email,totalgondolas,totalEstantesGondola,TotalEstantesInterior,TotalEstantesExterior,TieneVidriera,EspacioBacklight,Provincia,
		localidad,CadenaMobile,tipo,Categoria,Dimension,Potencial,CodigoCadena,CodigoClienteMobile,NombreVendedor,Equipo,GiroCiudadAsiento,PorfolioAVENO,PorfolioDLB,PorfolioDLS,Visitas,PropiedadAdicional from #datosFinal
end


 
 
 
 
 
 
 
 
 
 
 
 
 
