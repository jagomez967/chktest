SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioPerfil_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioPerfil_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[UsuarioPerfil_Add]

        @IdUsuario int
       ,@IdPerfil int
AS

BEGIN
	SET NOCOUNT ON;

    INSERT INTO [dbo].[UsuarioPerfil]
           ([IdUsuario]
           ,[IdPerfil])
     VALUES
           (@IdUsuario
           ,@IdPerfil)


END
GO
