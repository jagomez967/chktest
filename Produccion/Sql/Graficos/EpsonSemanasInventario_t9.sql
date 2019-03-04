IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonSemanasInventario_t9'))
   exec('CREATE PROCEDURE [dbo].[EpsonSemanasInventario_t9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[EpsonSemanasInventario_t9]
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
	create table #MarcaPropiedad
	(
		idMarcaPropiedad int
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
	declare @cMarcaPropiedad varchar(max)

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

	insert #MarcaPropiedad (IdMarcaPropiedad) select clave as idMarcaPropiedad from dbo.fnSplitString((select valores from @Filtros where IdFiltro = 'fltMarcaPropiedad'),',') where isnull(clave,'')<>''
	set @cMarcaPropiedad = @@ROWCOUNT
	
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
		IdPuntoDeVenta int,
		Fechacreacion datetime,
		idReporte int,
		idCadena int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		pais varchar(max),
		cadena varchar(max),
		producto varchar(max),
		SKU varchar(max),
		Descripcion varchar(max),
		Inventario int,
		SemanasInventario int
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------


	insert #datosFinal (pais,cadena,SKU,Descripcion,Inventario,SemanasInventario)
	select 'Argentina',
		   cad.nombre,
		   es.[SKU],
		   es.[Descripción],
		   case isnumeric(replace(es.[Existencia Total],' ',''))
				when 1 then cast(replace(es.[Existencia Total],' ','') as int)
				when 0 then null
				else null
		    end,
		   case isnumeric(replace(es.[Sem Inv],' ',''))
		   when 1 then cast(replace(es.[Sem Inv],' ','') as int)
		   when 0 then null
		   else null
		   end
	from epson_sellOut es
	join cadena cad on 1=1 
	where cad.idCadena = 4227
	--and (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = ru.idProducto))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #Cadenas where idCadena = cad.idcadena))


	
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
		insert #columnasConfiguracion (name, title, width)
		 values 
		 ('pais','Pais',5),
		 ('cadena','Retail',5),
		 ('SKU','SKU',10),
		 ('Descripcion','Descripcion',20),
		 ('Inventario','Inventario',5),
		 ('SemanasInventario','SemanasInventario',5)


	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width)
		values 
		 ('pais','Country',5),
		 ('cadena','Retail',5),
		 ('SKU','SKU',10),
		 ('Descripcion','Description',20),
		 ('Inventario','Inventory',5),
		 ('SemanasInventario','Weeks',5)

 
	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select 	pais,cadena,SKU,Descripcion,Inventario,
		case when SemanasInventario < 30 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario < 60
				then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario >= 60
				then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
			else ''
		end 	
		+ ' ' + cast(SemanasInventario as varchar)  as SemanasInventario
		from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select 	pais,cadena,SKU,Descripcion,Inventario,
		case when SemanasInventario < 30 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario < 60
				then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario >= 60
				then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
			else ''
		end 	 
		+ ' ' + cast(SemanasInventario as varchar)
		as SemanasInventario 
		from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select 	pais,cadena,SKU,Descripcion,Inventario,
		case when SemanasInventario < 30 then '<img src="images/circuloRojo.png" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario < 60
				then '<img src="images/circuloAmarillo.jpg" width="16" height="16"/>'
			when SemanasInventario >= 30 and semanasInventario >= 60
				then '<img src="images/circuloVerde.png" width="16" height="16"/>' 
			else ''
		end
		+ ' ' + cast(SemanasInventario as varchar) 	 
		as SemanasInventario
		from #datosFinal
end
