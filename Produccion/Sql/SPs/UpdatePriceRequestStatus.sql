


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePriceRequestStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UpdatePriceRequestStatus] AS' 
END
GO
ALTER procedure [dbo].[UpdatePriceRequestStatus]
(
	@GUID UNIQUEIDENTIFIER,
	@newStatus int,
	@idUsuario int = null,
	@Mensaje varchar(max) = '')
AS 

BEGIN
	
	declare @rows int

	UPDATE PriceRequest
	set estadoPr = @newStatus
	where ID = @GUID
	--and (estadoPR = @newStatus - 1) --Solo se puede avanzar un paso //NO MAS

	select @rows = @@IDENTITY
	if @rows <= 0
	BEGIN
		  RAISERROR ('NO SE PUDO CAMBIAR ESTADO',16,1)
	END

	insert PriceRequestHistory(ID,Fecha,IdUsuario,Estado,Comentario)
	values (@GUID,Getdate(),@IdUsuario,@newStatus,@Mensaje)

END
GO



