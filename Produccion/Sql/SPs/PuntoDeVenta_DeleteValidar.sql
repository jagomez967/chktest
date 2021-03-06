SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_DeleteValidar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_DeleteValidar] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_DeleteValidar] 
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
   ,@Result bit output
   
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CANTIDAD INT 
	SET @CANTIDAD  = 0
	SET @Result = 1

    -- BUscar todos los reportes que tenga ese punto de venta.
	SELECT @CANTIDAD = @CANTIDAD +  ISNULL(COUNT(1),0) FROM DermoReporte WHERE IdPuntoDeVenta=@IdPuntoDeVenta
	SELECT @CANTIDAD = @CANTIDAD + ISNULL(COUNT(1),0) FROM Reporte WHERE IdPuntoDeVenta=@IdPuntoDeVenta
	SELECT @CANTIDAD = @CANTIDAD + ISNULL(COUNT(1),0) FROM ReporteMantenimiento WHERE IdPuntoDeVenta=@IdPuntoDeVenta
	SELECT @CANTIDAD = @CANTIDAD + ISNULL(COUNT(1),0) FROM ReporteTransferCabecera WHERE IdPuntoDeVenta=@IdPuntoDeVenta

	IF @CANTIDAD > 0 SET @Result = 0
		
END
GO
