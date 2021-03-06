SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Calendario_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Calendario_update] AS' 
END
GO
ALTER procedure [dbo].[Calendario_update]
(
	@Id int,
	@IdCliente int,
	@IdPuntoDeVenta int,
	@IdUsuario int,
	@FechaInicio datetime,
	@IdUsuarioLogueado int,
	@ConceptoId int=null,
	@Observaciones varchar(2000)=null
)
as
begin
	
	if(exists(select 1 from Usuario where IdUsuario = @IdUsuarioLogueado and PermiteModificarCalendario=1))
	begin
		create table #usuariosDeCliente (IdUsuario int)

		insert #usuariosDeCliente (IdUsuario)
		select IdUsuario from Usuario_Cliente where IdCliente = @IdCliente

		if (exists(select 1 from #usuariosDeCliente where IdUsuario = @IdUsuario)
			and exists(select 1 from #usuariosDeCliente where IdUsuario = @IdUsuarioLogueado))
		begin
			if( @Id>0
				and exists(select 1 from usuario_cliente where idcliente = @idcliente and idusuario = @idusuario)
				and exists(select 1 from usuario_puntodeventa where idusuario = @idusuario and idpuntodeventa = @idpuntodeventa))
			begin
				Update Calendario
				set IdPuntoDeVenta = @IdPuntoDeVenta
					,IdUsuario = @IdUsuario
					,IdCliente = @IdCliente
					,FechaInicio = @FechaInicio
					,ConceptoId = @ConceptoId
					,Observaciones = @Observaciones
				where Id = @Id
			end
		end
	end
end
GO
