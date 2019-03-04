SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[producto_getAll_familia]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[producto_getAll_familia] AS' 
END
GO
ALTER PROCEDURE [dbo].[producto_getAll_familia]
(
	@IdFamilia	int
)
AS
BEGIN

SELECT idProducto,idMarca,Nombre,reporte,idFamilia,codigoBarras,orden,idCategoria,idExterno,imagen
FROM producto
WHERE idFamilia = @idFamilia

END


