SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Menu_GetAll_Usuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Menu_GetAll_Usuario] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Menu_GetAll_Usuario]
	
	 @IdUsuario int
	,@IdSistema int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    
	SELECT M.[IdMenu]
		  ,M.[Nivel]
		  ,M.[Orden]
		  ,M.[Padre]
		  ,M.[Descripcion]
		  ,M.[Link]
		  ,M.[Alt]		  
		  ,M.[Target]
		  ,M.[IdSistema]
		  ,M.[Activo]
  FROM [dbo].[Menu] AS M
  INNER JOIN dbo.UsuarioPerfil AS US ON (US.[IdUsuario] = @IdUsuario)
  INNER JOIN  dbo.PerfilMenu AS PM ON (PM.IdPerfil = US.IdPerfil AND PM.IdMenu = M.IdMenu)
  WHERE (M.IdSistema = @IdSistema) AND M.Activo = 1
  GROUP BY M.[IdMenu],M.[Nivel],M.[Orden],M.[Padre],M.[Descripcion],M.[Link],M.[Alt],M.[Target],M.[IdSistema],M.[Activo]
  
END
GO
