SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Operacion_Usuario_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Operacion_Usuario_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Operacion_Usuario_Add]
	-- Add the parameters for the stored procedure here
    @IdOperacion int
   ,@IdUsuario int
   ,@Fecha DATETIME
   ,@Latitud DECIMAL(11,8)
   ,@Longitud DECIMAL(11,8)
   ,@Precision INT
   ,@Vejez DATETIME
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Operacion_Usuario]
           (IdOperacion
           ,IdUsuario
		   ,Fecha
		   ,Latitud
		   ,Longitud
		   ,Precision
		   ,Vejez)
     VALUES
           (@IdOperacion
           ,@IdUsuario
		   ,@Fecha
		   ,@Latitud
		   ,@Longitud
		   ,@Precision
		   ,@Vejez)

	exec [UsuarioGEO_Add]
	    @IdUsuario = @IdUsuario
		,@Fecha = @Fecha
		,@Latitud = @Latitud
		,@Longitud = @Longitud
END
GO
