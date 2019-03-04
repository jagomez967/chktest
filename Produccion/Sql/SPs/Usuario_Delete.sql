SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_Delete]
	
	 @IdUsuario  int	
	
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM [dbo].[Usuario]    
	WHERE [IdUsuario] = @IdUsuario 
	
END
GO
