SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Region_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Region_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Region_GetAll]
	
	@IdRegion int = NULL
   ,@Nombre varchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [IdRegion]
		  ,[Nombre]
		  ,[Activo]
  FROM [dbo].[CD_Region]
  WHERE (@IdRegion IS NULL OR @IdRegion = [IdRegion]) AND
		(@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
  ORDER BY [Nombre]
  
END
GO
