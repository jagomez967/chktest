SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_Add]
	
	 @IdGrupo int = NULL
	,@Nombre varchar(50) = NULL
	,@Apellido varchar(50) = NUll
    ,@Usuario varchar(50) = NULL 
	,@Clave varchar(50) = NULL 	
	,@Email varchar(100)= NULL
	,@Telefono varchar(100)= NULL
	,@Comentarios varchar(200)= NULL
	,@CambioPassword bit = NULL
	,@Activo bit = NULL
	,@EsCheckPos bit = 0
	,@IdUsuario  int Output
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Usuario]
           ([Nombre]
           ,[IdGrupo]
           ,[Apellido]
           ,[Usuario]
           ,[Clave]
           ,[Email]
           ,[Telefono]
           ,[Comentarios]
           ,[CambioPassword]
           ,[Activo]
           ,[esCheckPos])
     VALUES
           (@Nombre
           ,2
           ,@Apellido
           ,@Usuario
           ,@Clave
           ,@Email
           ,@Telefono
           ,@Comentarios
           ,@CambioPassword
           ,@Activo
           ,@EsCheckPos)
           
     SELECT @IdUsuario = @@IDENTITY

END

GO
