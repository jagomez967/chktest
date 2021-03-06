SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioGrupo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioGrupo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[UsuarioGrupo_GetAll]
	-- Add the parameters for the stored procedure here
	@IdUsuario int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UG.[IdUsuario]
	      ,UG.[IdGrupo]
	      ,G.Nombre
	FROM [dbo].[UsuarioGrupo] UG
	INNER JOIN Grupo G ON (UG.IdGrupo = G.IdGrupo)
	WHERE UG.[IdUsuario] = @IdUsuario

END
GO
