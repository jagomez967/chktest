SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_Delete]
    @IdPuntoDeVentaFoto int  
   
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [imagenesTags]
	WHERE [IdImagen] = @IdPuntoDeVentaFoto

   DELETE FROM [PuntoDeVentaFoto]
   WHERE [IdPuntoDeVentaFoto] = @IdPuntoDeVentaFoto
 

END

GO
