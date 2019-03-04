SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[exhibidor_getAll_marca]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[exhibidor_getAll_marca] AS' 
END
GO
ALTER PROCEDURE [dbo].[exhibidor_getAll_marca]
(
	@IdMarca	int
)
AS
BEGIN

SELECT e.IdExhibidor,e.Nombre,e.Descripcion,e.IdCliente
FROM Exhibidor_marca em
inner join Exhibidor e
on e.IdExhibidor = em.IdExhibidor
WHERE em.idMarca = @idMarca

END