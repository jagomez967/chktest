SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferProceso_Add]
	
	
	@IdDrogueria int,
	@Fecha DateTime,
	@IdEmpresa int,
	@IdTransferProceso int output


AS
	BEGIN 
		INSERT INTO dbo.TransferProceso
		(IdDrogueria,
		 Fecha,
		 IdEmpresa)
		VALUES
		(@IdDrogueria,
		 @Fecha,
		 @IdEmpresa)

		 SET @IdTransferProceso = @@identity
	END
GO
