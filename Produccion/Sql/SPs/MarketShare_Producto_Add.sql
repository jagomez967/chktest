SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_Producto_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_Producto_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_Producto_Add]
	-- Add the parameters for the stored procedure here
      @IdProducto int
     ,@IdMarketShare int 
     ,@Activo bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    IF NOT EXISTS (SELECT * FROM [dbo].[MarketShare_Producto] WHERE [IdProducto]=@IdProducto AND [IdMarketShare] = @IdMarketShare)
    BEGIN    
		INSERT INTO [dbo].[MarketShare_Producto]
			   ([IdProducto],[IdMarketShare],[Activo])
		 VALUES
			   (@IdProducto,@IdMarketShare,@Activo)
	END

END
GO
