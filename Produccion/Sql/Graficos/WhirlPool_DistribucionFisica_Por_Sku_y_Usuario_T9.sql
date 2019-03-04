IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.WhirlPool_DistribucionFisica_Por_Sku_y_Usuario_T9'))
   exec('CREATE PROCEDURE [dbo].[WhirlPool_DistribucionFisica_Por_Sku_y_Usuario_T9] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[WhirlPool_DistribucionFisica_Por_Sku_y_Usuario_T9]
(
	@IdCliente			INT
	,@Filtros			FiltrosReporting READONLY
	,@NumeroDePagina	INT = -1
	,@Lenguaje			VARCHAR(10) = 'es'
	,@IdUsuarioConsulta INT = 0
	,@TamañoPagina		INT = 0
)
AS
BEGIN
	/*
	Para filtrar en un query hacer:
	===============================
	*	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	*	(isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
*/		

	SET LANGUAGE spanish
	SET NOCOUNT ON

	IF @lenguaje = 'es' BEGIN SET LANGUAGE spanish END
	IF @lenguaje = 'en' BEGIN SET LANGUAGE english END

	DECLARE @fechaDesde DATE
	DECLARE @fechaHasta DATE

	DECLARE @ProductosColumns	NVARCHAR(MAX)
	DECLARE @SelectFechas	NVARCHAR(MAX)        
	DECLARE @Query				NVARCHAR(MAX)
	
	CREATE TABLE #fechaCreacionReporte
	(
		id INT IDENTITY(1,1),
		fecha	DATE
	)

	CREATE TABLE #cadenas
	(
		idCadena INT
	)

	CREATE TABLE #zonas
	(
		idZona INT
	)

	CREATE TABLE #localidades
	(
		idLocalidad INT
	)

	CREATE TABLE #usuarios
	(
		idUsuario INT
	)

	CREATE TABLE #puntosdeventa
	(
		idPuntoDeVenta INT
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
		idFamilia INT
	)

	CREATE TABLE #Categoria
	(
		idCategoria INT
	)

	CREATE TABLE #TipoPDV
	(
		idTipo INT
	)

	DECLARE @cCadenas				INT
	DECLARE @cZonas					INT
	DECLARE @cLocalidades			INT
	DECLARE @cUsuarios				INT
	DECLARE @cPuntosDeVenta			INT
	DECLARE @cMarcas				INT
	DECLARE @cProductos				INT
	DECLARE @cFamilia				INT
	DECLARE @cCategoria				INT
	DECLARE @cTipoPDV				INT


	INSERT #fechaCreacionReporte (fecha) 
	SELECT 
		CONVERT(DATE,clave) AS fecha 
	FROM 
		dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFechaReporte'),',') 
	WHERE 
		ISNULL(clave,'') <> ''
		AND ISDATE(clave) <> 0

	INSERT INTO #cadenas (idCadena) SELECT clave AS idCadena FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCadenas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cCadenas = @@ROWCOUNT

	INSERT INTO #zonas (idZona) SELECT clave AS idZona FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltZonas'),',') WHERE ISNULL(clave,'') <> ''
	SET @cZonas = @@ROWCOUNT

	INSERT INTO #localidades (idLocalidad) SELECT clave AS idLocalidad FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltLocalidades'),',') WHERE ISNULL(clave,'') <> ''
	SET @cLocalidades = @@ROWCOUNT

	INSERT INTO #usuarios (idUsuario) SELECT clave AS idUsuario FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltUsuarios'),',') WHERE ISNULL(clave,'') <> ''
	SET @cUsuarios = @@ROWCOUNT

	INSERT INTO #puntosdeventa (idPuntoDeVenta) SELECT clave AS idPuntoDeVenta FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltPuntosDeVenta'),',') WHERE ISNULL(clave,'') <> ''
	SET @cPuntosDeVenta = @@ROWCOUNT

	INSERT INTO #Marcas (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''
	SET @cMarcas = @@ROWCOUNT

	INSERT INTO #Productos (idproducto) SELECT clave AS idproducto FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltProductos'),',') WHERE ISNULL(clave,'')<>''
	SET @cProductos = @@ROWCOUNT

	INSERT INTO #Familia (IdFamilia) SELECT clave AS idFamilia FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltFamilia'),',') WHERE ISNULL(clave,'')<>''
	SET @cFamilia = @@ROWCOUNT

	INSERT INTO #Categoria (IdCategoria) SELECT clave AS Categoria FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCategoria'),',') WHERE ISNULL(clave,'')<>''
	SET @cCategoria = @@ROWCOUNT

	INSERT INTO #TipoPDV (IdTipo) SELECT clave AS idTipo FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltTipoPDV'),',') WHERE ISNULL(clave,'')<>''
	SET @cTipoPDV = @@ROWCOUNT

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

	;WITH A AS
	(
		SELECT	
			PCU.idPuntoDeVenta,
			MAX(PCU.IdPuntoDeVenta_Cliente_Usuario) Id
		FROM 
			PuntoDeVenta_Cliente_Usuario PCU
			INNER JOIN PuntoDeVenta PDV ON PCU.idPuntoDeVenta = PDV.idPuntoDeVenta
		WHERE 
			CONVERT(DATE, Fecha) <= @FechaHasta
			AND PCU.idCliente = @idCliente
			AND (ISNULL(@cCadenas,0) = 0 OR EXISTS(SELECT 1 FROM #cadenas WHERE idCadena = pdv.IdCadena))
			AND (ISNULL(@cZonas,0) = 0 OR EXISTS(SELECT 1 FROM #zonas WHERE idZona = pdv.IdZona))
			AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS(SELECT 1 FROM #localidades WHERE idLocalidad = pdv.IdLocalidad))
			AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS(SELECT 1 FROM #usuarios where idUsuario = pcu.IdUsuario)) AND pcu.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
			AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS(SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = pdv.IdPuntoDeVenta))
			AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = pdv.idCategoria))
			AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
		GROUP BY 
			PCU.idUsuario, 
			PCU.idPuntoDeVenta
	) SELECT DISTINCT
		DATEPART(MONTH,R.FechaCreacion) Id,
		A.idPuntoDeVenta,
		LEFT(DATENAME(MONTH,FechaCreacion),3) + '-' + RIGHT(DATENAME(YEAR,FechaCreacion),2) Fecha,
		RP.idProducto,
		CASE WHEN SUM(ISNULL(RP.Cantidad,0) + ISNULL(RP.Cantidad2,0)) != 0 THEN 1 ELSE 0 END TieneFrente,
		U.idUsuario Idusuario 
	INTO 
		#TmpDistrPdv
	FROM 
		A 
		LEFT JOIN Reporte R ON A.idPuntoDeVenta = R.idPuntoDeVenta
		LEFT JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		LEFT JOIN PuntoDeVenta PDV ON A.idPuntoDeVenta = PDV.idPuntoDeVenta
		LEFT JOIN Usuario U ON U.idUsuario = R.Idusuario
	WHERE 
		(SELECT COUNT(1) FROM PuntoDeVenta_Cliente_Usuario PCU2 WHERE PCU2.IdPuntoDeVenta_Cliente_Usuario=A.Id and PCU2.Activo=0) = 0
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde
		AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
		and RP.idProducto >0 
	GROUP BY
		A.idPuntoDeVenta,
		RP.idProducto,
		LEFT(DATENAME(MONTH,FechaCreacion),3) + '-' + RIGHT(DATENAME(YEAR,FechaCreacion),2),
		DATEPART(MONTH,R.FechaCreacion),
        U.idUsuario 		
	ORDER BY 
	DATEPART(MONTH,R.FechaCreacion)	
		
		
	
	SELECT 
		COUNT(DISTINCT idPuntoDeVenta) Cant,
		T.fecha,
		T.idUsuario 
	INTO
		#TmpCant
	FROM 
		#TmpDistrPdv T 
	WHERE 
	idPuntoDeVenta IN (
		SELECT DISTINCT idPuntoDeVenta 
		FROM Reporte R 
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte 
		WHERE idEmpresa = 930 
		AND ISNULL(R.FechaCreacion,@FechaDesde) >= @FechaDesde AND ISNULL(R.FechaCreacion,@FechaHasta) <= @FechaHasta
		)
    
	group by T.fecha,T.idUsuario 
	
		
		
	SELECT distinct
		T.ID,
		T.idProducto,
		T.fecha,
		SUM(TieneFrente) PdvConFrentes,
		 ---CONVERT(VARCHAR,(SELECT Cant FROM #TmpCant WHERE fecha = T.fecha AND idUsuario = T.idUsuario)) + LEFT(T.fecha,2) TotalPdv, 
		CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),SUM(TieneFrente) * 100) / (SELECT Cant FROM #TmpCant WHERE fecha = T.fecha AND idUsuario = T.idUsuario ))Porcentaje,
		ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default usuario 		
	INTO
		#TmpDistriProd
	FROM 
		#TmpDistrPdv T
		LEFT JOIN Producto P ON T.idProducto = P.idProducto
		LEFT JOIN Usuario U ON T.idUsuario = U.idUsuario   
	WHERE
		ISNULL(P.idFamilia,0) != 0
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = p.IdMarca))
		AND (ISNULL(@cProductos,0) = 0 OR EXISTS(SELECT 1 FROM #Productos WHERE idProducto = p.idProducto))
		AND (ISNULL(@cFamilia,0) = 0 OR EXISTS(SELECT 1 FROM #familia WHERE idFamilia = p.idFamilia))
	GROUP BY 
		T.idProducto,T.fecha,T.ID,
		U.nombre, u.apellido, T.idUsuario  
	order by T.ID

	
	---FAMILIA
	
	 SELECT     
	idFamilia,    
	T.fecha,    
	SUM(PdvConFrentes) PdvConFrentes,    
	CONVERT(NUMERIC(18,2),AVG(Porcentaje)) Porcentaje,    
	T.usuario usuario       
 INTO     
	#TmpDistriProy    
 FROM     
	#TmpDistriProd T     
 INNER JOIN Producto P ON T.idProducto = P.idProducto      
 GROUP BY    
	idFamilia,       
	T.fecha,    
	T.usuario     
     
--Proyecto    
SELECT     
	--TotalPdv,    
	T.fecha mesdescr,    
	F.idFamilia idFamilia,    
	F.nombre familia,    
	'Porcentaje' descr,    
	Porcentaje qty,    
	T.usuario usuario 
INTO     
	#TmpDistriProy1     
FROM     
	#TmpDistriProy T    
INNER JOIN Familia F ON T.idFamilia = F.idFamilia    
 
	
	
	--SELECT * FROM #TmpDistriProy1
	

    --Distribucion por Producto
	SELECT 
		p.idProducto,
		T.ID,
		P.Nombre Producto,
		T.Porcentaje Qty,
		T.fecha fecha,
		T.usuario
	INTO
		#TmpDistriPivot
	FROM 
		#TmpDistriProd T
		INNER JOIN Producto P ON T.idProducto = P.idProducto
		
	
	
	SELECT DISTINCT 
		Producto
	INTO 
		#SelectFecha
	FROM 
		#TmpDistriPivot
   		

	--DECLARE @ColDef VARCHAR(MAX)
	--
    --
    --DECLARE @PivotTableSQL NVARCHAR(MAX)
	--
	--
	--CREATE TABLE #DatosPivot
	--(
	--	usuario varchar(max), SelectFecha varchar(max)
	--)
	SET @Query = N'
	---insert #DatosPivot([usuario],[SelectFecha])
	SELECT 
		usuario,
		{SelectFecha}
	FROM 
		(SELECT DISTINCT  usuario,Producto, Qty FROM #TmpDistriPivot) A
	PIVOT 
		(MIN(Qty) 
	FOR 
		Producto 
	IN (
		{Productos}
		)) AS Piv
	'
    
	--SELECT * FROM #DatosPivot
    
	SELECT @SelectFechas = COALESCE(@SelectFechas + ',', '') + '['+CONVERT(VARCHAR,Producto)+'] ' 
	FROM #SelectFecha	
		
	SET @Query = REPLACE(@Query,N'{Productos}',@SelectFechas)
	SET @Query = REPLACE(@Query,N'{SelectFecha}',@SelectFechas)
	
	
    
	SELECT 1
    
	SELECT name,title, width FROM
	(
	SELECT 0 Id, 'usuario' name,'usuario' title, 5 width
	UNION
	SELECT 1, Producto,Producto,5 
	FROM #TmpDistriPivot
	) A
    
    --SELECT * FROM #DatosPivot
	--PRINT @Query
	EXEC sp_executesql @Query
    
	DROP TABLE #TmpDistriPivot
	DROP TABLE #TmpDistrPdv
	DROP TABLE #TmpDistriProd
	DROP TABLE #TmpCant
    
	DROP TABLE #fechaCreacionReporte
	DROP TABLE #cadenas
	DROP TABLE #zonas
	DROP TABLE #localidades
	DROP TABLE #usuarios
	DROP TABLE #puntosdeventa
	DROP TABLE #marcas
	DROP TABLE #productos
	DROP TABLE #familia

END
go
declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20180801,20181018')
--insert into @p2 values(N'fltpuntosdeventa',N'94017')
---insert into @p2 values(N'fltusuarios',N'2710')
insert into @p2 values(N'fltProductos',N'12656')

exec WhirlPool_DistribucionFisica_Por_Sku_y_Usuario_T9 @IdCliente=187,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'
