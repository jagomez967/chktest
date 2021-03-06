SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Perfil_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[Perfil_Update]
	
	 @IdPerfil int  
	,@IdSistema int = NULL
	,@Descripcion varchar(100)
	,@Observaciones varchar(max) = NULL
	,@Activo bit
		
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Perfil]
	   SET [IdSistema] = @IdSistema
	      ,[Descripcion] = @Descripcion
		  ,[Observaciones] = @Observaciones
		  ,[Activo] = @Activo
	 WHERE [IdPerfil] = @IdPerfil 
	
END
GO
