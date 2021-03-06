SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Grupo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Grupo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Grupo_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdGrupo int =  NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdGrupo]
	      ,[Nombre]
		  ,[Descripcion]
  FROM [dbo].[Grupo]
  WHERE (@IdGrupo IS NULL OR @IdGrupo = [IdGrupo]) 
  AND (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%') 

END
GO
