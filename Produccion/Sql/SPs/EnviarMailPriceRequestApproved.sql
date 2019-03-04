SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnviarMailPriceRequestApproved]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnviarMailPriceRequestApproved] AS' 
END
GO
ALTER procedure [dbo].[EnviarMailPriceRequestApproved]
(
	@GUID UNIQUEIDENTIFIER,
	@Mensaje varchar(max) = '',
	@IdUsuario int)
AS 
BEGIN

declare @usuario varchar(max) 

select @usuario = apellido + ', ' + nombre  collate database_default
from usuario where idUsuario  = @idUsuario 

declare @MailHeader varchar(max)
declare @MailBody varchar(max) = ' '
declare @ID int
declare @Pais varchar(max)
declare @Producto varchar(max)

	select @ID = p.IdNumeric, @Pais = c.Nombre 
	from priceREquest p 
	inner join cliente c
		on c.idCliente = p.idCliente
	where p.ID = @GUID

	select @Producto = p.nombre 
	from PriceRequestDetail  pr
	inner join producto p on p.idProducto = pr.idProducto
	where pr.id = @GUID

	EXEC PriceRequestMailHeader @Titulo = 'La solicitud de baja de precio fue aprobada por SEC', @Usuario = @usuario, @MailHeader = @MailHeader OUTPUT

	set @MailBody = '<div class="data">'
	set @MailBody = @MailBody + '<strong>Price Request: </strong> '
	set @MailBody = @MailBody + '<p><strong>Id: </strong>'+ convert(varchar,@ID) +'</p>'	
	set @MailBody = @MailBody + '<p><strong>Producto: '+ @Producto+'</strong></p>'

	set @MailBody = @MailBody + '</div>'

	---DEBO BUSCAR EN LAS ALERTAS AQUELLAS QUE SEAN DEL TIPO EPSON PRICE REQUEST
	--- SI NO EXISTE, ENTONCES DEBERIA CREAR UNA NUEVA CON EL MAIL DEL TIPO QUE GENERO EL PRICE REQUEST (O SEA, EL PM)
	declare @idAlerta int
	declare @MailDestinatario varchar(max)

	select @MailDestinatario = email
	from usuario u
	inner join PriceRequest p
		on p.IdUsuario = u.IdUsuario
	where p.ID = @GUID

	select @idAlerta = id
	From alertas where TipoReporteSeleccionado = 'pricerequest'
	and Destinatarios like '%' + @MailDestinatario + '%'
	and activo = 1 
	if(@@ROWCOUNT<=0)
	BEGIN
		EXEC @idAlerta = GenerarNuevaAlertaPriceRequest @Destinatario = @MailDestinatario
	END

	insert EmpresaMail (IdReporte	,MailFrom	,MailTo	 ,MailBody	,MailSubject	,MailAdjuntos
	,Autorizado		,UsuarioAutorizacion		,Enviado ,FechaCreacion
	,FechaAutorizacion	,FechaEnvio		,idAlerta, MailHeader)
		values(-1
				,'noreply@checkpos.com'
				,null
				,@MailBody
				,'Price Request Alert'
				,null
				,1
				,null
				,0
				,getdate()
				,getdate()
				,null
				,@idAlerta
				,@MailHeader
				)
END