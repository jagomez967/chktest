SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ReporteModuloItem_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ReporteModuloItem_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ReporteModuloItem_GetAll]
	
	@IdModulo int
   ,@IdMarca int = NULL
   ,@IdReporte int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MI.[IdItem]
	      ,MI.[IdTipoItem] 
		  ,MI.[Nombre]
		  ,MI.[Orden]
		  ,MI.[LabelCampo1]
		  ,MI.[LabelCampo2]
		  ,MI.[LabelCampo3]
		  ,MI.[LabelCampo4]
		  ,MI.[Activo]
		  ,RM.Valor1
		  ,RM.Valor2
		  ,RM.Valor3
		  ,RM.Valor4
		  ,MMi.Obligatorio		  
	FROM [dbo].[MD_Item] MI
	--LEFT JOIN [dbo].[MD_ReporteModuloItem] RM ON (MI.IdItem = RM.IdItem AND (@IdReporte IS NULL OR @IdReporte = RM.IdReporte) AND (@IdMarca IS NULL OR @IdMarca = RM.IdMarca))
	LEFT JOIN [dbo].[MD_ReporteModuloItem] RM ON (MI.IdItem = RM.IdItem AND @IdReporte = RM.IdReporte AND @IdMarca = RM.IdMarca)
	LEFT JOIN [dbo].[MD_ModuloMarcaItem] MMI ON (MI.IdItem = MMI.IdItem AND @IdMarca = MMI.IdMarca)
	WHERE MI.IdModulo = @IdModulo AND MI.Activo=1
	ORDER BY MI.[Orden]
  
END
GO
