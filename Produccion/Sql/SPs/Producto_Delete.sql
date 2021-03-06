SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Producto_Delete]
	-- Add the parameters for the stored procedure here
   @IdProducto int 
      
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM [dbo].[ProductoCompetencia]
	WHERE @IdProducto = [IdProducto]

    DELETE FROM [dbo].[Producto]
	WHERE @IdProducto = [IdProducto]
	
END
GO
