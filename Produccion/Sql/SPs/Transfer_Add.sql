SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Transfer_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Transfer_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Transfer_Add]
	@IdReporte int,
	@IdTransferProceso int,
	@IdTransfer int output


AS
	BEGIN 
		INSERT INTO dbo.Transfer
		(IdReporte,
		 IdTransferProceso)
		VALUES
		(@IdReporte,
		 @IdTransferProceso)

		 SET @IdTransfer = @@identity
	END
GO
