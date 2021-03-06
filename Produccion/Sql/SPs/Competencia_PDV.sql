SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Competencia_PDV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Competencia_PDV] AS' 
END
GO
ALTER PROCEDURE [dbo].[Competencia_PDV]
@IDMARCA INT=NULL,
@IDUSUARIO INT=NULL,
@FECHADESDE DATETIME=NULL,
@FECHAHASTA DATETIME=NULL
AS
BEGIN
 
IF @FECHADESDE IS NULL SET @FECHADESDE = GETDATE()-365
IF @FECHAHASTA IS NULL SET @FECHAHASTA = GETDATE()+1
SELECT
'PDV con ' + T.Competencia AS TITULO,
T.Competencia as COMPETENCIA,
ISNULL(SUM(CASE WHEN T.TIPO='Moderna'
           THEN 1 END),0) AS MODERNA,
ISNULL(SUM(CASE WHEN T.TIPO='Tradicional'
           THEN 1 END),0) AS TRADICIONAL, 
ISNULL(SUM(CASE WHEN T.TIPO='Perfumeria'
           THEN 1 END),0) AS PERFUMERIA
FROM       
(
SELECT 
  dbo.Reporte.IdReporte,
    dbo.PuntoDeVenta.IdPuntoDeVenta,
  dbo.ReporteProductoCompetencia.Cantidad,
  dbo.Producto.Nombre as Producto,
  dbo.Marca.Nombre as Competencia,
  dbo.Tipo.Nombre as Tipo

FROM
  dbo.Reporte
  INNER JOIN dbo.ReporteProductoCompetencia ON (dbo.Reporte.IdReporte = dbo.ReporteProductoCompetencia.IdReporte)
  INNER JOIN dbo.Producto ON (dbo.ReporteProductoCompetencia.IdProducto = dbo.Producto.IdProducto)
  INNER JOIN dbo.Marca ON (dbo.Producto.IdMarca = dbo.Marca.IdMarca)
  INNER JOIN dbo.PuntoDeVenta ON (dbo.Reporte.IdPuntoDeVenta = dbo.PuntoDeVenta.IdPuntoDeVenta)
  INNER JOIN dbo.Tipo ON (dbo.PuntoDeVenta.IdTipo = dbo.Tipo.IdTipo)
  INNER JOIN dbo.MarcaCompetencia ON (dbo.Producto.IdMarca = dbo.MarcaCompetencia.IdMarcaCompetencia)
  INNER JOIN dbo.Marca Marca1 ON (dbo.MarcaCompetencia.IdMarca = Marca1.IdMarca)
WHERE
Reporte.FechaCreacion BETWEEN @FECHADESDE AND @FECHAHASTA
AND Reporte.IdUsuario=@IDUSUARIO
AND Marca1.IdMarca = @IDMARCA
) T
GROUP BY 'PDV con ' + T.Competencia, T.Competencia
END
GO
