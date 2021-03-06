SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaNegocio_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaNegocio_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentaNegocio_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PDVN.[Id]
	      ,PDVN.[IdPuntoDeVenta]
		  ,PDVN.[IdNegocio]
		  ,N.Nombre AS Negocio
	FROM [dbo].[PuntoDeVentaNegocio] PDVN
	INNER JOIN Negocio N ON (PDVN.[IdNegocio] = N.[IdNegocio])
	WHERE @IdPuntoDeVenta = PDVN.[IdPuntoDeVenta]
	ORDER BY N.Nombre

END
GO
