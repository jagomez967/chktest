SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferItem_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferItem_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferItem_Add]
	@IdTransfer int,
	@IdProductoPedido int,
	@Cantidad int

AS
	BEGIN
	INSERT INTO dbo.TransferItem
		(IdTransfer,
		 IdProductoPedido,		 
		 Cantidad)
		VALUES
		(@IdTransfer,
		 @IdProductoPedido,
		 @Cantidad)
	END
GO
