SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_GetAll]
	 @IdUsuario  int = NULL
	,@Nombre varchar(50) = NULL
	,@Apellido varchar(50) = NULL
	,@Email varchar(50) = NULL 
	,@Clave varchar(50) = NULL 
	,@Activo bit = NULL
	,@Token VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdUsuario] as IdUsuario
	      ,[IdGrupo] as IdGrupo
		  ,[Nombre] as Nombre
		  ,[Apellido] as Apellido
		  ,[Usuario] as Usuario
		  ,[Clave] as Clave
          ,[Email] as Email
          ,[Telefono] as Telefono
          ,[Comentarios] as Comentarios 
		  ,[CambioPassword] as CambioPassword
		  ,[Activo] as Activo
		  ,ISNULL([Apellido],'') + ', ' + ISNULL([Nombre],'') COLLATE DATABASE_DEFAULT  As NombreApellido
		  ,[DiferenciaHora] as DiferenciaHora
		  ,[DiferenciaMinutos] as DiferenciaMinutos
		  ,CASE 
		   WHEN [Activo] = 1 THEN 'SI' 			
			ELSE 'NO' 
		   END ActivoTexto
		   ,[Token] as Token
		   ,[Imagen] as Imagen
		   ,[PermiteModificarCalendario] as PermiteModificarCalendario
		   ,[UltimoEstadoSeleccionado] as UltimoEstadoSeleccionado
	  FROM [dbo].[Usuario]
	  WHERE (@IdUsuario IS NULL OR @IdUsuario = [IdUsuario]) AND
	        (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%' ) AND
	        (@Apellido IS NULL OR  [Apellido] like '%' + @Apellido + '%' ) AND
	        (@Email IS NULL OR @Email = [Email]  ) AND
	        (@Clave IS NULL OR @Clave = [Clave] ) AND
	        (@Activo IS NULL OR @Activo = [Activo]) AND
	        (@Token IS NULL OR @Token = [Token])
	  ORDER BY [Apellido] + ', ' + [Nombre] COLLATE DATABASE_DEFAULT
	  
END


GO
