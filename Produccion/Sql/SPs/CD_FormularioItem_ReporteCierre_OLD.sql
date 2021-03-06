SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_ReporteCierre_OLD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre_OLD] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_ReporteCierre_OLD]

	 @Mes int
	,@Ano int

AS
BEGIN
	SET NOCOUNT ON;

SELECT --DATEPART (month, F.FechaTicket) AS Mes	   
		dbo.MES_Letras(F.FechaCarga) AS MesCarga    
       ,dbo.MES_Letras(F.FechaTicket) AS MesTicket           
       ,V.[Nombre] AS VisitadorNombre
       ,R.[Nombre] AS RepresentanteNombre 
       --,PDV.[IdPuntoDeVenta] 
       ,PDV.[Codigo] AS PDVCodigo
       ,PDV.[Nombre] AS PDVNombre
       --,FI.[IdProducto]
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
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania])
  LEFT JOIN CD_ListaPrecios AS LP ON (LP.Codigo = P.Codigo) 
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = PDV.[IdVisitador]) 
  LEFT JOIN CD_Representante AS R ON (R.[IdRepresentante] = PDV.[IdRepresentante])
  WHERE DATEPART (month, F.FechaCarga) = @Mes AND 
		DATEPART (year, F.FechaCarga) = @Ano 
  GROUP BY dbo.MES_Letras(F.FechaTicket), dbo.MES_Letras(F.FechaCarga),V.[Nombre],R.[Nombre],FI.[IdProducto], PDV.[IdPuntoDeVenta], PDV.[Codigo], PDV.[Nombre], P.[Codigo], P.[Nombre],LP.PrecioSugerido,C.PorcDescuento 
    
END
GO
