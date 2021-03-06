SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_Informacion_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_Informacion_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[I_Informacion_Add]
	    
    @Titulo varchar(500)
   ,@Mensaje varchar(MAX) = NULL
   ,@Activo bit
   ,@IdInformacion int output
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[I_Informacion]
           ([Titulo]
           ,[Mensaje]
           ,[FechaAlta]
           ,[FechaModificacion]
           ,[Activo])
     VALUES
           (@Titulo
           ,@Mensaje
           ,GETDATE()
           ,GETDATE()
           ,@Activo)
           
	SET @IdInformacion =@@Identity
END
GO
