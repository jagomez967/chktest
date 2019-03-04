SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EnviarMailPriceRequestNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EnviarMailPriceRequestNew] AS' 
END
GO
ALTER procedure [dbo].[EnviarMailPriceRequestNew]
(
	@GUID UNIQUEIDENTIFIER,
	@Mensaje varchar(max) = '',
	@IdUsuario int)
AS 
BEGIN

	
declare @usuario varchar(max) 

declare @MailBody varchar(max) = ' '
declare @ID int
declare @Pais varchar(max)
declare @Producto varchar(max)
declare @MailHeader varchar(max)


	select @usuario = apellido + ', ' + nombre  collate database_default
	from usuario where idUsuario  = @idUsuario 
	
	select @ID = p.IdNumeric, @Pais = c.Nombre 
	from priceREquest p 
	inner join cliente c
		on c.idCliente = p.idCliente
	where p.ID = @GUID

	select @Producto = p.nombre 
	from PriceRequestDetail  pr
	inner join producto p on p.idProducto = pr.idProducto
	where pr.id = @GUID

	EXEC PriceRequestMailHeader @Titulo = 'Se Creo nueva solicitud de baja de precio', @Usuario = @usuario, @MailHeader = @MailHeader OUTPUT

	set @MailBody = @MailBody + '<div class="data">'
	set @MailBody = @MailBody + '<strong>Price Request: </strong> '
	set @MailBody = @MailBody + '<p><strong>Pais: </strong>'+ convert(varchar,@Pais) +'</p>'
	set @MailBody = @MailBody + '<p><strong>Id: </strong>'+ convert(varchar,@ID) +'</p>'
	set @MailBody = @MailBody + '<p><strong>Producto: '+ @Producto +'</strong></p>'
	set @MailBody = @MailBody + '</div>'

	---POR AHORA ME DEJO A MI EN LA ALERTA, PERO DEBERIA BUSCAR EL ADMIN, Y SI ESTE NO TIENE UNA ALERTA ASIGNADA ENTONCES GENERO UNA NUEVA..
	--SOLO PARA EL ADMIN REGIONAL??
	
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
				,1074
				,@MailHeader
				)
END