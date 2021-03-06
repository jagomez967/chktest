SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_ArmarFoto]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_ArmarFoto] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_ArmarFoto]
	@IdPuntoDeVentaFoto int
	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Armar bit
	SET @Armar = 0

	SELECT @Armar = dbo.PuntoDeVentaFoto_Estado([IdPuntoDeVentaFoto],[Partes])
    FROM [dbo].[PuntoDeVentaFoto]
    WHERE  [IdPuntoDeVentaFoto] = @IdPuntoDeVentaFoto AND
           [Estado]=0 

	IF @Armar=1
	BEGIN
		UPDATE [dbo].[PuntoDeVentaFoto]
		SET  [Estado] = 1      
			--,[Foto] = dbo.PuntoDeVentaFoto_Armar(@IdPuntoDeVentaFoto)
		WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 
		
		--DELETE FROM [dbo].[PuntoDeVentaFotoParte]
		--WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 
	END

	SELECT PDVF.[Estado]
  		  ,dbo.PuntoDeVentaFoto_Armar(@IdPuntoDeVentaFoto) as Foto
     FROM [dbo].[PuntoDeVentaFoto] PDVF
     WHERE IdPuntoDeVentaFoto = @IdPuntoDeVentaFoto 


END
		                                                


GO
