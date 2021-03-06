SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Perfil_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Perfil_Add]
	
	 @IdSistema int = NULL
	,@Descripcion varchar(100)
	,@Observaciones varchar(max) = NULL
	,@Activo bit
	,@IdPerfil int OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Perfil]
           ([IdSistema]
           ,[Descripcion]
           ,[Observaciones]
           ,[Activo])
     VALUES
           (@IdSistema
           ,@Descripcion
           ,@Observaciones
           ,@Activo)
           
     SELECT @IdPerfil = @@IDENTITY
	
END
GO
