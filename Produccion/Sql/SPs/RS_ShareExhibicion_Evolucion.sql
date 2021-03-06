SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_ShareExhibicion_Evolucion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_ShareExhibicion_Evolucion] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_ShareExhibicion_Evolucion] 	
	 @IdEmpresa int
	,@Dia varchar(max)=NULL
	,@Mes varchar(max)=NULL
	,@Ano varchar(max)=NULL
	,@Semana varchar(max)=NULL
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


DECLARE @Reportes Table (IdReporte int)
DECLARE @Reportes2 Table (IdReporte int, IdPuntoDeVenta int, FechaCreacion datetime)
DECLARE @Share_Evol TABLE (Empresa varchar(80), Periodo varchar(30), CantidadFrentes decimal(18,4))
DECLARE @Fecha_Desde datetime, @Fecha_Hasta datetime
DECLARE @ReportesMAX Table (IdPuntoDeVenta int,  FechaCreacion DateTime)
SET  @Fecha_Desde = DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,getdate())-13,0))
SET  @Fecha_Hasta  = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))
		
		
INSERT INTO @Reportes2
SELECT  R.IdReporte, R.IdPuntoDeVenta, R.FechaCreacion	   
FROM dbo.Reporte R
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE 
	     R.IdEmpresa = @IdEmpresa
	and R.FechaCreacion between @Fecha_Desde and @Fecha_Hasta
	--and (@Ano IS NULL OR YEAR(R.FechaCreacion) IN (SELECT clave FROM dbo.fnSplitString(@Ano,','))) 
	--and (@Mes IS NULL OR Convert(nchar(6),R.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,',')))	
	--and (@Semana IS NULL OR Convert(char(6),(YEAR(R.FechaCreacion)*100) + DATEPART(WK,R.FechaCreacion)) IN (SELECT clave FROM dbo.fnSplitString(@Semana,',')))
	and (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
	and (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
	and (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
	and (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
	and (@IdUsuario is NULL OR R.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
GROUP BY R.IdReporte, R.IdPuntoDeVenta, R.FechaCreacion


INSERT INTO @ReportesMAX
SELECT R4.IdPuntoDeVenta, MAX(R4.FechaCreacion) 
FROM @Reportes2 R4
GROUP BY R4.IdPuntoDeVenta, Convert(char(6),R4.FechaCreacion,112)

INSERT INTO @Reportes
SELECT R2.IdReporte
FROM @Reportes2 R2
JOIN @ReportesMAX R5 ON (R5.FechaCreacion = R2.FechaCreacion 
                         AND R5.IdPuntoDeVenta = R2.IdPuntoDeVenta)


INSERT INTO @Share_Evol
SELECT	ltrim(rtrim(E.Nombre)) as Empresa,
		Convert(varchar,YEAR(R1.FechaCreacion)) + '/' + Replicate('0',2-LEN(Convert(varchar,MONTH(R1.FechaCreacion)))) + Convert(varchar,MONTH(R1.FechaCreacion)) as Periodo,
		SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)) as CantidadFrentes
FROM @Reportes R
INNER JOIN ReporteProducto RP on R.IdReporte = RP.IdReporte
INNER JOIN Reporte R1 on R1.IdReporte = R.IdReporte
INNER JOIN Empresa E on E.IdEmpresa = R1.IdEmpresa
INNER JOIN Producto P on RP.IdProducto = P.IdProducto
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY E.Nombre,
		 Convert(varchar,YEAR(R1.FechaCreacion)) + '/' + Replicate('0',2-LEN(Convert(varchar,MONTH(R1.FechaCreacion)))) + Convert(varchar,MONTH(R1.FechaCreacion))

UNION ALL

SELECT	'Competencia' as Empresa,
		Convert(varchar,YEAR(R1.FechaCreacion)) + '/' + Replicate('0',2-LEN(Convert(varchar,MONTH(R1.FechaCreacion)))) + Convert(varchar,MONTH(R1.FechaCreacion)) as Periodo,
		SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)) as CantidadFrentes
FROM @Reportes R
INNER JOIN Reporte R1 on R1.IdReporte = R.IdReporte
INNER JOIN ReporteProductoCompetencia RP on R.IdReporte = RP.IdReporte
INNER JOIN ProductoCompetencia PC on PC.IdProductoCompetencia = RP.IdProducto
INNER JOIN Producto P on P.IdProducto = PC.IdProducto
--INNER JOIN PuntoDeVenta PDV on R.IdPuntoDeVenta = PDV.IdPuntoDeVenta
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY Convert(varchar,YEAR(R1.FechaCreacion)) + '/' + Replicate('0',2-LEN(Convert(varchar,MONTH(R1.FechaCreacion)))) + Convert(varchar,MONTH(R1.FechaCreacion))

--SELECT * FROM @Share_Evol


SELECT	E.Empresa,
		E.Periodo,
		(CASE WHEN isnull(S.Total,0) = 0 THEN 0 ELSE E.CantidadFrentes/S.Total END) AS CantidadFrentes
FROM @Share_Evol E
INNER JOIN (SELECT Periodo, SUM(CantidadFrentes) as Total FROM @Share_Evol GROUP BY Periodo) S ON E.Periodo = S.Periodo


END
GO
