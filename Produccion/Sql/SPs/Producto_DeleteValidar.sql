SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_DeleteValidar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_DeleteValidar] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Producto_DeleteValidar]
	@IdProducto int
   ,@Result bit output
	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CANTIDAD INT 
	SET @CANTIDAD  = 0
	SET @Result = 1
	
	SELECT @CANTIDAD = @CANTIDAD + ISNULL(COUNT(1),0) FROM [dbo].[ReporteProducto] WHERE IdProducto = @IdProducto
	SELECT @CANTIDAD = @CANTIDAD + ISNULL(COUNT(1),0) FROM [dbo].[ReporteProductoCompetencia] WHERE IdProducto = @IdProducto

	IF @CANTIDAD > 0 SET @Result = 0

END
GO
