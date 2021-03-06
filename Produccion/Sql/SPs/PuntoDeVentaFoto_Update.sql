SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_Update]
    @IdPuntoDeVentaFoto int
   ,@Comentario varchar(500) = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

   UPDATE [dbo].[PuntoDeVentaFoto]
   SET [Comentario] = @Comentario      
   WHERE [IdPuntoDeVentaFoto] = @IdPuntoDeVentaFoto
 

END


GO
