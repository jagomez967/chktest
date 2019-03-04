SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_enviarMailPR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_enviarMailPR] AS' 
END
GO
ALTER procedure [dbo].[sp_enviarMailPR]
(
	@GUID UNIQUEIDENTIFIER,
	@newStatus int,
	@Mensaje varchar(max) = '',
	@IdUsuario int)
AS 

BEGIN	

declare @usuario varchar(max) 

select @usuario = apellido + ', ' + nombre  collate database_default
from usuario where idUsuario  = @idUsuario 

declare @MailBody varchar(max)

	set @MailBody = '<!DOCTYPE html>'
	set @MailBody = @MailBody + '<html><head><title>Price Request Status Change</title><meta charset="utf-8">'
	set @MailBody = @MailBody + '<style type="text/css">'
	set @MailBody = @MailBody + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailBody = @MailBody + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailBody = @MailBody + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailBody = @MailBody + '.container{width: 100%;height: 100%;}'
	set @MailBody = @MailBody + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	set @MailBody = @MailBody + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	set @MailBody = @MailBody + 'h3{color:#FDA515;padding: 0;margin: 0;}'
	set @MailBody = @MailBody + 'p{padding:0;margin:0;}'
	set @MailBody = @MailBody + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;padding: 15px 50px 15px 50px;}'
	set @MailBody = @MailBody + 'table{width: 100%;}'
	set @MailBody = @MailBody + 'td{border-bottom: 1px #ddd solid;text-align: center}'
	set @MailBody = @MailBody + 'thead{text-align: left;}'
	set @MailBody = @MailBody + '</style>'
	set @MailBody = @MailBody + '</head>'
	set @MailBody = @MailBody + '<body>'
	set @MailBody = @MailBody + '<div class="container">'
	set @MailBody = @MailBody + '<div class="header">'
	set @MailBody = @MailBody + '<h1>Price Request</h1>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Usuario: </strong>'+ltrim(rtrim(isnull(@Usuario,'')))+'</p>'
	set @MailBody = @MailBody + '</div>'


	set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>Price Request: '+convert(varchar,@GUID)+'</h3>'
		set @MailBody = @MailBody + '<h3>Cambio el estado: '+ convert(varchar,@newStatus) + '</h3>'
		set @MailBody = @MailBody + '</div>'



	insert EmpresaMail (IdReporte	,MailFrom	,MailTo	 ,MailBody	,MailSubject	,MailAdjuntos
	,Autorizado		,UsuarioAutorizacion		,Enviado ,FechaCreacion
	,FechaAutorizacion	,FechaEnvio		,idAlerta)
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
				)
END
GO



