SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tags_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[tags_Update] AS' 
END
GO
ALTER procedure [dbo].[tags_Update]
(
	@IdTag int = null,
	@IdCliente int = null,
	@Tabla varchar(100) = null,
	@Campos varchar(100) = null,
	@Valores varchar(100) = null,
	@Leyenda varchar(100) = null,
	@Activo bit = null,
	@Fecha datetime = null
)
as
begin
	
	UPDATE dbo.tags
	SET tabla = @Tabla,
		campos = @Campos,
		valores = @Valores,
		leyenda = @Leyenda,
		activo = @Activo,
		fecha = @Fecha
	WHERE idTag = @IdTag
end
GO
