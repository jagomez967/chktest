SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarcaItem_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarcaItem_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarcaItem_GetAll]	
	@IdModulo int
   ,@IdMarca int 
      
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MI.[IdItem]
	      ,MI.[IdTipoItem] 
	      ,TI.[Nombre] AS NombreTipoItem
		  ,MI.[Nombre]
		  ,MI.[Orden]
		  ,MI.[LabelCampo1]
		  ,MI.[LabelCampo2]
		  ,MI.[LabelCampo3]
		  ,MI.[LabelCampo4]
		  ,ISNULL(MM.Ponderacion,0) AS Ponderacion
		  ,MM.Activo
		  ,MM.Obligatorio
	FROM [dbo].[MD_Item] MI
	INNER JOIN [dbo].[MD_TipoItem] TI ON (TI.[IdTipoItem] = MI.[IdTipoItem]) 
	LEFT JOIN [dbo].[MD_ModuloMarcaItem] MM ON (MI.IdItem = MM.IdItem  AND (@IdMarca IS NULL OR @IdMarca = MM.IdMarca))
	WHERE MI.IdModulo = @IdModulo 
	ORDER BY MI.[Orden]
  
END
GO
