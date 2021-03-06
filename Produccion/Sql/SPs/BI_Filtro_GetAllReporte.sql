SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BI_Filtro_GetAllReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[BI_Filtro_GetAllReporte] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[BI_Filtro_GetAllReporte]
	@IdBIReporte int
		
AS
BEGIN
	SET NOCOUNT ON;

	SELECT F.[IdBIFiltro]
      ,F.[IdBIFiltroTipo]
      ,F.[Nombre]
      ,ISNULL(F.[Alto],0) AS Alto
      ,ISNULL(F.[Ancho],0)AS Ancho
      ,ISNULL(F.[Control],'') AS [Control]
      ,F.[Activo]
      ,ISNULL(RF.Orden,99)
  FROM [dbo].[BI_Filtro] F
  INNER JOIN [dbo].[BI_Reporte_Filtro] RF ON (F.IdBIFiltro = RF.IdBIFiltro AND RF.IdBIReporte=@IdBIReporte)
  ORDER BY RF.Orden
  
END
GO
