SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SegmentoVisitas_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SegmentoVisitas_PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SegmentoVisitas_PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdSegmentoVisitas int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT SPDV.[Id]
		  ,SPDV.[IdSegmentoVisitas]
		  ,SPDV.[IdPuntoDeVenta]
		  ,PDV.Nombre
		  ,PDV.Codigo
		  ,PDV.[Direccion]
	FROM [dbo].[SegmentoVisitas_PuntoDeVenta] SPDV
	INNER JOIN PuntoDeVenta PDV ON (PDV.[IdPuntoDeVenta] = SPDV.[IdPuntoDeVenta]) 
	WHERE SPDV.[IdSegmentoVisitas] = @IdSegmentoVisitas
	ORDER BY PDV.Nombre
	
END
GO
