SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Material_Pop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Material_Pop] AS' 
END
GO
ALTER PROCEDURE [dbo].[Material_Pop]
@IDMARCA INT=NULL,
@IDUSUARIO INT=NULL,
@FECHADESDE DATETIME=NULL,
@FECHAHASTA DATETIME=NULL
AS
BEGIN
 
IF @FECHADESDE IS NULL SET @FECHADESDE = GETDATE()-365
IF @FECHAHASTA IS NULL SET @FECHAHASTA = GETDATE()+1

SELECT 
  dbo.Pop.Nombre AS POP,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Moderna' THEN dbo.ReportePop.Cantidad END), 0) AS MODERNA,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Tradicional' THEN dbo.ReportePop.Cantidad END), 0) AS TRADICIONAL,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Perfumeria' THEN dbo.ReportePop.Cantidad END), 0) AS PERFUMERIA
FROM
  dbo.Reporte
  INNER JOIN dbo.PuntoDeVenta ON (dbo.Reporte.IdPuntoDeVenta = dbo.PuntoDeVenta.IdPuntoDeVenta)
  INNER JOIN dbo.Tipo ON (dbo.PuntoDeVenta.IdTipo = dbo.Tipo.IdTipo)
  INNER JOIN dbo.ReportePop ON (dbo.ReportePop.IdReporte = dbo.Reporte.IdReporte)
  INNER JOIN dbo.Pop ON (dbo.ReportePop.IdPop = dbo.Pop.IdPop)
WHERE 
dbo.ReportePop.IdMarca= @IDMARCA
AND dbo.Reporte.FechaCreacion BETWEEN @FECHADESDE AND @FECHAHASTA
AND dbo.Reporte.IdUsuario=@IDUSUARIO
GROUP BY
  dbo.Pop.Nombre

END
GO
