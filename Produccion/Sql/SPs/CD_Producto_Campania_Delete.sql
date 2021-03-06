SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_Campania_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_Campania_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_Campania_Delete]
    @IdProducto int
   ,@IdCampania int
   
AS
BEGIN
	
	SET NOCOUNT ON;
    
	DELETE FROM [dbo].[CD_Producto_Campania]
	WHERE [IdProducto] = @IdProducto AND
	      [IdCampania] = @IdCampania

END
GO
