SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuariosAlertaProximidad_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuariosAlertaProximidad_add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[UsuariosAlertaProximidad_add]
	@idUsuario int,
	@fecha datetime,
	@snOut int,
	@linkMapa varchar(max),
	@idPuntoDeVenta int,
	@snShow			BIT
AS
BEGIN
	SET NOCOUNT ON;

	declare @orden int

	
	select @orden = orden + 1 
	from UsuariosAlertaProximidad 
	where idUsuario = @idUsuario
		and cast(fecha as date) = cast(@fecha as date)
		AND snShow = 1

	select @orden = isnull(@orden,1)

	IF @snShow = 0 BEGIN
		DELETE FROM UsuariosAlertaProximidad WHERE idUsuario = @IdUsuario AND CONVERT(VARCHAR(10),fecha,103) = CONVERT(VARCHAR(10),@Fecha,103) AND snShow = 0
	END

	insert UsuariosAlertaProximidad(idUsuario,fecha,esSalida,link,idPuntodeventa,orden,snShow)
	select @IdUsuario,@Fecha,@snOut,@linkMapa,@idPuntoDeVenta,CASE @snShow WHEN 1 THEN @orden ELSE NULL END,@snShow

END