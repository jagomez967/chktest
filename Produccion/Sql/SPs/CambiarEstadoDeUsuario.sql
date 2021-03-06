SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CambiarEstadoDeUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CambiarEstadoDeUsuario] AS' 
END
GO
ALTER procedure [dbo].[CambiarEstadoDeUsuario] 	
(
	@IdUsuario			int
	,@IdEstado			int
	,@FechaCreacion		datetime
	,@Latitud			varchar(20)
	,@Longitud			varchar(20)
)
as
begin
	insert EstadosLog (IdUsuario, IdEstado, FechaHora, Latitude, Longitude) values (@IdUsuario, @IdEstado, @FechaCreacion, @Latitud, @Longitud)

	update Usuario set UltimoEstadoSeleccionado = @IdEstado


	exec [UsuarioGEO_Add]
	    @IdUsuario = @IdUsuario
		,@Fecha = @FechaCreacion
		,@Latitud = @Latitud
		,@Longitud = @Longitud
end
GO
