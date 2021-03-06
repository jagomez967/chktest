SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Menu_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Menu_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Menu_GetAll]
	
	@IdMenu int = NULL
   ,@IdSistema int = NULL
		
AS
BEGIN
	SET NOCOUNT ON;
    
	SELECT [IdMenu]
		  ,[Nivel]
		  ,[Orden]
		  ,[Padre]
		  ,[Descripcion]
		  ,[Link]
		  ,[Alt]
		  ,[Img]
		  ,[Target]
		  ,[IdSistema]
	  FROM [dbo].[Menu]	  
	  WHERE (@IdMenu IS NULL OR @IdMenu = [IdMenu]) AND
			(@IdSistema IS NULL OR @IdSistema = [IdSistema]) 
	  
END
GO
