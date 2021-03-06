SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_ReporteMes_OLD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_ReporteMes_OLD] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_ReporteMes_OLD]

    @FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL

AS
BEGIN
	SET NOCOUNT ON;

SELECT 	dbo.MES_Letras(F.FechaCarga) AS MesCarga    
       ,dbo.MES_Letras(F.FechaTicket) AS MesTicket 
       ,M.[Nombre] AS MedicoNombre          
       ,V.[Nombre] AS VisitadorNombre       
       ,P.[Codigo] AS ProductoCodigo
       ,P.[Nombre] AS ProductoNombre
       ,SUM (FI.[Cantidad]) AS Cantidad   
       ,C.Nombre AS CampaniaNombre    
  FROM [dbo].[CD_FormularioItem] FI
  INNER JOIN CD_Formulario AS F ON (F.[IdFormulario] =  FI.[IdFormulario]) 
  INNER JOIN CD_Producto AS P ON (P.[IdProducto] =  FI.[IdProducto]) 
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania])  
  LEFT JOIN CD_Medico AS M ON (M.IdMedico = F.IdMedico)
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = M.[IdVisitador]) 
  --WHERE @FechaCargaDesde IS NULL OR  (F.[FechaCarga] between @FechaCargaDesde AND  @FechaCargaHasta)
  WHERE    @FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112) )
  GROUP BY dbo.MES_Letras(F.FechaTicket), dbo.MES_Letras(F.FechaCarga),M.[Nombre],V.[Nombre],P.[Codigo], P.[Nombre],C.Nombre
END
GO
