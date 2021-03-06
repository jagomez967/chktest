SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sistema_GetUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Sistema_GetUsuario] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Sistema_GetUsuario]
	-- Add the parameters for the stored procedure here
	@IdUsuario int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT S.IdSistema
	      ,S.Nombre
	      ,S.Descripcion
	      ,S.Activo
	FROM [dbo].[UsuarioPerfil] UP 
	INNER JOIN [dbo].[Perfil] AS P ON (UP.[IdPerfil] = P.[IdPerfil])
	INNER JOIN [dbo].[Sistema] AS S ON (S.IdSistema = P.IdSistema)
	WHERE UP.IdUsuario = @IdUsuario
	GROUP BY  S.IdSistema, S.Nombre, S.Descripcion, S.Activo 

END
GO
