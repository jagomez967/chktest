SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Perfil_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[Perfil_Delete]
	
	 @IdPerfil int  
		
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM .[dbo].[Perfil]      
	WHERE [IdPerfil] = @IdPerfil 
	
END
GO
