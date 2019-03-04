SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransferCabecera_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransferCabecera_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteTransferCabecera_Update]
	-- Add the parameters for the stored procedure here
	   @IdReporteTransferCabecera int
      ,@IdEmpresa int
      ,@IdPuntoDeVenta int
      ,@IdUsuario int 
      ,@FechaCreacion datetime
      
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[ReporteTransferCabecera]
   SET [IdEmpresa] = @IdEmpresa
      ,[IdPuntoDeVenta] = @IdPuntoDeVenta
      ,[IdUsuario] = @IdUsuario
      ,[FechaCreacion] = @FechaCreacion
 WHERE @IdReporteTransferCabecera = [IdReporteTransferCabecera]

END
GO
