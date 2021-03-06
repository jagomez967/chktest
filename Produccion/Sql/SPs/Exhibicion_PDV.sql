SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibicion_PDV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibicion_PDV] AS' 
END
GO
ALTER PROCEDURE [dbo].[Exhibicion_PDV]
@IDMARCA INT=NULL,
@IDUSUARIO INT=NULL,
@FECHADESDE DATETIME=NULL,
@FECHAHASTA DATETIME=NULL
AS
BEGIN
 
IF @FECHADESDE IS NULL SET @FECHADESDE = GETDATE()-365
IF @FECHAHASTA IS NULL SET @FECHAHASTA = GETDATE()+1

SELECT 
  dbo.Exhibidor.Nombre AS EXHIBICION,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Moderna' THEN dbo.ReporteExhibicion.Cantidad END), 0) AS MODERNA,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Tradicional' THEN dbo.ReporteExhibicion.Cantidad END), 0) AS TRADICIONAL,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Perfumeria' THEN dbo.ReporteExhibicion.Cantidad END), 0) AS PERFUMERIA
FROM
  dbo.Reporte
  INNER JOIN dbo.ReporteExhibicion ON (dbo.Reporte.IdReporte = dbo.ReporteExhibicion.IdReporte)
  INNER JOIN dbo.Exhibidor ON (dbo.ReporteExhibicion.IdExhibidor = dbo.Exhibidor.IdExhibidor)
  INNER JOIN dbo.PuntoDeVenta ON (dbo.Reporte.IdPuntoDeVenta = dbo.PuntoDeVenta.IdPuntoDeVenta)
  INNER JOIN dbo.Tipo ON (dbo.PuntoDeVenta.IdTipo = dbo.Tipo.IdTipo)
WHERE 
dbo.ReporteExhibicion.IdMarca = @IDMARCA
AND dbo.Reporte.FechaCreacion BETWEEN @FECHADESDE AND @FECHAHASTA
AND dbo.Reporte.IdUsuario=@IDUSUARIO
GROUP BY
  dbo.Exhibidor.Nombre

END
GO
