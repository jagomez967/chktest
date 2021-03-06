SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdExhibidor int = NULL
	,@Nombre varchar(100) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdExhibidor]
		  ,[Nombre]
		  ,[Descripcion]
	FROM [dbo].[Exhibidor]
	WHERE (@IdExhibidor IS NULL OR @IdExhibidor = [IdExhibidor]) AND
	(@Nombre IS NULL OR [Nombre] like '%'+@Nombre+'%')
	ORDER BY [Nombre]
  
END
GO
