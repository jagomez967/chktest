IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Whirpool_Display_MD_Capacitacion_T30'))
   exec('CREATE PROCEDURE [dbo].[Whirpool_Display_MD_Capacitacion_T30] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[Whirpool_Display_MD_Capacitacion_T30]
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

	SET LANGUAGE SPANISH
	SET NOCOUNT ON

	IF @lenguaje = 'es' BEGIN SET LANGUAGE spanish END
	IF @lenguaje = 'en' BEGIN SET LANGUAGE english END

	DECLARE @fechaDesde DATE
	DECLARE @fechaHasta DATE

	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)
	
	CREATE TABLE #Marcas
	(
		idMarca INT
	)

	CREATE TABLE #Productos
	(
		idProducto INT
	)

	CREATE TABLE #Familia
	(
		idFamilia int
	)

	CREATE TABLE #marcasEpson
	(
		idMarcaEpson int
	)

	CREATE TABLE #TipoCadena
	(
		idTipoCadena INT
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

		create table #puntosdeventa
	(
		idPuntoDeVenta int
	)

	create table #usuarios
	(
		idUsuario int
	)

	create table #TipoPDV
	(
		idTipo int
	)
	

	create table #Categorias
	(
		idCategoria int
	)

	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT
	DECLARE @cFamilia				INT
	DECLARE @cMarcasEpson			INT
	DECLARE @cTipoCadena			INT
	DECLARE @cCadenas				INT
	declare @cZonas				    INT
	declare @cLocalidades		    INT
	declare @cVendedores			INT
	declare @cTipoRtm				INT
	declare @cProvincias			INT
	declare @cTipoPDV				INT		
	declare @cUsuarios				INT		
	declare @cCategorias			INT
	declare @cPuntosDeVenta			INT

	INSERT INTO #fechaCreacionReporte (fecha) 
	SELECT 
		CONVERT(DATE,clave) AS fecha 
	FROM 
		dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFechaReporte'),',') 
	WHERE 
		ISNULL(clave,'') <> ''
		AND ISDATE(clave) <> 0

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT
		
	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT


	INSERT INTO #Familia (IdFamilia) SELECT clave AS idFamilia FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFamilia'),',') WHERE ISNULL(clave,'')<>''
	SET @cFamilia = @@ROWCOUNT

	INSERT INTO #TipoCadena (idTipoCadena) SELECT clave AS idTipoCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoCadena'),',') WHERE ISNULL(clave,'') <> ''
	SET @cTipoCadena = @@ROWCOUNT

	INSERT INTO #cadenas (idCadena) SELECT clave AS idCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCadenas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cCadenas = @@ROWCOUNT

	insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''
	set @cZonas = @@ROWCOUNT

	insert #localidades (idLocalidad) select clave as idLocalidad from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltLocalidades'),',') where isnull(clave,'')<>''
	set @cLocalidades = @@ROWCOUNT

	insert #vendedores (idVendedor) select clave as idVendedor from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltVendedores'),',') where isnull(clave,'')<>''
	set @cVendedores = @@ROWCOUNT

	insert #tipoRtm (idTipoRtm) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoDeRTM'),',') where isnull(clave,'')<>''
	set @cTipoRtm = @@ROWCOUNT

	insert #Provincias (idProvincia) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProvincias'),',') where isnull(clave,'')<>''
	set @cProvincias = @@ROWCOUNT

	insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''
	set @cUsuarios = @@ROWCOUNT

	insert #puntosdeventa (idPuntoDeVenta) select clave as idPuntoDeVenta from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPuntosDeVenta'),',') where isnull(clave,'')<>''
	set @cPuntosDeVenta = @@ROWCOUNT

	insert #tipoRtm (idTipoRtm) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoDeRTM'),',') where isnull(clave,'')<>''
	set @cTipoRtm = @@ROWCOUNT

	insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''
	set @cTipoPDV = @@ROWCOUNT
	IF (ISNULL((SELECT fecha FROM #fechaCreacionReporte WHERE id = 1),'00010101') = '00010101' ) BEGIN
		SET @fechaDesde = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
	END
	ELSE BEGIN
		SELECT @fechaDesde = fecha FROM #fechaCreacionReporte WHERE id = 1
	END
    
	IF (ISNULL((SELECT fecha FROM #fechaCreacionReporte WHERE id = 2),'00010101') = '00010101' ) BEGIN
		SET @fechaHasta = GETDATE()
	END
	ELSE BEGIN
		SELECT @fechaHasta =  fecha FROM #fechaCreacionReporte WHERE id = 2
	END
	
	
	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	select 
	max(r.idReporte) as [Reporte],
	Convert(varchar(10),CONVERT(date,r.FechaCreacion,106),103) as [Fecha],
	pdv.nombre as [Punto de venta], 
	u.apellido +', '+ u.nombre collate database_default as [Usuario],
	pdv.direccion as [Dirección], 
	z.nombre as [Zona] , 
	case when rc.Capacitacion = 1 then 'Si'
		 when rc.Capacitacion = 0 then 'No'
		 else ''
	end as [Mueble]
	from reporte r 
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPUntodeventa 
	inner join zona z on z.idZona = pdv.idZona
	inner join usuario u on u.idUsuario = r.idUsuario
	inner join cliente c on c.IdEmpresa = r.IdEmpresa 
	inner join ReporteCapacitacion rc on rc.IdReporte = r.IdReporte	
	where c.idCliente = @idCliente 
		    and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)		
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))
			and (isnull(@cCategorias,0) = 0 or exists(select 1 from #Categorias where idCategoria = pdv.idCategoria))
	group by Convert(varchar(10),CONVERT(date,r.FechaCreacion,106),103),pdv.nombre,u.apellido,u.nombre,pdv.direccion,
	z.nombre,rc.Capacitacion,rc.Fecha
	order by rc.Fecha desc

END
go
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181101,20181118')
--insert into @p2 values(N'fltpuntosdeventa',N'94017')
---insert into @p2 values(N'fltusuarios',N'2710')
---insert into @p2 values(N'fltProductos',N'12656')

exec Whirpool_Display_MD_Capacitacion_T30 @IdCliente=209,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

