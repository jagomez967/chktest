SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[md_modulo_getAll_marca]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[md_modulo_getAll_marca] AS' 
END
GO
ALTER PROCEDURE [dbo].[md_modulo_getAll_marca]
(
	@IdMarca	int

)
AS
BEGIN


SELECT m.idModulo,m.nombre,m.descripcion,m.fechaAlta,m.fechaUltimaModificacion,m.activo,m.idCliente
FROM md_modulo m
inner join md_moduloMarca mm on mm.idModulo = m.IdModulo
WHERE mm.idMarca = @idMarca
END