IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GardenPE_ApoyoCliente_T9'))
   exec('CREATE PROCEDURE [dbo].[GardenPE_ApoyoCliente_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[GardenPE_ApoyoCliente_T9]
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
		idMarca int
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

	insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''
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
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		fecha datetime,
		idReporte int
	)

	create table #datosFinal
	(
		id int identity(1,1),
		Usuario varchar(500),
		Fecha datetime,
		idReporte int,
		Modulo varchar(500),
		c1 varchar(500),
		c2 varchar(500),
		c3 varchar(500),
		c4 varchar(500),
		c5 varchar(500),
		c6 varchar(500),
		c7 varchar(500),
		c8 varchar(500),
		c9 varchar(500),
		c10 varchar(500),
	)

	-------------------------------------------------------------------- END (Temps) ----------------------------------------------------------------

	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, fecha, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,r.FechaCreacion
			,r.idReporte
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente = c.idcliente and cu.idusuario = r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	
	--APOYO AL CLIENTE 1

	create table #datosC1
	(
		idReporte int,
		Modulo varchar(500),
		idItem int,
		valor varchar(max)
	)
	
	insert #datosC1 (idReporte, Modulo, idItem, valor)
	select t.idReporte, mm.Nombre, rmi.idItem,
		case when rmi.idItem in (5926, 5933) and rmi.Valor1 = 1 then mi.LabelCampo1
		when rmi.idItem in (5926, 5933) and rmi.Valor2 = 1 then mi.LabelCampo2
		else rmi.Valor4 end
	from #tempReporte t
	inner join MD_ReporteModuloItem rmi on rmi.idReporte = t.idReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	inner join MD_Modulo mm on mm.idModulo = mi.idModulo
	where mi.idModulo = 1552 and (rmi.Valor1 > 0 or rmi.Valor2 > 0 or rmi.Valor4 != '')
	order by t.idReporte, mi.Orden



	insert #datosFinal (Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10)
	select u.Apellido+', '+u.Nombre collate database_default, t.Fecha, piv.* from
	(
		select idReporte, Modulo, idItem, valor from #datosC1
	) x
	pivot
	(
		max(valor)
		for idItem in (
		[5933],[5924],[5925],[5926],[5927],[5928],[5929],[5930],[5931],[5932])) piv
	inner join #tempReporte t on t.idReporte = piv.idReporte
	inner join Usuario u on u.idUsuario = t.idUsuario

			
	--APOYO AL CLIENTE 2

	create table #datosC2
	(
		idReporte int,
		Modulo varchar(500),
		idItem int,
		valor varchar(max)
	)
	
	insert #datosC2 (idReporte, Modulo, idItem, valor)
	select t.idReporte, mm.Nombre, rmi.idItem,
		case when rmi.idItem in (5934, 5937) and rmi.Valor1 = 1 then mi.LabelCampo1
		when rmi.idItem in (5934, 5937) and rmi.Valor2 = 1 then mi.LabelCampo2
		else rmi.Valor4 end
	from #tempReporte t
	inner join MD_ReporteModuloItem rmi on rmi.idReporte = t.idReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	inner join MD_Modulo mm on mm.idModulo = mi.idModulo
	where mi.idModulo = 1553 and (rmi.Valor1 > 0 or rmi.Valor2 > 0 or rmi.Valor4 != '')
	order by mi.Orden


	insert #datosFinal (Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10)
	select u.Apellido+', '+u.Nombre collate database_default, t.Fecha, piv.* from
	(
		select idReporte, Modulo, idItem, valor from #datosC2
	) x
	pivot
	(
		max(valor)
		for idItem in (
		[5934],[5935],[5936],[5937],[5938],[5939],[5940],[5941],[5942],[5943])) piv
	inner join #tempReporte t on t.idReporte = piv.idReporte
	inner join Usuario u on u.idUsuario = t.idUsuario


	--APOYO AL CLIENTE 3

	create table #datosC3
	(
		idReporte int,
		Modulo varchar(500),
		idItem int,
		valor varchar(max)
	)
	
	insert #datosC3 (idReporte, Modulo, idItem, valor)
	select t.idReporte, mm.Nombre, rmi.idItem,
		case when rmi.idItem in (5944, 5947) and rmi.Valor1 = 1 then mi.LabelCampo1
		when rmi.idItem in (5944, 5947) and rmi.Valor2 = 1 then mi.LabelCampo2
		else rmi.Valor4 end
	from #tempReporte t
	inner join MD_ReporteModuloItem rmi on rmi.idReporte = t.idReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	inner join MD_Modulo mm on mm.idModulo = mi.idModulo
	where mi.idModulo = 1554 and (rmi.Valor1 > 0 or rmi.Valor2 > 0 or rmi.Valor4 != '')
	order by mi.Orden


	insert #datosFinal (Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10)
	select u.Apellido+', '+u.Nombre collate database_default, t.Fecha, piv.* from
	(
		select idReporte, Modulo, idItem, valor from #datosC3
	) x
	pivot
	(
		max(valor)
		for idItem in (
		[5944],[5945],[5946],[5947],[5948],[5949],[5950],[5951],[5952],[5953])) piv
	inner join #tempReporte t on t.idReporte = piv.idReporte
	inner join Usuario u on u.idUsuario = t.idUsuario


	--APOYO AL CLIENTE 4

	create table #datosC4
	(
		idReporte int,
		Modulo varchar(500),
		idItem int,
		valor varchar(max)
	)
	
	insert #datosC4 (idReporte, Modulo, idItem, valor)
	select t.idReporte, mm.Nombre, rmi.idItem,
		case when rmi.idItem in (5954, 5957) and rmi.Valor1 = 1 then mi.LabelCampo1
		when rmi.idItem in (5954, 5957) and rmi.Valor2 = 1 then mi.LabelCampo2
		else rmi.Valor4 end
	from #tempReporte t
	inner join MD_ReporteModuloItem rmi on rmi.idReporte = t.idReporte
	inner join MD_Item mi on mi.idItem = rmi.idItem
	inner join MD_Modulo mm on mm.idModulo = mi.idModulo
	where mi.idModulo = 1555 and (rmi.Valor1 > 0 or rmi.Valor2 > 0 or rmi.Valor4 != '')
	order by mi.Orden


	insert #datosFinal (Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10)
	select u.Apellido+', '+u.Nombre collate database_default, t.Fecha, piv.* from
	(
		select idReporte, Modulo, idItem, valor from #datosC4
	) x
	pivot
	(
		max(valor)
		for idItem in (
		[5954],[5955],[5956],[5957],[5958],[5959],[5960],[5961],[5962],[5963])) piv
	inner join #tempReporte t on t.idReporte = piv.idReporte
	inner join Usuario u on u.idUsuario = t.idUsuario



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
		insert #columnasConfiguracion (name, title, width) values ('Usuario','Usuario',20),('Fecha','Fecha',50),('idReporte','idReporte',50),('Modulo','Modulo',50),('c1','TIPO',50),('c2','Paciente',50),('c3','Fecha Nac',50),('c4','Sexo',50),('c5','Distrito/Provincia',50),('c6','Telefono',50),('c7','Farmacia/Botica',50),('c8','Boleta/Comprobante',50),('c9','Cantidad',50),('c10','N° Muestras',50)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('Usuario','Usuario',20),('Fecha','Fecha',50),('idReporte','idReporte',50),('Modulo','Modulo',50),('c1','TIPO',50),('c2','Paciente',50),('c3','Fecha Nac',50),('c4','Sexo',50),('c5','Distrito/Provincia',50),('c6','Telefono',50),('c7','Farmacia/Botica',50),('c8','Boleta/Comprobante',50),('c9','Cantidad',50),('c10','N° Muestras',50)

	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10 from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10 from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select Usuario, Fecha, idReporte, Modulo, c1,c2,c3,c4,c5,c6,c7,c8,c9,c10 from #datosFinal
end

