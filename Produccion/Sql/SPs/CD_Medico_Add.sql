SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Add]
	
    @NroMatriculaNacional varchar(50) = NULL
   ,@NroMatriculaProvincial varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@Activo bit = NULL
   ,@IdMedico int output
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_Medico]
           ([NroMatriculaNacional]
           ,[NroMatriculaProvincial]
           ,[Nombre]           
           ,[Activo])
     VALUES
           (@NroMatriculaNacional
           ,@NroMatriculaProvincial
           ,@Nombre
           ,@Activo)
                      
     SET @IdMedico = @@IDENTITY

END
GO
