SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Item_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Item_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Item_GetAll]
	-- Add the parameters for the stored procedure here
	@IdModulo int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I.[IdItem]
		  ,I.[IdModulo]
		  ,I.[IdTipoItem]
		  ,I.[Nombre]
		  ,I.[Orden]
		  ,I.[LabelCampo1]
		  ,I.[LabelCampo2]
		  ,I.[LabelCampo3]
		  ,I.[LabelCampo4]
		  ,I.[Activo]
		  ,TI.Nombre AS TipoItemNombre
		  ,I.IdProducto
		  ,P.Nombre AS NombreProducto
  FROM [dbo].[MD_Item] I
  INNER JOIN [dbo].[MD_TipoItem] TI ON (TI.IdTipoItem = I.IdTipoItem)
  LEFT JOIN [dbo].[Producto] P ON (I.IdProducto = P.IdProducto)
  WHERE [IdModulo]=@IdModulo
  ORDER BY [Orden]
END
GO
