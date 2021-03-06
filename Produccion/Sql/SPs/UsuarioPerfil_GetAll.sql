SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioPerfil_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioPerfil_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[UsuarioPerfil_GetAll]
	
	@IdUsuario int = NULL
	
AS
BEGIN
	
	SET NOCOUNT ON;
    
    SELECT P.[IdPerfil] 
          ,P.[IdSistema]
		  ,P.[Descripcion]
          ,P.[Observaciones]
          ,P.[Activo]
          ,CASE 
			WHEN UP.[IdUsuario] IS NULL  THEN 0
			ELSE 1
			END 
		   AS Selecionado		
	FROM [dbo].[Perfil] P
    LEFT JOIN  [dbo].[UsuarioPerfil] UP ON (P.IdPerfil = UP.IdPerfil AND (@IdUsuario = UP.IdUsuario))
	GROUP BY P.[IdPerfil],P.[IdSistema] ,P.[Descripcion],P.[Observaciones],P.[Activo], UP.[IdUsuario]

  
END
GO
