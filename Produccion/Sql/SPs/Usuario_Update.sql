SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_Update]

	@IdUsuario  int
	,@IdGrupo int = NULL
	,@Nombre varchar(50) = NULL
	,@Apellido varchar(50) = NUll
	,@Usuario varchar(50) = NULL 
	,@Clave varchar(50) = NULL 	
	,@Email varchar(100)= NULL
	,@Telefono varchar(100)= NULL
	,@Comentarios varchar(200)= NULL
	,@CambioPassword bit = 0
	,@Activo bit = 0
	,@Token varchar(50) = NULL
	,@EsCheckPos bit = 0
		
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Usuario]
       SET [Nombre] = @Nombre
		  ,[Apellido] = @Apellido
		  ,[Usuario] = @Usuario
		  ,[Clave] = @Clave
		  ,[Email] = @Email
		  ,[Telefono] = @Telefono
	   	  ,[Comentarios] = @Comentarios
		  ,[CambioPassword] = @CambioPassword
		  ,[Activo] = @Activo
		  ,[Token] = @Token
		  ,[esCheckPos] = @EsCheckPos
	 WHERE [IdUsuario] = @IdUsuario 
	
END


GO
