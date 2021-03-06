SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Propiedad_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Propiedad_PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Propiedad_PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PPDV.[IdPuntoDeVenta]
		  ,PPDV.[IdPropiedad]
		  ,PPDV.[Id]
		  ,P.Nombre AS Propiedad
	FROM [dbo].[Propiedad_PuntoDeVenta] PPDV
	INNER JOIN Propiedad P ON (P.[IdPropiedad] = PPDV.[IdPropiedad])
	WHERE PPDV.[IdPuntoDeVenta] = @IdPuntoDeVenta
	ORDER BY P.Nombre


END
GO
