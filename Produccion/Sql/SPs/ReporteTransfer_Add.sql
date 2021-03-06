SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransfer_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransfer_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteTransfer_Add]
	
	@IdReporte int,
	@IdProductoPedido int,
	@IdDrogueria int,
	@Cantidad int


AS
	BEGIN 
		INSERT INTO dbo.ReporteTransfer
		(IdReporte,
		 IdProductoPedido,
		 IdDrogueria,
		 Cantidad)
		VALUES
		(@IdReporte,
		 @IdProductoPedido,
		 @IdDrogueria,
		 @Cantidad)
	END
GO
