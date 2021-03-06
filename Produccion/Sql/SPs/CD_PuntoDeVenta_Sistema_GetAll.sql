SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_Sistema_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_GetAll]
	
	@IdPuntoDeVenta int 
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT PDVS.[IdPuntoDeVenta_Sistema]
		  ,PDVS.[IdPuntoDeVenta]
		  ,PDVS.[IdSistema]
		  ,PDVS.[IdVisitador]
		  ,PDVS.[IdRepresentante]
		  ,PDVS.[Activo]
		  ,S.Nombre AS SistemaNombre
		  ,R.Nombre AS RepresentanteNombre
  FROM [dbo].[CD_PuntoDeVenta_Sistema] PDVS
  LEFT JOIN [dbo].[Sistema] S ON (PDVS.IdSistema = S.IdSistema)
  LEFT JOIN [dbo].[CD_Visitador] V ON (PDVS.IdVisitador  = V.IdVisitador)
  LEFT JOIN [dbo].[CD_Representante] R ON (R.IdRepresentante = PDVS.IdRepresentante)
  WHERE @IdPuntoDeVenta = PDVS.IdPuntoDeVenta
  
  
END
GO
