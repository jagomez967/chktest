SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransfer_GetAllDrogueria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransfer_GetAllDrogueria] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteTransfer_GetAllDrogueria]
	
	@IdEmpresa int,
	@IdReporte int,
	@IdDrogueria int

AS
	BEGIN

	SELECT         IdProductoPedido, Cantidad
	FROM            ReporteTransfer
	WHERE IdReporte = @IdReporte AND IdDrogueria = @IdDrogueria
	
	END
GO
