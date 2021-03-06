SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_Share]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_Share] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_Share] 	
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
	
--SET @IdEmpresa = 21
--SET @Dia =NULL
--SET @Mes ='201412'
--SET @Ano =NULL
--SET @Semana =NULL
--SET @IdMarca =NULL
--SET @IdProducto =NULL
--SET @IdCadena =NULL
--SET @IdPuntoDeVenta =NULL
--SET @IdLocalidad =NULL
--SET @IdZona = NULL
--SET @IdUsuario =NULL
	

DECLARE @Reportes Table (IdReporte int, PRIMARY KEY(IdReporte))
DECLARE @Reportes2 Table (IdReporte int, IdPuntoDeVenta int, FechaCreacion datetime, PRIMARY KEY(IdReporte,IdPuntoDeVenta,FechaCreacion))

INSERT INTO @Reportes2
SELECT  R.IdReporte, R.IdPuntoDeVenta, R.FechaCreacion	   
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
GROUP BY R.IdReporte, R.IdPuntoDeVenta, R.FechaCreacion



INSERT INTO @Reportes
SELECT R2.IdReporte
FROM @Reportes2 R2
WHERE R2.FechaCreacion = 
	(SELECT MAX(R3.FechaCreacion) FROM @Reportes2 R3
	WHERE R3.IdPuntoDeVenta = R2.IdPuntoDeVenta)
GROUP BY R2.IdReporte, R2.IdPuntoDeVenta




----------------------------------------------------------------
--Share por Cadena
SELECT	
		ltrim(rtrim(E.Nombre)) as Empresa,
		IsNull(ltrim(rtrim(CA.Nombre)),'<SIN CADENA>') as Cadena,
		SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)) as CantidadFrentes,
		SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)) as CantidadFrentesEmpresa
FROM @Reportes R
JOIN dbo.Reporte R1 on R1.IdReporte  = R.IdReporte
JOIN Empresa E on E.IdEmpresa = R1.IdEmpresa
JOIN ReporteProducto RP on R.IdReporte = RP.IdReporte
JOIN Producto P on RP.IdProducto = P.IdProducto
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R1.IdPuntoDeVenta
LEFT JOIN dbo.Cadena CA on CA.IdCadena =PDV.IdCadena
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY E.Nombre,CA.Nombre

UNION ALL

SELECT	
		'Competencia' as Empresa,
		IsNull(ltrim(rtrim(CA.Nombre)),'<SIN CADENA>') as Cadena,
		SUM(ISNULL(Cantidad,0) + ISNULL(Cantidad2,0)) as CantidadFrentes,
		0 as CantidadFrentesEmpresa
FROM @Reportes R
JOIN ReporteProductoCompetencia RP on RP.IdReporte = R.IdReporte
JOIN ProductoCompetencia PC on PC.IdProductoCompetencia = RP.IdProducto
JOIN Producto P on P.IdProducto = PC.IdProducto
JOIN dbo.Reporte R1 on R1.IdReporte  = R.IdReporte
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R1.IdPuntoDeVenta
LEFT JOIN dbo.Cadena CA on CA.IdCadena =PDV.IdCadena
WHERE (@IdMarca is NULL OR P.IdMarca IN (SELECT clave FROM dbo.fnSplitString(@IdMarca,',')))
and (@IdProducto is NULL OR P.IdProducto IN (SELECT clave FROM dbo.fnSplitString(@IdProducto,',')))
GROUP BY CA.Nombre

----------------------------------------------------------------


END
GO
