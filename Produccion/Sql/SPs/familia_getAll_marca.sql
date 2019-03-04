SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[familia_getAll_marca]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[familia_getAll_marca] AS' 
END
GO
ALTER PROCEDURE [dbo].[familia_getAll_marca]
(
	@IdMarca	int
)
AS
BEGIN

SELECT idFamilia,idMarca,Nombre 
FROM familia 
WHERE idMarca = @idMarca

END