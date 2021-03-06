SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Medico_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Medico_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Medico_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMedico int = NULL
   ,@IdSistema int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  M.[IdMedico]
 		   ,M.[NroMatriculaNacional]
		   ,M.[NroMatriculaProvincial]
		   ,M.[Nombre]
		   ,MS.[IdVisitador1]
		   ,MS.[IdVisitador2]
		   ,M.[Activo]
	FROM [dbo].[CD_Medico] M
	INNER JOIN CD_Medico_Sistema MS ON (MS.[IdMedico] = M.[IdMedico] AND  @IdSistema = MS.IdSistema AND MS.Activo=1)
	WHERE @IdMedico IS NULL OR @IdMedico = M.[IdMedico]
	ORDER BY M.[Nombre]
END
GO
