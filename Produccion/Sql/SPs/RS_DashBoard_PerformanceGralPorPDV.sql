SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_DashBoard_PerformanceGralPorPDV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_DashBoard_PerformanceGralPorPDV] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_DashBoard_PerformanceGralPorPDV]
	@IdEmpresa int
	,@Mes varchar(max)
	,@IdCadena varchar(max)
	,@IdSegmento varchar(max)
	,@IdZona varchar(max)
	
AS
BEGIN
	SET NOCOUNT ON;


--DECLARE @IdEmpresa int
--DECLARE @Mes varchar(max)
--DECLARE @IdCadena varchar(max)
--DECLARE @IdSegmento varchar(max)
--DECLARE @IdZona varchar(max)
	
--SET @IdEmpresa = 248
--SET @Mes = '201404,201405'
--SET @IdCadena = NULL
--SET @IdSegmento = NULL
--SET @IdZona = NULL
	
DECLARE @TotalModulos TABLE(IdReporte int, IdMarca int, Mes char(6), TotalModulos Decimal(18,2)) 

DECLARE @Mes1 varchar(6), @Mes2 varchar(6)
SELECT @Mes1 = SUBSTRING(@Mes,1,6), @Mes2 = SUBSTRING(@Mes,8,6)


INSERT INTO @TotalModulos
	SELECT
		RMM.IdReporte 
		,MM.IdMarca
		,@Mes1 as Mes
		,SUM(MM.Ponderacion) as TotalModulos
	FROM dbo.MD_ModuloMarca MM
	JOIN
		(SELECT DISTINCT RMI.IdReporte, RMI.IdMarca, I.IdModulo 
		FROM dbo.MD_ReporteModuloItem RMI
		JOIN dbo.MD_Item I on I.IdItem = RMI.IdItem
		JOIN dbo.Reporte R on R.IdReporte = RMI.IdReporte
		WHERE (R.IdEmpresa = @IdEmpresa)
			AND (R.FechaCreacion = (SELECT MAX(R2.FechaCreacion) FROM dbo.Reporte R2
				WHERE R2.IdEmpresa = R.IdEmpresa and R2.IdPuntoDeVenta = R.IdPuntoDeVenta
					and Convert(char(6),R2.FechaCreacion,112) = @Mes1))) RMM on RMM.IdMarca = MM.IdMarca and RMM.IdModulo = MM.IdModulo
	GROUP BY 
		RMM.IdReporte 
		,MM.IdMarca
UNION ALL
	SELECT
		RMM.IdReporte 
		,MM.IdMarca
		,@Mes2 as Mes
		,SUM(MM.Ponderacion) as TotalModulos
	FROM dbo.MD_ModuloMarca MM
	JOIN
		(SELECT DISTINCT RMI.IdReporte, RMI.IdMarca, I.IdModulo 
		FROM dbo.MD_ReporteModuloItem RMI
		JOIN dbo.MD_Item I on I.IdItem = RMI.IdItem
		JOIN dbo.Reporte R on R.IdReporte = RMI.IdReporte
		WHERE (R.IdEmpresa = @IdEmpresa)
			AND (R.FechaCreacion = (SELECT MAX(R2.FechaCreacion) FROM dbo.Reporte R2
				WHERE R2.IdEmpresa = R.IdEmpresa and R2.IdPuntoDeVenta = R.IdPuntoDeVenta
					and Convert(char(6),R2.FechaCreacion,112) = @Mes2))) RMM on RMM.IdMarca = MM.IdMarca and RMM.IdModulo = MM.IdModulo
	GROUP BY 
		RMM.IdReporte 
		,MM.IdMarca
	
	

SELECT
	R.IdPuntoDeVenta
	,PDV.Nombre as PuntoDeVenta
	,Convert(char(6),R.FechaCreacion,112) as IdMes
	,Datename(MM,R.FechaCreacion) + ' ' + Datename(yy,R.FechaCreacion) as Mes 
	,SUM(RMI.Valor1 * MMI.Ponderacion * (MM.Ponderacion / TM.TotalModulos * 100) * MP.Ponderacion) / 1000000 as Performance
FROM dbo.MD_ReporteModuloItem RMI
JOIN dbo.MD_Item I on I.IdItem = RMI.IdItem
JOIN dbo.MD_Modulo M on M.IdModulo = I.IdModulo
JOIN dbo.Reporte R on R.IdReporte = RMI.IdReporte
JOIN dbo.Marca MAR on MAR.IdMarca = RMI.IdMarca
JOIN dbo.MD_ModuloMarcaItem MMI on MMI.IdItem = I.IdItem and MMI.IdMarca = MAR.IdMarca
JOIN dbo.MD_ModuloMarca MM on MM.IdModulo = M.IdModulo and MM.IdMarca = MAR.IdMarca
JOIN dbo.MD_MarcaPonderacion MP on MP.IdMarca = MAR.IdMarca
JOIN @TotalModulos TM on 
		TM.IdMarca = RMI.IdMarca 
	and TM.IdReporte = RMI.IdReporte
	and TM.Mes = Convert(char(6),R.FechaCreacion,112)
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
JOIN (SELECT MAX(R2.FechaCreacion) as MaxFecha
			,convert(char(6),R2.FechaCreacion,112) as Mes
			,R2.IdPuntoDeVenta 
	FROM dbo.Reporte R2
	JOIN dbo.MD_ReporteModuloItem RMI on RMI.IdReporte = R2.IdReporte
		WHERE R2.IdEmpresa = @IdEmpresa
			AND convert(char(6),R2.FechaCreacion,112) IN (SELECT clave FROM dbo.fnSplitString(@Mes,','))
	GROUP BY convert(char(6),R2.FechaCreacion,112),R2.IdPuntoDeVenta) MaxFecha on 
		MaxFecha.MaxFecha = R.FechaCreacion 
	and MaxFecha.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE (R.IdEmpresa = @IdEmpresa)
	AND (@IdCadena IS NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
	AND (@IdZona IS NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
GROUP BY R.IdPuntoDeVenta
	,PDV.Nombre
	,Convert(char(6),R.FechaCreacion,112)
	,Datename(MM,R.FechaCreacion) + ' ' + Datename(yy,R.FechaCreacion)
ORDER BY 
	PDV.Nombre
	,Convert(char(6),R.FechaCreacion,112)

END
GO
