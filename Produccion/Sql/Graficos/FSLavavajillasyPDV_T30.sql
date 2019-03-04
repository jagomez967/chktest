IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.FSLavavajillasyPDV_T30'))
   exec('CREATE PROCEDURE [dbo].[FSLavavajillasyPDV_T30] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[FSLavavajillasyPDV_T30]
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
	DECLARE @MaxPag		INT

	DECLARE @Query			NVARCHAR(MAX)
	DECLARE @pops			VARCHAR(MAX)
	DECLARE @SelectPops		VARCHAR(MAX)

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

	INSERT INTO #marcasEpson (idmarcaEpson) SELECT clave AS idmarcaEpson FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltMarcasEpson'),',') WHERE ISNULL(clave,'')<>''
	SET @cMarcasEpson = @@ROWCOUNT

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

	create table #Meses
	(
		mes varchar(8)
	)

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------
	
	select
			r.idPuntodeventa,
			p.nombre as Pdv,
			convert(varchar,r.FechaCreacion,103) as mes		
			,r.idReporte
			,p.Direccion
			,z.Nombre
			,ca.Nombre as cadena
			,u.Usuario
			into #tempreporte
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join ReporteProducto rp on rp.IdReporte = r.IdReporte
	inner join zona z on z.IdZona = p.IdZona
	inner join cadena ca on ca.idcadena = p.IdCadena
	inner join usuario u on u.IdUsuario = r.IdUsuario
	where	
	not exists (select 1 from Reporte x where x.IdReporte > r.IdReporte and x.IdUsuario = r.IdUsuario and x.IdPuntoDeVenta = r.IdPuntoDeVenta) and
	convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
			and c.idCliente = @idcliente
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	--group by  r.idPuntodeventa,convert(varchar,r.FechaCreacion,103),p.Direccion,z.Nombre,ca.Nombre,u.Usuario,p.Nombre
	


select 
	t.IdPuntoDeVenta
	,t.pdv
	,t.mes
	,t.idreporte
	,t.Direccion
	,t.Nombre
	,t.cadena
	,t.usuario
	,m.idmarca
	,m.nombre as marca
	,(sum(isnull(rp.cantidad,0)) + sum(isnull(rp.cantidad2,0))) as frente
	into #tempfrentes 
				from #tempreporte t
				inner join ReporteProducto rp on rp.IdReporte = t.IdReporte
				inner join Producto p on p.IdProducto = rp.IdProducto
				inner join Marca m on m.IdMarca = p.IdMarca
				where m.idmarca = 2467

 
	group by t.IdPuntoDeVenta,t.mes,t.idreporte,t.Direccion,t.Nombre,t.cadena,t.usuario,m.nombre,m.IdMarca,t.pdv


	
		
select
	  rp.idreporte,
	  m.idempresa,
	  m.IdMarca,
	  M.Nombre AS NombreMarca,
	  p.Nombre as NombrePop,
	  p.idpop,
	  t.mes,
	  rp.cantidad as pop
	into #temppop
	from #tempreporte t
	inner join ReportePop rp on rp.idReporte = t.idReporte
	inner join pop p on p.idPOP = rp.idPOP
	inner join Marca m on m.IdMarca=rp.IdMarca
	where m.IdMarca = 2467
	group by m.idempresa, m.IdMarca, p.idpop, t.mes,rp.idreporte,rp.cantidad,m.Nombre,p.Nombre


-------------------------------------------------------------------------------------------------------------------------------------------------------------
			
			select idreporte,930 idEmpresa,mes
			into #temp1 
			from #tempreporte 
			where idReporte NOT IN (SELECT idReporte FROM ReportePop WHERE idMarca = 2467) 
			
		    SELECT pm.idmarca,m.nombre as NombreMarca,POP.Nombre NombrePop ,pm.idpop,0 pop
			into #temp2 
			FROM Pop_Marca PM INNER JOIN Pop POP ON PM.idPop = POP.idPop
			inner join marca m on m.IdMarca = pm.IdMarca
			WHERE pm.idMarca = 2467 and pop.Activo = 1

			insert into #temppop 
			select idReporte,idEmpresa,idMarca,NombreMarca,NombrePop,idpop,mes,pop from #temp1,#temp2

-------------------------------------------------------------------------------------------------------------------------------------------------------------		

	select distinct
		a.idreporte,
		a.mes,
		a.IdPuntoDeVenta,
		a.pdv,
		a.direccion,
		a.Nombre as zona,
		a.Usuario,
		a.cadena,
		a.marca,
		sum(a.frente) as whirlpool,
		isnull(b.NombrePop,'SIN POP') as nombrepop,
		isnull(sum(b.pop),0) as pop
		INTO #TEMPFINAL
	from #tempfrentes a
	left join #temppop b on a.idreporte = b.IdReporte and a.mes = b.mes 
	group by a.idreporte,a.mes,a.IdPuntoDeVenta,a.pdv,a.direccion,a.Nombre,a.Usuario,a.cadena,a.marca,b.NombrePop

	
	SET @Query = 
	'
	SELECT
		idReporte,mes,idPuntoDeVenta,pdv,direccion,zona,Usuario,cadena,marca,whirlpool,
		{SelectPops}
	FROM 
		(SELECT DISTINCT idReporte,mes,idPuntoDeVenta,pdv,direccion,zona,Usuario,cadena,marca,whirlpool,NombrePop,pop FROM #TEMPFINAL) A
	PIVOT 
		(MIN(pop) 
	FOR 
		NombrePop
	IN (
		{Pops}
		)) AS Piv
	'
	
	SELECT DISTINCT  
		NombrePop
	INTO 
		#SelectPops
	FROM 
		#temppop 
			
	
	SELECT 
		@SelectPops = COALESCE(@SelectPops + ',', '') + 'isnull(['+NombrePop+'],0) ' + '''' + NombrePop + ''''
	FROM 
		#SelectPops
	SET @Query = REPLACE(@Query,'{SelectPops}',@SelectPops)

	
	SELECT 
		@pops = COALESCE(@pops + ',', '') + '['+NombrePop+'] '
	FROM 
		#SelectPops
	SET @Query = REPLACE(@Query,'{Pops}',@pops)

	 	EXEC sp_executesql @Query 
	

		
END
GO

/*

declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20190101,20190131')
--insert into @p2 values(N'fltpuntosdeventa',N'187189')
---insert into @p2 values(N'fltusuarios',N'3915')
--insert into @p2 values(N'fltMarcas',N'648')
exec FSLavavajillasyPDV_T30 @IdCliente=187,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'

*/
