SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailAlertaReportePorUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailAlertaReportePorUsuario] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailAlertaReportePorUsuario]
(
	@IdAlerta int
)
as
begin

	declare @MailFrom varchar(100)='noreply@checkpos.com'
	declare @MailBody varchar(max)=''
	declare @MailHeader varchar(max) = ''
	declare @MailFooter varchar(100) = ''
	declare @MailSubject varchar(200) =''
	declare @titulo varchar(200) = ''
	declare @idCliente int
	declare @nombreCliente varchar(200)
	declare @fecha varchar(50)
	declare @cantidadUsuarios int
	declare @puntosdeventa varchar(max)
	declare @usuariosConRepo int

	select @titulo = left(isnull(descripcion,''),199), @idCliente = idCliente, @puntosdeventa = puntosdeventa
	From alertas where id= @idAlerta
	
	select @nombreCliente = nombre from cliente where idCliente = @idCliente

	set @MailSubject = @nombreCliente + ' - ' +@titulo
	
	
	select @cantidadUsuarios = count(distinct uc.idUsuario) 
	from usuario_cliente uc
	inner join usuario_puntodeventa up on up.idUsuario = uc.idUsuario
	inner join puntodeventa pdv on pdv.idPuntodeventa = up.idPuntodeventa 
	inner join usuarioGrupo ug on ug.idUsuario	= uc.idUsuario
	where uc.idCliente = @idCliente
	and up.activo = 1 
	and pdv.idCliente = @idCliente
	and pdv.idPuntodeventa in (select clave from dbo.fnSplitString(@puntosDeVenta,','))
	and ug.IdGrupo = 2

	select @fecha = convert(varchar(50),getdate(),106)
	
	
	select @UsuariosConRepo = count(distinct r.idUsuario)
	from reporte R
	where r.idEmpresa = (select idEmpresa from cliente where idCLiente = @idCliente)
	and r.idPuntodeventa in (select clave from dbo.fnSplitString(@puntosDeVenta,','))
	and cast(r.fechaCreacion as date) = cast(@fecha as date)
	

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>'+ @titulo +'</title><meta charset="utf-8">'
	set @MailHeader = @MailHeader + '<style type="text/css">'
	set @MailHeader = @MailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}'
	set @MailHeader = @MailHeader + 'body{height: 100%;width: 100%;padding:20px;}'
	set @MailHeader = @MailHeader + 'h1{color: #ffffff;padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.container{width: 100%;height: 100%;}'
	set @MailHeader = @MailHeader + '.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}'
	set @MailHeader = @MailHeader + '.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}'
	set @MailHeader = @MailHeader + 'h3{color:#FDA515;padding: 0;margin: 0;}'
	set @MailHeader = @MailHeader + 'p{padding:0;margin:0;}'
	set @MailHeader = @MailHeader + '.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}'
	set @MailHeader = @MailHeader + 'table{width: 100%;}'
	set @MailHeader = @MailHeader + 'td{border-bottom: 1px #ddd solid; text-align: center;}'
	set @MailHeader = @MailHeader + 'thead{text-align: left;}'
	set @MailHeader = @MailHeader + '</style>'
	set @MailHeader = @MailHeader + '</head>'
	set @MailHeader = @MailHeader +  '<body><div class="container">'

	set @MailBody = ''
	set @MailBody = @MailBody + '<div class="header">'
	set @MailBody = @MailBody + '<h1>'+@titulo+'</h1>'
	set @MailBody = @MailBody + '<h3>Cliente: ' +@NombreCliente+ '</h3>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Fecha: </strong>'+@fecha+'</p>'
	if (@CantidadUsuarios > 0 )
	BEGIN
		set @MailBody = @MailBody + '<p><strong>Usuarios Activos: </strong>'+cast(@CantidadUsuarios as varchar)+'</p>'
		set @MailBody = @MailBody + '<p><strong>Usuarios con reportes: </strong>'+cast(@usuariosConRepo as varchar)+'</p>'
		if(@UsuariosConRepo >0)
		BEGIN
			set @MailBody = @MailBody + '<p><strong>Usuarios sin reportes: </strong>'+cast(@CantidadUsuarios-@usuariosConRepo as varchar)+'</p>'
		END
	END
	ELSE
	BEGIN
		set @MailBody = @MailBody + '<p><strong>No se registro Actividad </strong></p>'
	END
	set @MailBody = @MailBody + '</div>'
	
	if (@CantidadUsuarios > 0  and @UsuariosConRepo >0)
	BEGIN
		set @MailBody = @MailBody + '<div class="data">'


		set @MailBody = @MailBody + '<table><tbody>'

		set @MailBody = @MailBody + '<tr>'
		set @MailBody = @MailBody + '<th> Usuarios sin reporte</th>'
		--set @MailBody = @MailBody + '<th> Reportes Cargados</th>'
		set @MailBody = @MailBody + '</tr>'

		select @MailBody = @MailBody + isnull(
		stuff((
		select x.usuario as td
		from (select u.Apellido + ', ' + u.nombre Collate database_default usuario
				from usuario u
				where u.idUsuario not in
				(select r.idUsuario from reporte r
					where r.idEmpresa = (select idEmpresa from cliente where idCLiente = @idCliente)
					and r.idPuntodeventa in (select clave from dbo.fnSplitString(@puntosDeVenta,','))
					and cast(r.fechaCreacion as date) = cast(@fecha as date)
				)
				and u.idUsuario in(
					select  distinct uc2.idUsuario 
					from usuario_cliente uc2 
					inner join usuario_puntodeventa updv2 on updv2.idUsuario = uc2.idUsuario 
					inner join puntodeventa pdv2 on pdv2.idPuntodeventa = updv2.idPuntodeventa 
					inner join UsuarioGrupo ug2 on ug2.idUsuario = uc2.idUsuario
					where uc2.idCliente = @idCliente
					and updv2.activo = 1 
					and pdv2.idCliente = @idCLiente
					and pdv2.idPuntodeventa in (select clave from dbo.fnSplitString(@puntosDeVenta,','))
					and ug2.idGrupo = 2
					)
				group by u.Apellido + ', ' + u.nombre Collate database_default 				
				)x
				for xml PATH('tr')
		),1,0,'')
		,'')

		set @MailBody = @MailBody + '</tbody></table>'
		set @MailBody = @MailBody + '<br/>'
		set @MailBody = @MailBody + '<br/>'

		set @MailBody = @MailBody + '<table><tbody>'

		set @MailBody = @MailBody + '<tr>'
		set @MailBody = @MailBody + '<th> Usuario</th>'
		set @MailBody = @MailBody + '<th> Reportes Cargados</th>'
		set @MailBody = @MailBody + '</tr>'

		select @MailBody = @MailBody + isnull(
		stuff((
		select x.usuario as td,null,x.Cantidad as td
		from (select u.Apellido + ', ' + u.nombre Collate database_default usuario, count(distinct r.idReporte) Cantidad
		from reporte r 
		inner join usuario u on u.idUsuario = r.idUsuario
		inner join (
			select pcu.idUsuario,pcu.idPuntodeventa
			from puntodeventa_cliente_usuario pcu
			where pcu.idCliente = @idCliente 
			and pcu.fecha = (select max(fecha) from puntodeventa_cliente_usuario
						 where idUsuario = pcu.idUsuario
						 and idPuntodeventa = pcu.idPuntodeventa
						 )
			and pcu.activo = 1
		)tpcu on tpcu.idUsuario = r.idUsuario
		and tpcu.idPuntodeventa = r.idPuntodeventa 
		where r.idEmpresa = (select idEmpresa from cliente where idCLiente = @idCliente)
		and r.idPuntodeventa in (select clave from dbo.fnSplitString(@puntosDeVenta,','))
		and cast(r.fechaCreacion as date) = cast(@fecha as date)
		--and u.esCheckPos = 0
		group by u.Apellido + ', ' + u.nombre Collate database_default 
		)x
		order by x.Cantidad Desc
		for xml PATH('tr')
		),1,0,'')
		,'')

		set @MailBody = @MailBody + '</tbody></table></div>'				
	end	
	set @MailFooter = '</div></body></html>'

	if isnull(@MailFrom,'')<>'' and isnull(@MailBody,'')<>''
	begin
		insert EmpresaMail (IdReporte
								,IdAlerta
								,MailFrom
								,MailBody
								,MailSubject
								,MailHeader
								,MailFooter
								,MailAdjuntos
								,Autorizado
								,UsuarioAutorizacion
								,Enviado
								,FechaCreacion
								,FechaAutorizacion
								,FechaEnvio)
		values( -1
				,@IdAlerta
				,'noreply@checkpos.com'
				,@MailBody
				,@MailSubject
				,@MailHeader
				,@MailFooter
				,null
				,1
				,null
				,0
				,getdate()
				,getdate()
				,null
				)

	END
END
GO	



