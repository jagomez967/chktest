SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetUsuariosDeCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetUsuariosDeCliente] AS' 
END
GO
ALTER procedure [dbo].[GetUsuariosDeCliente]
(
	@IdCliente	int
)
as
begin
	select	u.idusuario as IdUsuario
			,isnull(u.apellido,'') + ', ' + isnull(u.nombre,'') collate database_default as Nombreee
			,u.Imagen as Imagen
	from Usuario u
	inner join Usuario_Cliente uc on uc.IdUsuario=u.IdUsuario
	where	uc.IdCliente=@IdCliente
			and isnull(u.esCheckPos,0)=0
			and ISNULL(u.activo,0)=1
	order by Nombreee
end
GO
