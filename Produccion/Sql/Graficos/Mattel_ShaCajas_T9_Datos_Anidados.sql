IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_ShaCajas_T9_Datos_Anidados'))
   exec('CREATE PROCEDURE [dbo].[Mattel_ShaCajas_T9_Datos_Anidados] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Mattel_ShaCajas_T9_Datos_Anidados
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
	declare @idUsuario int
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

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idCadena int
	)

	create table #datos
	(
		id int identity(1,1),
		valor decimal(10,2),
		idempresa int,
		idcadena int,
		idPuntodeventa int,
		espropio bit
	)


	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte, idCadena)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), IdReporte, pdv.IdCadena
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and r.idUsuario = @idUsuario
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
	group by r.IdEmpresa, r.IdPuntoDeVenta, left(convert(varchar,r.fechacreacion,112),6), r.IdReporte, pdv.IdCadena

	insert #datos(idEmpresa, idcadena, idPuntodeventa, valor, espropio)
	select r.idempresa, r.idCadena, r.idPuntoDeVenta, sum(isnull(rp.precio,0)), 1
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.IdReporte=r.IdReporte
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where isnull(rp.precio,0)>0
	group by  r.IdEmpresa, r.idCadena, r.idPuntoDeVenta

	insert #datos (idEmpresa, idcadena, idPuntodeventa, valor, espropio)
	select m.idempresa, r.idCadena, r.idPuntoDeVenta, sum(isnull(rp.precio,0)), 0
	from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	isnull(rp.precio,0)>0
	group by  m.idempresa, r.idCadena, r.idPuntoDeVenta

	create table #totalporpdv
	(
		idpdv int,
		qty numeric(10,2)
	)
	insert #totalporpdv (idpdv, qty)
	select idPuntodeventa, sum(valor) from #datos group by idPuntodeventa

	create table #datosRes
	(
		id int identity(1,1),
		idcadena int,
		nested1 varchar (100),
		idpuntodeventa int,
		nested2 varchar (100),
		nested3 numeric(10,2),
		nested4 numeric(10,2)
	)
	
	create table #totalCajas
	(
		idpdv int,
		qty numeric(10,2)
	)

	insert #totalCajas
	select r.idPuntoDeVenta, sum(isnull(rp.Cantidad,0)) from ReportePop rp
	inner join #reportesMesPdv r on rp.idReporte = r.idReporte
	group by r.idPuntoDeVenta

	insert #datosRes(idcadena, nested1, idpuntodeventa, nested2, nested3, nested4)
	select d.idcadena, c.Nombre , d.idpuntodeventa, pdv.Nombre, sum(isnull(valor,0)), isnull(tc.qty,0) from #datos d
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = d.idPuntodeventa
	inner join Cadena c on c.IdCadena = d.idcadena
	left join #totalCajas tc on tc.idpdv = d.idpuntodeventa
	where d.espropio = 1
	group by d.idcadena, c.Nombre, d.idPuntodeventa, pdv.Nombre, tc.qty
	order by c.Nombre, pdv.Nombre

	update d1
	set d1.nested3=d1.nested3*100.0/d2.qty
	from #datosres d1, #totalporpdv d2
	where d1.idpuntodeventa=d2.idpdv

	
	create table #totalesCadena
	(
		cadena varchar(100),
		pdvtot varchar(50),
		valor numeric(10,2),
		valor2 numeric(10,2)
	)

	insert #totalesCadena
	select nested1+'-', 'Total', sum(isnull(nested3,0))/count(idcadena), sum(isnull(nested4,0)) from #datosRes group by nested1
	
	declare @maxpag int
	if(@TamañoPagina=0)
		set @maxpag=1
	else
		select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosRes
	select @maxpag

	--Configuracion de columnas
	create table #columnasConfiguracion
	(
		name varchar(50),
		title varchar(50),
		width int
	)
	

	if(@lenguaje = 'es')
		insert #columnasConfiguracion (name, title, width) values ('nested1','Cadena',5),('nested2','Nombre PDV',5),('nested3', '% SOS',5),('nested4', 'Cajas',10)

	if(@lenguaje = 'en')
		insert #columnasConfiguracion (name, title, width) values ('nested1','Retail',5),('nested2','POS',5),('nested3', '% SOS',5),('nested4', 'Boxes',10)

	select name, title, width from #columnasConfiguracion


	--Datos
	if(@NumeroDePagina>0)
		select nested1, nested2, nested3, nested4 from #datosRes where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
		union
		select * from #totalesCadena
		order by nested1

	if(@NumeroDePagina=0)
		select nested1, nested2, nested3, nested4 from #datosRes where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		union
		select * from #totalesCadena
		order by nested1

	if(@NumeroDePagina<0)
		select nested1, nested2, nested3, nested4 from #datosRes
		union
		select * from #totalesCadena
		order by nested1
	
end

