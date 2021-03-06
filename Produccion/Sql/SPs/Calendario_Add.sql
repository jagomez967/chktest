SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Calendario_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Calendario_Add] AS' 
END
GO
ALTER procedure [dbo].[Calendario_Add]
(
	@IdCliente int,
	@IdPuntoDeVenta int,
	@IdUsuario int,
	@FechaInicio datetime,
	@IdUsuarioLogueado int,
	@Id int output,
	@ConceptoId int=null,
	@Observaciones varchar(2000)=null
)
as
begin
	if(exists(select 1 from Usuario where IdUsuario = @IdUsuarioLogueado and PermiteModificarCalendario=1))
	begin
		insert Calendario (IdCliente, IdUsuario, IdPuntoDeVenta, FechaInicio, ConceptoId, Observaciones)
		select uc.idcliente, uc.idusuario, @IdPuntoDeVenta, @FechaInicio, @ConceptoId, @Observaciones
		from Usuario_Cliente uc
		where uc.idcliente = @IdCliente and uc.idUsuario = @IdUsuario
		and exists(select 1 from Usuario_PuntoDeVenta where Usuario_PuntoDeVenta.IdUsuario = uc.IdUsuario and Usuario_PuntoDeVenta.IdPuntoDeVenta = @IdPuntoDeVenta)
		and exists(select 1 from Usuario_Cliente where Usuario_Cliente.IdCliente = uc.IdCliente and uc.IdUsuario = @IdUsuarioLogueado)

		set @Id = SCOPE_IDENTITY()
	end
end
GO
