SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_TipoPregunta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_TipoPregunta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_TipoPregunta_GetAll]
	@IdTipoPregunta int = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdTipoPregunta]
		  ,[Descripcion]
		  ,[Si]
		  ,[No]
		  ,[Observaciones]
		  ,[Activo]
	FROM [dbo].[R2_TipoPregunta]
	WHERE (@IdTipoPregunta IS NULL OR @IdTipoPregunta = [IdTipoPregunta])
	
	
END
GO
