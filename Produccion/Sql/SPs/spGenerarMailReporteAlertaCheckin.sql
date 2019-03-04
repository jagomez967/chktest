SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReporteAlertaCheckin]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReporteAlertaCheckin] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailReporteAlertaCheckin]
(
	
	@idAlerta int
)
as
begin

	declare @MailTo varchar(max)=''
	declare @MailBody varchar(max)=''
	declare @MailSubject varchar(200)=''
	declare @RTM varchar(150)=''
	declare @idCliente int
	declare @titulo varchar(max)
	declare @nombreCliente varchar(200)
	declare @fecha varchar(50)
	declare @cantidadUsuarios int
	declare @NombreUsuario varchar(300)
	declare @idusuario int
	declare @MailFrom varchar(100)='noreply@checkpos.com'
	declare @currentMarca int
	declare @difHoraria int 

	select @idCliente = idCliente,
	@titulo = isnull(Descripcion,'')
	from alertas where id = @idAlerta
	
	select @nombreCliente = nombre from cliente where idCliente = @idCliente
	select @MailSubject = LEFT(@titulo,199)
	
	select @fecha = convert(varchar(50),getdate(),106)
	
	select @difHoraria = isnull(DiferenciaHora,0)
	from cliente where idCliente = @idCLiente 
	
	select  @cantidadUsuarios = count(distinct u.idUsuario) 
    from Usuario u
	inner join EstadosLog l on l.IdUsuario=u.IdUsuario
	inner join Estados e on e.Id=l.IdEstado
    inner join usuario_cliente uc on uc.idUsuario = u.idUsuario
	and uc.idCliente = @idCliente
	and l.IdEstado = 1
	and CONVERT(VARCHAR(10), dateadd(HOUR,@difHoraria,l.createTS), 112) between CONVERT(VARCHAR(10), GETDATE(), 112) and CONVERT(VARCHAR(10), dateadd(HOUR,@difHoraria,l.createTS), 112)


	set @MailBody = '<!DOCTYPE html>'
	set @MailBody = @MailBody + '<html><head><title>'+@titulo+'</title><meta charset="utf-8">'
	set @MailBody = @MailBody + '<style type="text/css">'
	set @MailBody = @MailBody + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailBody = @MailBody + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailBody = @MailBody + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailBody = @MailBody + '.container{width: 100%;height: 100%;}'
	set @MailBody = @MailBody + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	set @MailBody = @MailBody + '.middle{margin: auto;width: 60%;height: 60px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
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
	set @MailBody = @MailBody + '<h1>'+@titulo+'</h1>'
	set @MailBody = @MailBody + '<h3>Cliente: ' +@NombreCliente+ '</h3>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Fecha: </strong>'+ltrim(rtrim(isnull(@fecha,'')))+'</p>'
	if (@CantidadUsuarios > 0 )
	BEGIN
		set @MailBody = @MailBody + '<p><strong>Cantidad de usuarios con Checkin: </strong>'+cast(@CantidadUsuarios as varchar)+'</p>'
	END
	ELSE
	BEGIN
		set @MailBody = @MailBody + '<p><strong>noreply@checkpos.com </strong></p>'
	END
	set @MailBody = @MailBody + '</div>'


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
	declare cur_usuarios cursor
	for
	select  u.idusuario,convert(varchar(50),dateadd(HOUR,@difHoraria,l.createTS),106) +' ' +CONVERT(VARCHAR,DATEPART(HOUR,dateadd(HOUR,@difHoraria,l.createTS)))+ ':' + CONVERT(VARCHAR,DATEPART(MINUTE,dateadd(HOUR,@difHoraria,l.createTS))) + ':'+
	CONVERT(VARCHAR,DATEPART(SECOND,dateadd(HOUR,@difHoraria,l.createTS))),  U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT
    from Usuario u
	inner join EstadosLog l on l.IdUsuario=u.IdUsuario
	inner join Estados e on e.Id=l.IdEstado
    inner join usuario_cliente uc on uc.idUsuario = u.idUsuario
	and uc.idCliente = @idCliente
	and l.IdEstado = 1
	and CONVERT(VARCHAR(10), dateadd(HOUR,@difHoraria,l.createTS), 112) between CONVERT(VARCHAR(10), GETDATE(), 112) and CONVERT(VARCHAR(10), dateadd(HOUR,@difHoraria,l.createTS), 112)
	
	open cur_usuarios
	fetch next from cur_usuarios
	into @idusuario,@fecha, @NombreUsuario
	
	if(@@FETCH_STATUS != 0)
	BEGIN
		close cur_usuarios
		deallocate cur_usuarios
		return
	END 
	
	set @MailBody = @MailBody + '<div class="data">'
	set @MailBody = @MailBody + '<h3>Usuarios: </h3>'
	set @MailBody = @MailBody + '<table><tbody>'

		
	
	while @@FETCH_STATUS = 0
	begin
		select @currentMarca = @idusuario

			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(@NombreUsuario,'')))+'</td>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(@fecha,'')))+'</td>'
			set @MailBody = @MailBody + '</tr>'
		
		fetch next from cur_usuarios into @idusuario,@fecha, @NombreUsuario		
	end
	
	set @MailBody = @MailBody + '</tbody></table></div>'
	
	close cur_usuarios
	deallocate cur_usuarios	




	if isnull(@MailFrom,'')<>'' and isnull(@MailBody,'')<>''
	begin
		insert EmpresaMail (IdReporte
								,MailFrom
								,MailTo
								,MailBody
								,MailSubject
								,MailAdjuntos
								,Autorizado
								,UsuarioAutorizacion
								,Enviado
								,FechaCreacion
								,FechaAutorizacion
								,FechaEnvio
								,idAlerta)
		values(-3
				,'noreply@checkpos.com'
				,null
				,@MailBody
				,@MailSubject
				,null
				,1
				,null
				,0
				,getdate()
				,getdate()
				,null
				,@idAlerta
				)
	end
end
GO
