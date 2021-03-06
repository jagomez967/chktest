SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_ReporteVisitador_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_ReporteVisitador_Get] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_ReporteVisitador_Get]
	-- Add the parameters for the stored procedure here
	 @IdReporteVisitador int
    
    		  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT VMR.[IdReporteVisitador]
		  ,VMR.[IdVisitadorMedico]
		  ,VMR.[IdMedico]
		  ,VMR.[FechaAlta]
		  ,VMR.[Fecha]
		  ,VMR.[IdCliente]
		  ,VMR.[Observaciones]
		  ,VM.Apellido AS VisitadorMedicoNombre
		  ,VMM.Nombre AS MedicoNombre
	FROM [dbo].[VM_ReporteVisitador] VMR
	LEFT JOIN VM_VisitadorMedico VM ON (VMR.[IdVisitadorMedico] = VM.[IdVisitadorMedico])
	LEFT JOIN VM_Medico VMM ON (VMR.[IdMedico] = VMM.[IdMedico])
	WHERE (VMR.[IdReporteVisitador] = @IdReporteVisitador)
	
  
END
GO
