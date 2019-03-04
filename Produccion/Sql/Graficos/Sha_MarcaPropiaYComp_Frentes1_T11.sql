IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Sha_MarcaPropiaYComp_Frentes1_T11'))
   exec('CREATE PROCEDURE [dbo].[Sha_MarcaPropiaYComp_Frentes1_T11] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Sha_MarcaPropiaYComp_Frentes1_T11] 	
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
	
	create table #SubCategoria
	(
		idSubCategoria int
	)

	declare @cMarcas int = 0 
	declare @cProductos int = 0
	declare @cCadenas int = 0
	declare @cZonas int = 0
	declare @cLocalidades int = 0
	declare @cUsuarios int = 0
	declare @cPuntosDeVenta int = 0
	declare @cCompetenciaPrimaria int = 0
	declare @cVendedores int = 0
	declare @cTipoRtm int = 0
	declare @cProvincias int = 0
	declare @cTags int = 0
	declare @cFamilia int = 0

	declare @cTipoPDV varchar(max)
	declare @cSubCategoria int 

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
	
	insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
	set @cSubCategoria = @@ROWCOUNT

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
	

	insert #productos(idProducto)
	select distinct p.idProducto 
	from producto p 
	where
	    (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = P.IdMarca))
	AND (ISNULL(@cFamilia,0) = 0 OR EXISTS (SELECT 1 FROM #familia WHERE idFamilia = P.idFamilia))
	AND (ISNULL(@cProductos,0) = 0 OR EXISTS (SELECT 1 FROM #Productos WHERE idProducto = P.idProducto))
	and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
												inner join subCategoriaProducto scp 
													on sc.idSubCategoria = scp.idSubCategoria
												where scp.idProducto = p.IdProducto))

	
	set @cProductos = @cProductos + @cMarcas + @cFamilia + @cSubCategoria


	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #tempReporte
	(
		idEmpresa int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes varchar(8),
		idReporte int
	)

	create table #datos
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		qty numeric(18,5)
	)

	create table #marcaCompetencia
	(idMarca int)
	-------------------------------------------------------------------- END (Temp)

	declare @cCompetencia int

	insert #marcaCompetencia (idMarca)
	select ID_MARCACOMP from competenciaPrimariaAndromaco
	where [ID MARCA] in(select idMarca from #competenciaPrimaria)
	set @cCompetencia = @@ROWCOUNT

	insert #marcas(idMarca)
	select [ID MARCA] from competenciaPrimariaAndromaco
	where [ID MARCA] in(select idMarca from #competenciaPrimaria)
	set @cMarcas = @cMarcas + @@ROWCOUNT

	insert #tempReporte (idEmpresa, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.idEmpresa
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(varchar, dateadd(day, -(day(r.FechaCreacion) - 1), FechaCreacion),112) as mes
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join Localidad l on l.idLocalidad = pdv.idLocalidad
	where	c.idCliente = @idcliente
			and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor
				in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))
		group by c.idEmpresa, r.IdUsuario, r.IdPuntoDeVenta, convert(varchar, dateadd(day, -(day(FechaCreacion) - 1), FechaCreacion),112)


	insert #datos (idEmpresa, idMarca, idProducto, qty)
	select r.idEmpresa, m.idMarca, rp.idProducto, SUM(isnull(rp.Cantidad,0))
	from #tempReporte r
	inner join ReporteProducto rp on rp.IdReporte = r.IdReporte
	inner join Producto p on p.IdProducto = rp.IdProducto
	inner join Marca m on m.IdMarca = p.IdMarca
    where   (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))

	group by r.idEmpresa, m.idMarca, rp.idProducto

	--select * from #datos
	insert #datos (idEmpresa, idMarca, idProducto, qty)
	select r.idEmpresa, m.idMarca, rp.idProducto, SUM(isnull(rp.Cantidad,0))
	from #tempReporte r
	inner join ReporteProductoCompetencia rp on rp.IdReporte=r.IdReporte
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Marca m on m.IdMarca=p.IdMarca
	left join ProductoCompetencia pc on pc.idproductocompetencia = p.idproducto
	left join producto propio on propio.idproducto = pc.idproducto
	where (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = propio.idmarca))
			and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = propio.IdProducto))
			and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = propio.idFamilia))
	and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
												inner join subCategoriaProducto scp 
													on sc.idSubCategoria = scp.idSubCategoria
												where scp.idProducto = pc.IdProducto))
			
	group by r.idEmpresa, m.idMarca, rp.idProducto

	create table #Resultados
	(
		idEmpresa int,
		idMarca int,
		idProducto int,
		qty numeric(18,5)
	)

	insert #Resultados (idEmpresa, idMarca, qty)
	select te.idEmpresa, te.idMarca, SUM(isnull(te.qty,0))
	from #datos te
	group by te.idEmpresa, te.idMarca

	delete from #Resultados where idEmpresa in (select idEmpresa from #Resultados group by idEmpresa having sum(qty)=0)
	delete from #Resultados where idMarca in (select idMarca from #Resultados group by idMarca having sum(qty)=0)

	declare @total numeric(18,5)
	select @total = SUM(isnull(qty,0)) from #Resultados


	select r.idmarca, LTRIM(rtrim(m.nombre)) as Marca, cast(isnull(r.qty,0)*100.0/@total as numeric(18,1)) as Share,m.scolor
	from #Resultados r
	inner join Marca m on m.idmarca=r.idMarca
	order by m.nombre
	
	
	
	create table #ProductosMeses
	(
		idEmpresa int,
		idMarca int,
		idProducto int
	)

	insert #ProductosMeses (idEmpresa, idmarca, idProducto)
	select distinct tmp.idEmpresa, tmp.idMarca, tmp.idProducto from #datos tmp

	insert #Resultados (idEmpresa, idMarca, idProducto, qty)
	select te.idEmpresa, te.idmarca, te.idProducto, SUM(isnull(d.qty,0))
	from #ProductosMeses te
	left join #datos d on d.idEmpresa=te.idEmpresa and d.idMarca=te.idMarca and d.idProducto=te.idProducto
	group by te.idEmpresa, te.idmarca, te.idProducto

	delete from #Resultados where idEmpresa in (select idEmpresa from #Resultados group by idEmpresa having sum(qty)=0)
	delete from #Resultados where idMarca in (select idMarca from #Resultados group by idMarca having sum(qty)=0)
	delete from #Resultados where idProducto in (select idProducto from #Resultados group by idProducto having sum(qty)=0)


		select r.idmarca, LTRIM(rtrim(m.nombre)), r.idProducto, ltrim(rtrim(p.Nombre)), isnull(r.qty,0)
	from #Resultados r
	inner join Marca m on m.idmarca=r.idMarca
	inner join Producto p on p.idProducto = r.idProducto
	order by m.nombre
	
end

GO


/*
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p2 values(N'fltSubCategoria',N'1000')
exec Sha_MarcaPropiaYComp_Frentes1_T11 @IdCliente=235,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

declare @p3 dbo.FiltrosReporting
insert into @p3 values(N'fltFechaReporte',N'M,20190101,20190228')
insert into @p3 values(N'fltSubCategoria',N'1001')
exec Sha_MarcaPropiaYComp_Frentes1_T11 @IdCliente=235,@Filtros=@p3,@NumeroDePagina=-1,@Lenguaje='es'
*/