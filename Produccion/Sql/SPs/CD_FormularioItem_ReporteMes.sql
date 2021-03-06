SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_ReporteMes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_ReporteMes] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_ReporteMes]

    @FechaCargaDesde datetime = NULL
   ,@FechaCargaHasta datetime = NULL
   ,@IdSistema int 

AS
BEGIN
	SET NOCOUNT ON;

SELECT  CONVERT(VARCHAR(10), @FechaCargaDesde, 103)   AS FechaCargaDesde
	   ,CONVERT(VARCHAR(10), @FechaCargaHasta, 103)   AS FechaCargaHasta
	   ,Year(F.FechaTicket) As AnoTicket
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
  INNER JOIN CD_Campania AS C ON (C.[IdCampania] = F.[IdCampania]  AND C.IdSistema = @IdSistema)  
  LEFT JOIN CD_Medico AS M ON (M.IdMedico = F.IdMedico)
  --LEFT JOIN CD_Medico_Sistema AS MS ON (MS.IdMedico = M.IdMedico AND MS.IdSistema = @IdSistema)  
  -- Nuevo 07/09/2012 - Para obtnerr los utlimos visitadores assignados del Medico.  
  LEFT JOIN CD_Medico_Sistema AS MS ON (MS.IdMedico = M.IdMedico AND MS.IdSistema = @IdSistema AND 
  MS.FechaDesde = (SELECT MAX(MS2.FechaDesde) FROM CD_Medico_Sistema MS2 
			WHERE MS2.IdMedico = MS.IdMedico AND MS2.IdSistema = MS.IdSistema AND MS2.FechaDesde <= F.FechaTicket))      
  LEFT JOIN CD_Visitador AS V ON (V.[IdVisitador] = MS.[IdVisitador1]) 
  --WHERE @FechaCargaDesde IS NULL OR  (F.[FechaCarga] between @FechaCargaDesde AND  @FechaCargaHasta)
  WHERE    @FechaCargaDesde IS NULL OR  (CONVERT(varchar(8), F.[FechaCarga], 112)  between CONVERT(varchar(8), @FechaCargaDesde, 112)  AND  CONVERT(varchar(8), @FechaCargaHasta, 112) )
  GROUP BY Year(F.FechaTicket), Month(F.FechaTicket),dbo.MES_Letras(F.FechaTicket),M.[Nombre],V.[Nombre],P.[Codigo], P.[Nombre],C.Nombre
  ORDER BY Year(F.FechaTicket), Month(F.FechaTicket),M.[Nombre],V.[Nombre],P.[Nombre]
  
END
GO
