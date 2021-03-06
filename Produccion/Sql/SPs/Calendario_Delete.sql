SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Calendario_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Calendario_Delete] AS' 
END
GO
ALTER procedure [dbo].[Calendario_Delete]
(
	@EventoId int,
	@IdUsuarioLogueado int
)
as
begin
	if(exists(select 1 from Usuario where IdUsuario = @IdUsuarioLogueado and PermiteModificarCalendario=1))
	begin
		delete from Calendario
		where Id=@EventoId
		and exists(Select 1 from Usuario_Cliente where IdCliente = Calendario.IdCliente and IdUsuario = @IdUsuarioLogueado)
	end
end
GO
