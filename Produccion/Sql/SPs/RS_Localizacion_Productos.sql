SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_Localizacion_Productos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_Localizacion_Productos] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_Localizacion_Productos] 	
	 @IdEmpresa int
	,@Dia varchar(max)=NULL
	,@Mes varchar(max)=NULL--(yyyymm)
	,@Ano varchar(max)=NULL
	,@Semana varchar(max)=NULL--(yyyyss)
	,@IdMarca varchar(max)=NULL
	,@IdProducto varchar(max)=NULL
	,@IdCadena varchar(max)=NULL
	,@IdPuntoDeVenta varchar(max)=NULL
	,@IdLocalidad varchar(max)=NULL
	,@IdZona varchar(max)=NULL
	,@IdUsuario varchar(max)=NULL
	
	
AS
BEGIN
	
	SET NOCOUNT ON;

--DECLARE @IdEmpresa int
--DECLARE @Dia varchar(max)
--DECLARE @Mes varchar(max)
--DECLARE @Ano varchar(max)
--DECLARE @Semana varchar(max)
--DECLARE @IdMarca varchar(max)
--DECLARE @IdProducto varchar(max)
--DECLARE @IdCadena varchar(max)
--DECLARE @IdPuntoDeVenta varchar(max)
--DECLARE @IdLocalidad varchar(max)
--DECLARE @IdZona varchar(max)
--DECLARE @IdUsuario varchar(max)

--SET @IdEmpresa = 270
--SET @Dia =NULL
--SET @Mes ='201407'
--SET @Ano =NULL
--SET @Semana =NULL
--SET @IdMarca =NULL
--SET @IdProducto =NULL
--SET @IdCadena =NULL
--SET @IdPuntoDeVenta =NULL
--SET @IdLocalidad =NULL
--SET @IdZona =NULL
--SET @IdUsuario =NULL



DECLARE @Reportes Table (IdReporte int)

