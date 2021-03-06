SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePerfilUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdatePerfilUsuario] AS' 
END
GO
ALTER procedure [dbo].[UpdatePerfilUsuario]
(
	@IdUsuario	int,
	@Nombre varchar(50),
	@Apellido varchar(50),
	@ImagenPerfil varchar(max)
)
as
begin
	update Usuario set Nombre = @Nombre, @Apellido=@Apellido, Imagen=@ImagenPerfil
	where IdUsuario=@IdUsuario

end
GO
