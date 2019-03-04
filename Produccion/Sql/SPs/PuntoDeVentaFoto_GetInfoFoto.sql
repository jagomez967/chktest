SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_GetInfoFoto]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_GetInfoFoto] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_GetInfoFoto]
	@IdPuntoDeVentaFoto int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT PDVF.[Estado]
  		  ,PDVF.Comentario
		  ,PDVF.FechaCreacion
     FROM [dbo].[PuntoDeVentaFoto] PDVF
     WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 


END
		                                                



GO