INSERT INTO @Reportes
SELECT  R.IdReporte	   
FROM dbo.Reporte R
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE 
	     R.IdEmpresa = @IdEmpresa
	and (@Ano IS NULL OR YEAR(R.FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
	and (@Mes IS NULL OR Convert(nchar(6),R.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))	
	and (@Semana IS NULL OR Convert(char(6),(YEAR(R.FechaCreacion)*100) + DATEPART(WK,R.FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
	and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
	and (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
	and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
	and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
	and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
GROUP BY R.IdReporte, R.IdPuntoDeVenta


SELECT X.IdExhibidor as IdExhibidor,
	E.Nombre as NombreExhibidor,
	Loc.Posicion as Posicion,
	SUM(X.Cantidad) AS Cantidad,
	'CLI' as Tipo -- CLI:Cliente		COMP:Competencia	
FROM 
	(SELECT  
		 RP.IdProducto AS IdProducto
		,RP.IdExhibidor AS IdExhibidor
		,ISNULL(RP.Cantidad,0) AS Cantidad
	FROM ReporteProducto AS RP
	INNER JOIN @Reportes AS R ON (R.IdReporte = RP.IdReporte)
	WHERE RP.IdExhibidor IS NOT NULL
	UNION ALL
	SELECT  
		 RP.IdProducto AS IdProducto
		,RP.IdExhibidor2 AS IdExhibidor
		,ISNULL(RP.Cantidad2,0)AS Cantidad
	FROM ReporteProducto AS RP
	INNER JOIN @Reportes AS R ON (R.IdReporte = RP.IdReporte)
	WHERE RP.IdExhibidor2 IS NOT NULL 
	) AS X
JOIN dbo.Producto P on P.IdProducto = X.IdProducto
JOIN dbo.Exhibidor E on E.IdExhibidor = X.IdExhibidor
JOIN dbo.RS_Localizacion_Exhibidor Loc on Loc.IdEmpresa = @IdEmpresa and Loc.IdExhibidor = X.IdExhibidor
WHERE(@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
 and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY X.IdExhibidor,E.Nombre,Loc.Posicion

UNION ALL

SELECT RP.IdExhibidor as IdExhibidor,
	E.Nombre as NombreExhibidor,
	Loc.Posicion as Posicion,
	SUM(RP.Cantidad) AS Cantidad,
	'COMP' as Tipo -- CLI:Cliente		COMP:Competencia	
FROM 
	(SELECT  
		 RP.IdProducto AS IdProducto
		,RP.IdExhibidor AS IdExhibidor
		,ISNULL(RP.Cantidad,0) AS Cantidad
	FROM ReporteProductoCompetencia AS RP
	INNER JOIN @Reportes AS R ON (R.IdReporte = RP.IdReporte)
	WHERE RP.IdExhibidor IS NOT NULL
	UNION ALL
	SELECT  
		 RP.IdProducto AS IdProducto
		,RP.IdExhibidor2 AS IdExhibidor
		,ISNULL(RP.Cantidad2,0)AS Cantidad
	FROM ReporteProductoCompetencia AS RP
	INNER JOIN @Reportes AS R ON (R.IdReporte = RP.IdReporte)
	WHERE RP.IdExhibidor2 IS NOT NULL 
	) AS RP
JOIN dbo.Producto PComp on PComp.IdProducto = RP.IdProducto
JOIN dbo.ProductoCompetencia PC ON PC.IdProductoCompetencia = PComp.IdProducto
JOIN dbo.Producto P on P.IdProducto = PC.IdProducto
JOIN dbo.Exhibidor E on E.IdExhibidor = RP.IdExhibidor
JOIN dbo.RS_Localizacion_Exhibidor Loc on Loc.IdEmpresa = @IdEmpresa and Loc.IdExhibidor = RP.IdExhibidor
WHERE(@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
 and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY RP.IdExhibidor,E.Nombre,Loc.Posicion
ORDER BY 1



----------------------------------------------------------------------

--SELECT  
--	 RP.IdExhibidor
--	,E.Nombre as NombreExhibidor
--	,Loc.Posicion
--	,ISNULL(SUM(RP.Cantidad),0) as Cantidad
--	,'CLI' as Tipo -- CLI:Cliente		COMP:Competencia	
--FROM dbo.Reporte R
--JOIN (SELECT  
--			 IdReporte
--			,IdProducto
--			,IdExhibidor 
--			,Cantidad
--		FROM ReporteProducto
--		WHERE IdExhibidor IS NOT NULL
--		UNION 
--		SELECT 
--			 IdReporte
--			,IdProducto
--			,IdExhibidor2 as IdExhibidor
--			,Cantidad2 as Cantidad
--		FROM ReporteProducto
--		WHERE IdExhibidor2 IS NOT NULL) RP on RP.IdReporte = R.IdReporte
--JOIN dbo.Producto P on P.IdProducto = RP.IdProducto
--JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
--JOIN dbo.Exhibidor E on E.IdExhibidor = RP.IdExhibidor
--JOIN dbo.RS_Localizacion_Exhibidor Loc on Loc.IdEmpresa = R.IdEmpresa and Loc.IdExhibidor = RP.IdExhibidor
--WHERE  RP.IdExhibidor is NOT NULL
--	and R.IdEmpresa = @IdEmpresa
--	and (@Ano IS NULL OR YEAR(R.FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
--	and (@Mes IS NULL OR Convert(nchar(6),R.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))
--	--and (DAY(R.FechaCreacion) = @Dia OR @Dia is NULL)
--	and (@Semana IS NULL OR Convert(char(6),(YEAR(R.FechaCreacion)*100) + DATEPART(WK,R.FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
--	and (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
--	and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
--	and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
--	and (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
--	and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
--	and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
--	and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
--GROUP BY
--	RP.IdExhibidor
--	,E.Nombre
--	,Loc.Posicion

--UNION ALL

--SELECT  
--	 RP.IdExhibidor
--	,E.Nombre as NombreExhibidor
--	,Loc.Posicion
--	,ISNULL(SUM(RP.Cantidad),0) as Cantidad
--	,'COMP' as Tipo -- CLI:Cliente		COMP:Competencia
--FROM dbo.Reporte R
--JOIN (SELECT  
--			 IdReporte
--			,IdProducto
--			,IdExhibidor 
--			,Cantidad
--		FROM dbo.ReporteProductoCompetencia
--		WHERE IdExhibidor IS NOT NULL
--		UNION 
--		SELECT 
--			 IdReporte
--			,IdProducto
--			,IdExhibidor2 as IdExhibidor
--			,Cantidad2 as Cantidad
--		FROM dbo.ReporteProductoCompetencia
--		WHERE IdExhibidor2 IS NOT NULL) RP on RP.IdReporte = R.IdReporte
--JOIN dbo.Producto PComp on PComp.IdProducto = RP.IdProducto
--JOIN dbo.ProductoCompetencia PC ON PC.IdProductoCompetencia = PComp.IdProducto
--JOIN dbo.Producto PPropio on PPropio.IdProducto = PC.IdProducto
--JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
--JOIN dbo.Exhibidor E on E.IdExhibidor = RP.IdExhibidor
--JOIN dbo.RS_Localizacion_Exhibidor Loc on Loc.IdEmpresa = R.IdEmpresa and Loc.IdExhibidor = RP.IdExhibidor
--WHERE  RP.IdExhibidor is NOT NULL
--	and R.IdEmpresa = @IdEmpresa
--	and (@Ano IS NULL OR YEAR(R.FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
--	and (@Mes IS NULL OR Convert(nchar(6),R.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))
--	--and (DAY(R.FechaCreacion) = @Dia OR @Dia is NULL)
--	and (@Semana IS NULL OR Convert(char(6),(YEAR(R.FechaCreacion)*100) + DATEPART(WK,R.FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
--	and (@IdMarca is NULL OR PPropio.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
--	and (@IdProducto is NULL OR PPropio.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
--	and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
--	and (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
--	and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
--	and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
--	and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
--GROUP BY
--	RP.IdExhibidor
--	,E.Nombre
--	,Loc.Posicion
	
--ORDER BY 1




END
GO
