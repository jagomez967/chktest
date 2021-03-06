SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransferNumero_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransferNumero_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteTransferNumero_GetAll]
	-- Add the parameters for the stored procedure here
	@IdReporte int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdReporte]
		  ,[IdDrogueria]
		  ,[Id]
		  ,[Numero]
		  ,[VentaTelefonica]
	  FROM [dbo].[ReporteTransferNumero]
	  WHERE [IdReporte] =  @IdReporte
	  
END
GO
