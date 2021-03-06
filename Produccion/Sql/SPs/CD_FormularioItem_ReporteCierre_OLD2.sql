SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_ReporteCierre_OLD2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre_OLD2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre_OLD2]

	@FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL
   ,@IdSistema int 
AS
BEGIN
	SET NOCOUNT ON;

SELECT 
		CONVERT(VARCHAR(10), @FechaCargaDesde, 103)   AS FechaCargaDesde
	   ,CONVERT(VARCHAR(10), @FechaCargaHasta, 103)   AS FechaCargaHasta
	   ,dbo.MES_Letras(F.FechaTicket) AS MesTicket
       ,V.[Nombre] AS VisitadorNombre
       ,R.[Nombre] AS RepresentanteNombre 
       ,PDV.[Codigo] AS PDVCodigo
       ,PDV.[Nombre] AS PDVNombre       
       ,P.[Codigo] AS ProductoCodigo
       ,P.[Nombre] AS ProductoNombre
       ,SUM (FI.[Cantidad]) AS Cantidad       
       ,CONVERT (Decimal(18,2), ISNULL(LP.PrecioSugerido,0)) AS PrecioUnitario
       ,CONVERT (Decimal(18,2), (ISNULL(C.PorcDescuento,0) /100)) AS PorcDescuento   
       ,CONVERT (Decimal(18,2), (ISNULL(LP.PrecioSugerido,0) * (ISNULL(C.PorcDescuento,0) /100))) AS Importe           
       ,CONVERT (Decimal(18,2), (ISNULL(LP.PrecioSugerido,0) * (ISNULL(C.PorcDescuento,0) /100)) * (SUM (FI.[Cantidad])))  AS Total                   
  FROM [dbo].[CD_FormularioItem] FI
  INNER JOIN CD_Formulario AS F ON (F.[IdFormulario] =  FI.[IdFormulario])   
  INNER JOIN CD_Producto AS P ON (P.[IdProducto] =  FI.[IdProducto]) 
  INNER JOIN CD_PuntoDeVenta AS PDV ON (PDV.[IdPuntoDeVenta] = F.[IdPuntoDeVenta])
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania] AND C.IdSistema = @IdSistema)
  LEFT JOIN CD_ListaPrecios AS LP ON (LP.Codigo = P.Codigo AND @IdSistema = LP.IdSistema) 
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = PDV.[IdVisitador]) 
  LEFT JOIN CD_Representante AS R ON (R.[IdRepresentante] = PDV.[IdRepresentante])
  WHERE    @FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112) )
  GROUP BY dbo.MES_Letras(F.FechaTicket),V.[Nombre],R.[Nombre],FI.[IdProducto], PDV.[IdPuntoDeVenta], PDV.[Codigo], PDV.[Nombre], P.[Codigo], P.[Nombre],LP.PrecioSugerido,C.PorcDescuento 
    
END
GO
