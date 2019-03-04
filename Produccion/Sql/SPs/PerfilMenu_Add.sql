SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerfilMenu_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PerfilMenu_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[PerfilMenu_Add]
	
	 @IdPerfil int
	,@IdMenu int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[PerfilMenu]
           ([IdPerfil]
           ,[IdMenu])
     VALUES
           (@IdPerfil
           ,@IdMenu)

END
GO
