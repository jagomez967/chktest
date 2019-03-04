SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnviarMailPriceRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnviarMailPriceRequest] AS' 
END
GO
ALTER procedure [dbo].[EnviarMailPriceRequest]
(
	@GUID UNIQUEIDENTIFIER,
	@Estado int,
	@Mensaje varchar(max) = '',
	@IdUsuario int)
AS 
BEGIN	

DECLARE @EstadoAnterior int

select @EstadoAnterior = p.estado from PriceRequestHistory p 
where fecha = (select max(Fecha) from PriceRequestHistory where p.ID = ID)
and p.ID = @GUID  
---VERIFICAR QUE TIPO DE ALERTA PARA SABER A QUIEN CORRESPONDE

IF(@Estado = 1)
BEGIN
--- ESTADO 0 A 1: MAIL A ADMINISTRADOR, NUEVA SOLICITUD CREADA
	if(@EstadoAnterior <= 1)
	BEGIN
		exec EnviarMailPriceRequestNew @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
	END
	ELSE
--- ESTADO x A 1: MAIL A ADMINISTRADOR, SOLICITUD EDITADA
	BEGIN 
		exec EnviarMailPriceRequestEdited @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
	END
END
--- ESTADO 1 A 2: MAIL A PM, SOLICITUD APROBADA O RECHAZADA POR ADMIN
if(@Estado = 2)
BEGIN
	exec EnviarMailPriceRequestAdminApprove @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
END
if(@Estado = -2)
BEGIN
	exec EnviarMailPriceRequestAdminReject @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
END
--- ESTADO 2 A 3: MAIL A PM, SOLICITUD DESCARGADA
if(@Estado = 3)
BEGIN
	exec EnviarMailPriceRequestDownloaded @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
END
--- ESTADO 3 A 4: MAIL A PM, SOLICITUD APROBADA O RECHAZADA POR SEC
if(@Estado = 4)
BEGIN
	exec EnviarMailPriceRequestApproved @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
END
if(@estado = -4)
BEGIN
	exec EnviarMailPriceRequestRejected @GUID = @GUID, @Mensaje = @Mensaje, @IdUsuario = @IdUsuario
END

END
GO


