SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_ReporteCierre]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre]

	@FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL
   ,@IdSistema int 
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Modificado el 10/07/2012 para que no tome lo que estan vencidos ni, ni los que no tiene ticket.

SELECT 
		CONVERT(VARCHAR(10), @FechaCargaDesde, 103)   AS FechaCargaDesde
	   ,CONVERT(VARCHAR(10), @FechaCargaHasta, 103)   AS FechaCargaHasta	   
	   ,dbo.MES_Letras(F.FechaTicket) AS MesTicket
       ,Year(F.FechaTicket) As AnoTicket
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
--  INNER JOIN CD_Formulario AS F ON (F.[IdFormulario] =  FI.[IdFormulario] AND (F.[Vencido] IS NULL OR F.[Vencido]=1) AND (F.[SinTicket] IS NULL OR F.[SinTicket]=1))   
  INNER JOIN CD_Formulario AS F ON (F.[IdFormulario] =  FI.[IdFormulario] AND (F.[SinTicket] IS NULL OR F.[SinTicket]=0))   
  INNER JOIN CD_Producto AS P ON (P.[IdProducto] =  FI.[IdProducto]) 
  INNER JOIN CD_PuntoDeVenta AS PDV ON (PDV.[IdPuntoDeVenta] = F.[IdPuntoDeVenta])
  INNER JOIN  CD_PuntoDeVenta_Sistema PDVS ON (PDVS.IdPuntoDeVenta = PDV.IdPuntoDeVenta AND PDVS.IdSistema = @IdSistema)
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania] AND C.IdSistema = @IdSistema)
  --LEFT JOIN CD_ListaPrecios AS LP ON (LP.Codigo = P.Codigo AND @IdSistema = LP.IdSistema) 
  LEFT JOIN CD_ListaPrecios AS LP ON (LP.Codigo = P.Codigo AND @IdSistema = LP.IdSistema AND 
  LP.FechaDesde = (SELECT MAX(LP2.FechaDesde) FROM CD_ListaPrecios LP2 
			WHERE LP2.Codigo = LP.Codigo AND LP2.IdSistema = LP.IdSistema AND LP2.FechaDesde <= F.FechaTicket))   
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = PDVS.[IdVisitador])   
  LEFT JOIN CD_Representante AS R ON (R.IdRepresentante = PDVS.IdRepresentante)
  WHERE    @FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112) )
		   AND 	(NOT ISNULL(C.PorcDescuento,0) = 0) -- Agregado por pedio de Loreal el 19/02
  GROUP BY Year(F.FechaTicket), Month(F.FechaTicket), dbo.MES_Letras(F.FechaTicket),V.[Nombre],R.[Nombre],FI.[IdProducto], PDV.[IdPuntoDeVenta], PDV.[Codigo], PDV.[Nombre], P.[Codigo], P.[Nombre],LP.PrecioSugerido,C.PorcDescuento
  ORDER BY Year(F.FechaTicket),Month(F.FechaTicket)
    
END
GO
