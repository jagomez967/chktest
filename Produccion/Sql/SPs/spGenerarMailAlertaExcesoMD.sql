SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailAlertaExcesoMD]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailAlertaExcesoMD] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailAlertaExcesoMD]
(
	@IdReporte int,
	@IdAlerta int
)
as
begin

	declare @MailFrom varchar(100)=''
	declare @MailBody varchar(max)=''
	declare @MailSubject varchar(200)=''
	declare @Descripcion varchar(200)=''
	declare @idPuntoDeVenta int
	declare @idmarca int
	declare @idproducto int
	declare @NombreMarca varchar(100)=''
	declare @NombreProducto varchar(100)=''
	declare @NombrePuntoDeVenta varchar(200)=''
	declare @NombreCadena varchar(50)=''
	declare @DireccionPuntoDeVenta varchar(500)=''
	declare @NombreLocalidad varchar(50)=''
	declare @RTM varchar(150)=''
	declare @IdEmpresa int
	declare @MailHeader varchar(max)
	declare @MailFooter varchar(max)
	declare @idCliente int
	declare @nombreCliente varchar(max)

	set @MailFrom = 'noreply@checkpos.com'

	select top 1 
			@idCliente = Cl.idCliente,
			@IdEmpresa = R.IdEmpresa,
			@idPuntoDeVenta = R.IdPuntoDeVenta,
			@NombrePuntoDeVenta = PDV.Nombre,
			@DireccionPuntoDeVenta = PDV.direccion,
			@NombreCadena = C.Nombre,
			@NombreLocalidad = L.Nombre,
			@RTM = U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT,
			@nombreCliente = Cl.nombre
	from Reporte R
	inner join PuntoDeVenta PDV on PDV.idPuntoDeVenta = R.idPuntoDeVenta
	left join Cadena C on C.idCadena = PDV.idCadena
	left join Localidad L on L.idLocalidad = PDV.idLocalidad
	left join Usuario U on U.idUsuario = R.idUsuario
	inner join Cliente Cl on Cl.IdEmpresa = R.IdEmpresa
	where R.idReporte = @idReporte

	select @Descripcion = descripcion from alertas where id = @IdAlerta
	and len(descripcion) < 150

	set @MailSubject = 'Alerta por exceso de carga en Modulo Dinámico'
	if (isnull(@Descripcion,'') != '')
	BEGIN
		set @MailSubject = @Descripcion + ' - ' + @MailSubject
	END
		

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>Alerta Exceso en carga MD</title><meta charset="utf-8">'
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
	set @MailBody = @MailBody + '<h1>Alerta Exceso en carga MD</h1>' --LANIX
	set @MailBody = @MailBody + '<h3>Reporte #'+cast(@idReporte as varchar)+'</h3>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>'+ltrim(rtrim(isnull(@NombrePuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@DireccionPuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@NombreLocalidad,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Cliente: </strong>'+ltrim(rtrim(isnull(@nombreCliente,'')))+'</p>'

	set @MailBody = @MailBody + '</div>'
	

	---Si tengo seleccionado dentro del MD items con el nombre
	--25%,50%,75%,100% dentro de el mismo modulo. Entonces disparo una alerta

	create table #tempItemsModulos
	(item varchar(Max),
	 modulo varchar(max)
	 )

	insert #tempItemsModulos(item,modulo)
	select i.nombre,m.nombre from md_reporteMOduloItem rmi 
	inner join md_item i on i.idItem = rmi.idItem
	inner join md_modulo m on m.idModulo = i.idMOdulo
	where rmi.idreporte = @IdReporte
	and rmi.valor1 = 1
	and i.nombre in('25%','50%','75%','100%')


	declare  @nombreItem varchar(max),@nombreModulo varchar(max), @currentModulo varchar(max)

	if exists(
	select modulo,count(item) from #tempItemsMOdulos
	group by modulo
	having count(item) > 1)
	BEGIN --GENERO ALERTA

		declare CURSOR_MODULOS cursor
		for	
			select i.nombre,m.nombre from md_reporteMOduloItem rmi 
			inner join md_item i on i.idItem = rmi.idItem
			inner join md_modulo m on m.idModulo = i.idMOdulo
			where rmi.idreporte = @idReporte
			and rmi.valor1 = 1
			and i.nombre in('25%','50%','75%','100%')
			order by m.nombre,i.nombre

		open CURSOR_MODULOS
		fetch next from CURSOR_MODULOS into @nombreItem,@nombreModulo

		while @@FETCH_STATUS = 0
		BEGIN
			set @currentModulo = @nombreModulo

			set @MailBody = @MailBody + '<div class="data">'
			set @MailBody = @MailBody + '<h3>'+ltrim(rtrim(isnull(@NombreModulo,'')))+'</h3>'
			set @MailBody = @MailBody + '<table><tbody>'

			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<th> Items seleccionados:</th>'
			set @MailBody = @MailBody + '</tr>'


			while (@@FETCH_STATUS = 0 and @currentModulo = @nombreModulo)
			begin
				set @MailBody = @MailBody + '<tr>'
				set @MailBody = @MailBody + '<td><strong>'+ltrim(rtrim(isnull(@NombreItem,'')))+'</strong></td>'
				set @MailBody = @MailBody + '</tr>'
				
				fetch next from CURSOR_MODULOS into @nombreItem,@nombreModulo
			end

			set @MailBody = @MailBody + '</tbody></table></div>'				
		END

		close CURSOR_MODULOS
		deallocate CURSOR_MODULOS

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
			values(@idReporte
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
end

GO
