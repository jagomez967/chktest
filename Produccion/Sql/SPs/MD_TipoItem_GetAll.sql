SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_TipoItem_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_TipoItem_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_TipoItem_GetAll]	
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdTipoItem]
		  ,[Codigo]
		  ,[Nombre]
		  ,[Activo]
	  FROM [dbo].[MD_TipoItem]
	  Order BY [Nombre]
	  
END
GO
