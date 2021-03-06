SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Reporte_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Reporte_Update] AS' 
END
GO
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Reporte_Update]
	-- Add the parameters for the stored procedure here
   
    @IdPuntoDeVenta int
   ,@IdUsuario int
   ,@FechaCreacion datetime
   ,@FechaActualizacion datetime = NULL
   ,@IdEmpresa int
   ,@AuditoriaNoAutorizada bit = NULL
   ,@ResponsableDermo1 varchar(100) = NULL
   ,@IdResponsableDermo1 int = NULL
   ,@ResponsableDermo2 varchar(100) = NULL
   ,@IdResponsableDermo2 int = NULL
   ,@IdReporte2 int  
   
      
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[R2_Reporte]
    SET [IdPuntoDeVenta] = @IdPuntoDeVenta
       ,[IdUsuario] = @IdUsuario      
       ,[FechaCreacion] = @FechaCreacion 
       ,[FechaActualizacion] = GETDATE()
       ,[IdEmpresa] = @IdEmpresa
       ,[AuditoriaNoAutorizada] = @AuditoriaNoAutorizada
       ,[ResponsableDermo1] = @ResponsableDermo1
       ,[IdResponsableDermo1] = @IdResponsableDermo1
       ,[ResponsableDermo2] = @ResponsableDermo2
       ,[IdResponsableDermo2] = @IdResponsableDermo2
	WHERE [IdReporte2] = @IdReporte2 
             
       
END
GO
