SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Menu_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Menu_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Menu_GetAll]
	-- Add the parameters for the stored procedure here
	@IdGrupo int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT M.[IdMenu]
		  ,M.[Selectable]
		  ,M.[NavigateUrl]
		  ,M.[ToolTip]
		  ,M.[Valor]
		  ,M.[Orden]
		  ,M.[Texto]
		  ,M.[IdParentMenuItem]
	  FROM [dbo].[CD_Menu] M	  
	  INNER JOIN  dbo.CD_Grupo_Menu GM ON (GM.IdMenu = M.IdMenu AND @IdGrupo= GM.IdGrupo)
  
END
GO
