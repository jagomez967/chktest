SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_ReporteVisitador_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_ReporteVisitador_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_ReporteVisitador_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdReporteVisitador int = NULL
	,@IdVisitadorMedico int = NULL
    ,@IdMedico int = NULL
    ,@IdCliente int = NULL
    ,@FechaDesde DateTime = NULL
    ,@FechaHasta DateTime = NULL
    ,@FechaAlta DateTime = NULL
    ,@Fecha DateTime = NULL
    ,@Observaciones varchar(MAX)= NULL
    
    		  
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
		  ,VMM.Domicilio
		  ,VMM.Categoria
		  ,VMZ.Nombre AS ZonaNombre
	FROM [dbo].[VM_ReporteVisitador] VMR
	LEFT JOIN VM_VisitadorMedico VM ON (VMR.[IdVisitadorMedico] = VM.[IdVisitadorMedico])
	LEFT JOIN VM_Medico VMM ON (VMR.[IdMedico] = VMM.[IdMedico])
	LEFT JOIN VM_Zona VMZ ON (VMZ.IdZona = VMM.IdZona AND VMZ.IdCliente = @IdCliente)
	WHERE (@IdReporteVisitador IS NULL OR  VMR.[IdReporteVisitador] = @IdReporteVisitador) AND
		  (@IdVisitadorMedico IS NULL OR VMR.[IdVisitadorMedico] = @IdVisitadorMedico) AND
		  (@IdMedico IS NULL OR  VMR.[IdMedico] = @IdMedico) AND
		  (@IdCliente IS NULL OR VMR.[IdCliente] = @IdCliente) AND		  
		  (@FechaDesde IS NULL OR  CONVERT(varchar(8), VMR.[Fecha], 112)  between CONVERT(varchar(8), @FechaDesde, 112)  AND CONVERT(varchar(8), @FechaHasta, 112))
	ORDER BY VMR.[IdReporteVisitador] DESC
  
END
GO
