SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransfer_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransfer_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteTransfer_Delete]
	
	@IdReporte int
	
AS
	BEGIN 
		Delete dbo.ReporteTransfer
		WHERE IdReporte = @IdReporte
	END
GO
