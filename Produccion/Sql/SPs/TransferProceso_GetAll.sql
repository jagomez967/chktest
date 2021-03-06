SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[TransferProceso_GetAll]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int
	,@IdTransferProceso int = NULL
	
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT T.[IdTransferProceso]
	      ,D.[IdDrogueria]
	      ,D.Nombre
	      ,TP.IdEmpresa
	      ,Count(1)	CantidadTransfer       
          ,TP.[Fecha]      
	FROM [dbo].[Transfer] T
	INNER JOIN [TransferProceso] TP ON (TP.[IdTransferProceso] = T.[IdTransferProceso] AND TP.IdEmpresa = @IdEmpresa  ) 
	INNER JOIN Drogueria D ON (TP.[IdDrogueria] = D.[IdDrogueria]) 
	WHERE (@IdTransferProceso IS NULL OR @IdTransferProceso = T.[IdTransferProceso])  
	GROUP BY  T.[IdTransferProceso],D.[IdDrogueria],D.Nombre,TP.IdEmpresa,TP.[Fecha],D.Nombre 
	
END
GO
