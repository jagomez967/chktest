SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pop_getAll_marca]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[pop_getAll_marca] AS' 
END
GO
ALTER PROCEDURE [dbo].[pop_getAll_marca]
(
	@IdMarca	int
)
AS
BEGIN


SELECT p.idPop,p.nombre,p.Descripcion,p.idCliente,p.activo 
FROM pop_marca pm
inner join pop p on p.IdPop = pm.IdPop
WHERE pm.idMarca = @idMarca

END