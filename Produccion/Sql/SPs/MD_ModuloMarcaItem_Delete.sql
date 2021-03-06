SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarcaItem_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarcaItem_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarcaItem_Delete]
	@IdMarca int
   ,@IdModulo int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;
    
	DELETE FROM [dbo].[MD_ModuloMarcaItem]
	FROM [dbo].[MD_ModuloMarcaItem] MMI
	INNER JOIN MD_Item I ON (I.IdItem = MMI.IdItem AND (@IdModulo IS NULL OR I.IdModulo = @IdModulo))
    WHERE @IdMarca = MMI.[IdMarca]

END
GO
