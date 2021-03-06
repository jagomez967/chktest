SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Vendedor_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Vendedor_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Vendedor_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PDVV.[IdPuntoDeVenta]
		  ,PDVV.[IdVendedor]
		  ,PDVV.[Id]
		  ,V.Nombre AS Vendedor
	  FROM [dbo].[PuntoDeVenta_Vendedor] PDVV
	  INNER JOIN Vendedor V ON (PDVV.[IdVendedor] = V.[IdVendedor])
	  WHERE PDVV.[IdPuntoDeVenta] = @IdPuntoDeVenta

END
GO
