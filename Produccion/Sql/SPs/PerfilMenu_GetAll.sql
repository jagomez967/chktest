SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerfilMenu_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PerfilMenu_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[PerfilMenu_GetAll]
	
		@IdPerfil int = NULL
	   ,@IdSistema int = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [Menu].[IdMenu]
	  ,[Menu].[IdSistema]
      ,[Menu].[Nivel]
      ,[Menu].[Orden]
      ,[Menu].[Padre]
      ,[Menu].[Descripcion]
      ,[Menu].[Link]
      ,[Menu].[Alt]
      ,[Menu].[Img]
      ,[Menu].[Target]      
      ,[Menu].[Activo]
      ,CASE 
		WHEN [PerfilMenu].[IdPerfil] IS NULL  THEN 0
		ELSE 1
		END 
       AS PerfilSelecionado		
  FROM [dbo].[Menu] 
  LEFT JOIN [PerfilMenu] ON ([PerfilMenu].[IdMenu] =  [Menu].[IdMenu] AND (@IdPerfil = [PerfilMenu].[IdPerfil]))
  WHERE [Menu].[IdSistema] = @IdSistema AND 
	    [Menu].[Activo] = 1
  
END
GO
