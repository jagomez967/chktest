SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tags_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[tags_Add] AS' 
END
GO
ALTER procedure [dbo].[tags_Add]
(
	@IdCliente int = null,
	@Tabla varchar(100) = null,
	@Campos varchar(100) = null,
	@Valores varchar(100) = null,
	@Leyenda varchar(100) = null,
	@Activo bit = null,
	@Fecha DATETIME = null
)
as
begin
	
	insert into dbo.tags(idCliente, tabla, campos, valores, leyenda, activo, fecha)
	VALUES (@IdCliente, @Tabla, @Campos, @Valores, @Leyenda, @Activo, @Fecha)
	
end
GO
