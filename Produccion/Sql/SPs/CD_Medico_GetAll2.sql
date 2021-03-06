SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_GetAll2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_GetAll2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_GetAll2]
	-- Add the parameters for the stored procedure here
	@IdMedico int = NULL
   ,@Nombre varchar(255) = NULL
	
AS
BEGIN
	
	SET NOCOUNT ON;

    
	SELECT  M.[IdMedico]
 		   ,M.[NroMatriculaNacional]
		   ,M.[NroMatriculaProvincial]
		   ,M.[Nombre]
		   ,M.[Activo]
	FROM [dbo].[CD_Medico] M	
	WHERE (@IdMedico IS NULL OR @IdMedico = M.[IdMedico]) AND
		  (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	ORDER BY M.[Nombre]
END
GO
