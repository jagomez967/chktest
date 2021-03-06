SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Pregunta_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Pregunta_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[R2_Pregunta_Update]
	
	 @IdPregunta int
	,@Descripcion varchar(100)
    ,@IdTipoPregunta int
    ,@IdModulo int
    ,@Orden int = NULL
    ,@Activo bit
	
AS
BEGIN
	
	SET NOCOUNT ON;
    
	UPDATE [R2_Pregunta]
	   SET [Descripcion] = @Descripcion
		  ,[IdTipoPregunta] = @IdTipoPregunta
		  ,[IdModulo] = @IdModulo
		  ,[Orden] = @Orden
		  ,[Activo] = @Activo
	 WHERE @IdPregunta = [IdPregunta]

END
GO
