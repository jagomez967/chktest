SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cliente_PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CPDV.[IdCliente]
		  ,CPDV.[IdPuntoDeVenta]
	      ,CPDV.[Id]
	      ,C.Nombre AS Cliente
	FROM [dbo].[Cliente_PuntoDeVenta] CPDV
	INNER JOIN Cliente C ON  (C.[IdCliente] = CPDV.[IdCliente])
	WHERE @IdPuntoDeVenta = [IdPuntoDeVenta]

END
GO
