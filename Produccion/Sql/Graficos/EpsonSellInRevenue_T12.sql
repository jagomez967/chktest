IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonSellInRevenue_T12'))
   exec('CREATE PROCEDURE [dbo].[EpsonSellInRevenue_T12] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].[EpsonSellInRevenue_T12]
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
		idPuntoDeVenta int,
		mes varchar(8),
		idReporte int,
		idCadena int
	)


	create table #diferencia
	(
		idProducto int,
		ventas int,
		objetivo int,
		idCadena int, --VIENE DE PUNTO DE VENTA
		idEmpresa int
	)

	create table #datos
	(
		id int identity(1,1),
		diferencia decimal(10,2),
		nombreCadena varchar(max),
		idCadena int,
		idEmpresa int,
		VolumenObjetivo int
	)


	-------------------------------------------------------------------- END (Temps)
	/*
	insert #reportesMesPdv (idEmpresa, idPuntoDeVenta, mes, idReporte,idCadena)
	select r.idempresa, r.idpuntodeventa, left(convert(varchar,r.fechacreacion,112),6), r.idreporte,p.idCadena
	from Reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=r.IdEmpresa
	where	c.IdCliente=@IdCliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
			*/
	
	insert #diferencia
	(
		idProducto,
		ventas,
		objetivo,
		idCadena, --VIENE DE PUNTO DE VENTA
		idEmpresa
	)
	/*select rp.idProducto,tvo.ventas,tvo.objetivo,r.idCadena,r.idEmpresa
	from #reportesMesPdv r
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join Epson_RetailerSellout tvo 
	on tvo.idReporte = r.idReporte and tvo.idProducto = rp.idProducto
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = rp.idProducto))*/
	
	select ru.idProducto, ru.ventas * isnull(y.precio,x.precio) ,ru.objetivo * isnull(y.Precio,x.precio),ru.idcadena,844 --EPSON ARG
	from epson_retailerUnidades ru
	inner join epson_retailerRevenue rs
	on rs.idCadena = ru.idCadena
	left join 
	(select rpp.idProducto, rpp.precio
	from reporteProducto rpp
	where rpp.idProducto in (select idProducto from producto where idmarca = 2254)
	and isnull(rpp.precio,0) <> 0
	and rpp.idReporte = ( select max(idReporte) from reporteProducto where idProducto = rpp.idProducto
						and isnull(rpp.precio,0)<>0) 
	--group by rpp.idProducto,rpp.precio
	)x 
	on x.idProducto = ru.idProducto
	left join epson_preciosProductos y
	on y.idProducto = ru.idProducto
	--EPSON ARG
	where (isnull(@cProductos,0) = 0 or exists(select 1 from #Productos where idProducto = ru.idProducto))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #Cadenas where idCadena = rs.idcadena))



	insert #datos (		diferencia,
						nombreCadena,
						idEmpresa,
						idCadena,
						VolumenObjetivo 
						)
	select (sum(dif.ventas)*100.0 )/ sum(dif.objetivo)*1.0,

		  cl.logo,
		   dif.idEmpresa,
		   dif.idCadena,
		   sum(dif.objetivo)
	from  #diferencia dif
	inner join cadenaLog cl on cl.idCadena = dif.idCadena
	group by cl.logo,dif.idEmpresa,dif.idCadena



	select d.id as id,  
	case when d.diferencia < 60
		then 'ea1e1e'
	when d.diferencia >= 60 and d.diferencia <80
		then 'ffff38'
	when d.diferencia >= 80 and d.diferencia <=100 
		then '68A568'
	when d.diferencia > 100
		then '5047f7'
	end
	as color, 
	d.nombreCadena as logo,
	 0 as nivel, 
	 d.diferencia as valor, 
	 cast(d.VolumenObjetivo as varchar) as varianza,
	 0 as parentId,
	 c.nombre as nombre,
	 d.idempresa as empresa
	from #datos d
	inner join Empresa e on e.IdEmpresa = d.idempresa
	inner join cadena c on c.idCadena= d.idCadena
	order by  d.id
end

--[EpsonSellInRevenue_T12] 181