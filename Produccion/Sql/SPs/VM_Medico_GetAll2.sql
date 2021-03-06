SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Medico_GetAll2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Medico_GetAll2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Medico_GetAll2]
	-- Add the parameters for the stored procedure here
	 @IdMedico int = NULL
	,@IdCliente int = NULL
	,@IdVisitadorMedico int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT M.[IdMedico]
	      ,M.[IdCliente]
		  ,M.[Nombre]
		  ,M.[Domicilio]
		  ,M.[IdZona]
		  ,M.[IdLocalidad]
		  ,M.[LocalidadOriginal]
		  ,M.[CodigoPostal]
		  ,M.[Matricula]
		  ,M.[Categoria]
		  ,M.[Telefono]
		  ,M.[Email]
		  ,M.[Especialidad]
  FROM [dbo].[VM_Medico] M  
  INNER JOIN VM_VisitadorMedicoMedico VMM ON (M.[IdMedico] = VMM.[IdMedico] AND  (@IdVisitadorMedico IS NULL OR @IdVisitadorMedico = VMM.[IdVisitadorMedico]) )
  WHERE (@IdMedico IS NULL OR @IdMedico = M.[IdMedico]) AND
        (@IdCliente IS NULL OR @IdCliente = [IdCliente]) 
  GROUP BY M.[IdMedico],M.[IdCliente],M.[Nombre],M.[Domicilio],M.[IdZona],M.[IdLocalidad],M.[LocalidadOriginal],M.[CodigoPostal],M.[Matricula],M.[Categoria],M.[Telefono],M.[Email],M.[Especialidad]
  ORDER BY [Nombre]
  
END
GO
