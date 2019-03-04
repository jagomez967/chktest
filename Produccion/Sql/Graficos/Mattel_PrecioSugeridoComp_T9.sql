IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Mattel_PrecioSugeridoComp_T9'))
   exec('CREATE PROCEDURE [dbo].[Mattel_PrecioSugeridoComp_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].Mattel_PrecioSugeridoComp_T9
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


	set @difDias = DATEDIFF(DAY, @fechaDesde, @fechaHasta)
	set @strFDesdePeriodoAnterior = CONVERT(varchar,dateadd(day,-@difDias-1,@fechaDesde),112)
	set @strFHastaPeriodoAnterior = convert(varchar,dateadd(day,-@difDias-1,@fechaHasta),112)

	-------------------------------------------------------------------- END (Filtros)

	create table #reportesMesPdv
	(
		idEmpresa int,
		idCadena int,
		mes varchar(8),
		idReporte int
	)

		create table #reportesMesPdvPeriodoAnterior
	(
		idEmpresa int,
		idCadena int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		id int identity(1,1),
		idempresa int,
		idcadena int,
		idproducto int,
		precio decimal (9,2)
	)

	create table #datosPeriodoAnterior
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int
	)

	create table #datosResultados
	(
		id int identity(1,1),
		color varchar(6),
		logo varchar(max),
		parentId int,
		valor decimal(10,2),
		varianza decimal(10,2),
		nivel int,
		idempresa int
	)
	-------------------------------------------------------------------- END (Temps)

	insert #reportesMesPdv (idEmpresa, idCadena, mes, idReporte)
	select r.idempresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6), max(r.IdReporte)
	from Reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and pdv.IdTipo is not null
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
				and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias pro where pro.idProvincia in(select idProvincia from localidad loc where loc.idLocalidad = pdv.idLocalidad)))
		group by r.IdEmpresa, pdv.IdCadena, left(convert(varchar,r.fechacreacion,112),6)

	create table #sugerido
	(
		idProducto int,
		idProductoCompetencia int,
		Precio decimal(9,3),
		SKU varchar(15)
	)

		begin tran
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (199,251,4990,'DMM06')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (198,260,4990,'T7439')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (198,252,4990,'T7439')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (198,253,4990,'T7439')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (201,253,6990,'T7580')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (201,301,6990,'T7580')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (200,252,5990,'T7584')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (268,274,3990,'DHD57')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (270,275,2990,'Y8621')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (241,276,9990,'CDM61')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (241,277,9990,'CDM61')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (241,302,9990,'CDM61')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (272,278,9990,'DRT61')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (205,251,8990,'DLB34')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (205,254,8990,'DLB34')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (204,251,5990,'DTK49')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (204,254,5990,'DTK49')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (217,279,5990,'K7167')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (232,280,5490,'1806')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (230,282,1090,'C4982')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (230,311,1090,'C4982')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (231,281,3290,'K5904')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (231,312,3290,'K5904')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (273,283,3990,'DPF00')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (273,313,3990,'DPF00')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (215,284,8990,'W3618')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (214,259,14990,'BLW15')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (213,258,11990,'CBL61')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (267,285,11990,'DJB12')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (240,286,9990,'DJG08')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (240,305,9990,'DJG08')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (239,287,5990,'Y5572')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (239,306,5990,'Y5572')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (238,288,7990,'Y5573')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (225,262,9990,'CNH09')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (225,307,9990,'CNH09')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (226,264,21990,'DCH63 / DCH62')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (226,308,21990,'DCH63 / DCH62')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (227,263,14990,'DKX58')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (228,265,23990,'DKX60')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (271,266,14990,'DMX50')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (206,253,8990,'DKY17')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (203,260,5990,'DNV65')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (209,256,3990,'CBW79')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (209,290,3990,'CBW79')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (209,314,3990,'CBW79')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (210,289,3990,'CFP20')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (211,257,6990,'CFY28')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (210,300,3990,'CFP20')
			insert #sugerido (idProducto, idProductoCompetencia, Precio, SKU) values (208,255,1990,'K7704')

		commit tran

	insert #datos (idempresa, idcadena, idproducto, precio)
	select e.idEmpresa, r.idCadena, rp.IdProducto, isnull(rp.Precio,0) from #reportesMesPdv r
	inner join ReporteProductoCompetencia rp on rp.IdReporte = r.idReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
	inner join Empresa e on e.IdEmpresa = m.IdEmpresa
	where isnull(rp.Precio,0)>0


	create table #datosRes
	(
		id int identity(1,1),
		idcadena varchar (8),
		cadena varchar (100),
		idpropio int,
		idproducto int,
		producto varchar (100),
		sugerido decimal (10,2),
		precio decimal (10,2),
		valor varchar (max)
	)

	insert #datosRes (idcadena, cadena, idpropio, idproducto, producto, sugerido, precio, valor)
	select 'col'+cast(d.idcadena as varchar(8)), ltrim(rtrim(c.Nombre)), s.idProducto, d.idproducto, ltrim(rtrim(p.nombre)), s.Precio, d.precio, cast(d.precio as varchar) + ' (' + LEFT(cast((d.precio*100.0/s.Precio)-100.0 as varchar),5) + '%)' from #datos d
	inner join #sugerido s on d.idproducto = s.idProductoCompetencia
	inner join Cadena c on c.IdCadena = d.idcadena
	inner join Producto p on p.IdProducto = d.idproducto
	

	create table #Resultados
	(
		id int identity(1,1),
		Marca varchar(100),
		ProdPropio varchar(100),
		SKU varchar(15),
		sugerido decimal(10,2),
		Empresa varchar(100),
		MarcaComp varchar(100),
		ProdComp varchar(100),
		cadena1 varchar(20),
		cadena2 varchar(20),
		cadena3 varchar(20),
		cadena4 varchar(20),
		cadena5 varchar(20)
	)


	insert #Resultados (Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5)
		Select ltrim(rtrim(m.nombre)),ltrim(rtrim(p2.nombre)), ltrim(rtrim(s.SKU)), sugerido, ltrim(rtrim(e.nombre)), ltrim(rtrim(m2.nombre)), ltrim(rtrim(p.nombre)),
			Min(Case idcadena When 'col280' Then valor End) PARIS,
			Min(Case idcadena When 'col281' Then valor End) FALABELLA,
			Min(Case idcadena When 'col282' Then valor End) RIPLEY,
			Min(Case idcadena When 'col291' Then valor End) JUMBO,
			Min(Case idcadena When 'col317' Then valor End) WALMART
		From #datosRes dr
		inner join Producto p on dr.idproducto = p.IdProducto
		inner join Producto p2 on dr.idpropio = p2.IdProducto
		inner join Marca m on m.IdMarca = p2.IdMarca
		inner join #sugerido s on s.idProducto = p2.IdProducto
		inner join Marca m2 on m2.IdMarca = p.IdMarca
		inner join Empresa e on e.IdEmpresa = m2.IdEmpresa
		Group By m.Nombre, p2.Nombre, s.SKU, sugerido, e.Nombre, m2.Nombre, p.Nombre, dr.precio


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
	insert #columnasConfiguracion (name, title, width) values
	('Marca','Marca',40),
	('ProdPropio','NomProducto',80),
	('SKU', 'SKU',30),
	('sugerido', 'Sugerido',30),
	('Empresa', 'Fabricante',30),
	('MarcaComp', 'MarcaComp',50),
	('ProdComp', 'NomProdComp',80),
	('cadena1', 'PARIS',50),
	('cadena2', 'FALABELLA',50),
	('cadena3', 'RIPLEY',50),
	('cadena4', 'JUMBO',50),
	('cadena5', 'WALMART',50)
	select name, title, width from #columnasConfiguracion

	--Datos
	if(@NumeroDePagina>0)
		select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5 from #Resultados where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
	
	if(@NumeroDePagina=0)
		select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5 from #Resultados where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)
		
	if(@NumeroDePagina<0)
		select Marca, ProdPropio,SKU,sugerido,Empresa,MarcaComp,ProdComp,cadena1,cadena2,cadena3,cadena4,cadena5 from #Resultados

end