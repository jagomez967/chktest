SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioGrupo_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioGrupo_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[UsuarioGrupo_Add]
	-- Add the parameters for the stored procedure here
 	 @IdUsuario int
	,@IdGrupo int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DELETE FROM [dbo].[UsuarioGrupo]
    WHERE [IdUsuario] = @IdUsuario AND 
          [IdGrupo] = @IdGrupo

    -- Insert statements for procedure here
	INSERT INTO [dbo].[UsuarioGrupo]
           ([IdUsuario]
           ,[IdGrupo])
    VALUES
           (@IdUsuario
           ,@IdGrupo)

END
GO
