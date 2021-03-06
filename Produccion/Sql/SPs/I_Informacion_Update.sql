SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_Informacion_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_Informacion_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[I_Informacion_Update]
	
	@IdInformacion int   
   ,@Titulo varchar(500)
   ,@Mensaje varchar(MAX) = NULL
   ,@Activo bit
   
AS
BEGIN
	SET NOCOUNT ON;


	UPDATE [dbo].[I_Informacion]
	   SET [Titulo] = @Titulo
		  ,[Mensaje] = @Mensaje
		  ,[FechaModificacion] = GETDATE()
		  ,[Activo] = @Activo
	 WHERE [IdInformacion] = @IdInformacion
           
END
GO
