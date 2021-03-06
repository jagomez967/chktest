SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_Update]
	
	@IdMedico int
   ,@NroMatriculaNacional varchar(50) = NULL
   ,@NroMatriculaProvincial varchar(50) = NULL
   ,@Nombre varchar(255) = NULL
   ,@Activo bit = NULL
      
AS
BEGIN
	SET NOCOUNT ON;

UPDATE [dbo].[CD_Medico]
   SET [NroMatriculaNacional] = @NroMatriculaNacional
      ,[NroMatriculaProvincial] = @NroMatriculaProvincial
      ,[Nombre] = @Nombre
      ,[Activo] = @Activo
 WHERE @IdMedico = [IdMedico]


END
GO
