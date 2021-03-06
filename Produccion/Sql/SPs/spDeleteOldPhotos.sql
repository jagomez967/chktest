SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spDeleteOldPhotos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spDeleteOldPhotos] AS' 
END
GO
-- =============================================
-- Author:		<Maximiliano Morena>
-- Create date: <23/09/2015>
-- Description:	<Elimina registros de fotos de reporte y fotos fisicas anteriores a 2 meses>
-- =============================================
ALTER PROCEDURE [dbo].[spDeleteOldPhotos]
AS
BEGIN
	DELETE FROM [dbo].[PuntoDeVentaFoto] WHERE FechaCreacion < DATEADD(month, -2, GETDATE())
END
GO
