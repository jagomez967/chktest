SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int = NULL
   ,@IdSistema int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT PDV.[IdPuntoDeVenta]
		  ,PDV.[Codigo]
		  ,PDV.[Nombre]
		  ,PDV.[Direccion]
		  ,PDV.[IdCadena]
		  ,PDV.[IdPuntoDeVentaMKT]
		  ,PDV.[IdRegion]
		  ,PDVS.[IdVisitador]
		  ,PDVS.[IdRepresentante]
		  ,PDV.[Activo]
		  ,PDV.Nombre + ' - ' + PDV.Codigo AS NombreCodigo		  
	  FROM [dbo].[CD_PuntoDeVenta] PDV
	  INNER JOIN [dbo].[CD_Region] R ON (R.[IdRegion] = PDV.[IdRegion]  AND R.Activo = 1)
	  INNER JOIN [dbo].[CD_PuntoDeVenta_Sistema] PDVS ON (PDV.[IdPuntoDeVenta] = PDVS.[IdPuntoDeVenta] AND @IdSistema = PDVS.[IdSistema])
	  WHERE @IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.[IdPuntoDeVenta]
	  ORDER BY PDV.[Nombre]
	
END
GO
