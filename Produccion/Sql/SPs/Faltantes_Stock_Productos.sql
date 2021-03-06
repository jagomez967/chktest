SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Faltantes_Stock_Productos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Faltantes_Stock_Productos] AS' 
END
GO
ALTER PROCEDURE [dbo].[Faltantes_Stock_Productos]
@IDMARCA INT=NULL,
@IDUSUARIO INT=NULL,
@FECHADESDE DATETIME=NULL,
@FECHAHASTA DATETIME=NULL
AS
BEGIN
 
IF @FECHADESDE IS NULL SET @FECHADESDE = GETDATE()-365
IF @FECHAHASTA IS NULL SET @FECHAHASTA = GETDATE()+1

SELECT
  dbo.Producto.Nombre AS PRODUCTO,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Moderna' THEN 1 END), 0) AS MODERNA,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Tradicional' THEN 1 END), 0) AS TRADICIONAL,
  ISNULL(SUM(CASE WHEN dbo.Tipo.NOMBRE = 'Perfumeria' THEN 1  END), 0) AS PERFUMERIA
FROM
  dbo.Reporte
  INNER JOIN dbo.PuntoDeVenta ON (dbo.Reporte.IdPuntoDeVenta = dbo.PuntoDeVenta.IdPuntoDeVenta)
  INNER JOIN dbo.Tipo ON (dbo.PuntoDeVenta.IdTipo = dbo.Tipo.IdTipo)
  INNER JOIN dbo.ReporteProducto ON (dbo.Reporte.IdReporte = dbo.ReporteProducto.IdReporte)
  INNER JOIN dbo.Producto ON (dbo.ReporteProducto.IdProducto = dbo.Producto.IdProducto)
  INNER JOIN dbo.Marca ON (dbo.Marca.IdMarca = dbo.Producto.IdMarca)
WHERE 
ReporteProducto.Cantidad=0
AND dbo.Marca.IdMarca = @IDMARCA
AND dbo.Reporte.FechaCreacion BETWEEN @FECHADESDE AND @FECHAHASTA
AND dbo.Reporte.IdUsuario=@IDUSUARIO
GROUP BY
  dbo.Producto.Nombre

END
GO
