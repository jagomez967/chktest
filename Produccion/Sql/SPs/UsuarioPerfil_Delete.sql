SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioPerfil_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioPerfil_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[UsuarioPerfil_Delete]

        @IdUsuario int
              
AS

BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[UsuarioPerfil]
      WHERE @IdUsuario = [IdUsuario]



END
GO
