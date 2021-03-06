SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_Update] AS' 
END
GO
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_Update]
	-- Add the parameters for the stored procedure here
   
    @IdPuntoDeVenta int
   ,@IdUsuario int
   ,@FechaCreacion datetime
   ,@FechaActualizacion datetime = NULL
   ,@IdEmpresa int
   ,@AuditoriaNoAutorizada bit = NULL
   ,@Latitud Decimal(11,8) = NULL
   ,@Longitud Decimal(11,8) = NULL
   ,@Firma Varchar(Max) = NULL
   ,@IdReporte int     
      
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[Reporte]
    SET [IdPuntoDeVenta] = @IdPuntoDeVenta
       ,[IdUsuario] = @IdUsuario      
       ,[FechaCreacion] = DATEADD( day, DATEDIFF( day, [FechaCreacion], @FechaCreacion ), [FechaCreacion] ) 
       ,[FechaActualizacion] = GETDATE()
       ,[IdEmpresa] = @IdEmpresa
       ,[AuditoriaNoAutorizada] = @AuditoriaNoAutorizada
       ,[Latitud] = @Latitud
       ,[Longitud]  = @Longitud 
       ,[Firma] = @Firma       
	WHERE [IdReporte] = @IdReporte 
             
       
END
GO
