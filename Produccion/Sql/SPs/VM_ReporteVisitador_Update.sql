SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_ReporteVisitador_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_ReporteVisitador_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_ReporteVisitador_Update]
	-- Add the parameters for the stored procedure here
	
	 @IdReporteVisitador int
	,@IdVisitadorMedico int = NULL
    ,@IdMedico int = NULL
    ,@IdCliente int = NULL
    ,@FechaAlta DateTime = NULL
    ,@Fecha DateTime = NULL
    ,@Observaciones varchar(MAX)= NULL
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
   UPDATE [dbo].[VM_ReporteVisitador]
   SET [IdVisitadorMedico] = @IdVisitadorMedico
      ,[IdMedico] = @IdMedico
      ,[FechaAlta] = @FechaAlta
      ,[Fecha] = @Fecha
      ,[IdCliente] = @IdCliente
      ,[Observaciones] = @Observaciones
 WHERE @IdReporteVisitador= [IdReporteVisitador]

END
GO
