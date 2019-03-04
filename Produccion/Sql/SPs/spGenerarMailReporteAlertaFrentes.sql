SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailReporteAlertaFrentes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailReporteAlertaFrentes] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailReporteAlertaFrentes]
(
	@idReporte int,
	@idAlerta int
)
as
begin

	declare @MailFrom varchar(100)=''
	declare @MailTo varchar(max)=''
	declare @MailBody varchar(max)=''
	declare @MailSubject varchar(200)=''
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
	declare @cantidad int
	declare @cantidad2 int


	if not exists(select 1 from ReporteProducto where idReporte = @idReporte and (isnull(cantidad,-1)>=0 or isnull(cantidad,-1)>=0))
		return

	set @MailFrom = 'noreply@checkpos.com'

	select top 1 
			@IdEmpresa = R.IdEmpresa,
			@idPuntoDeVenta = R.IdPuntoDeVenta,
			@NombrePuntoDeVenta = PDV.Nombre,
			@DireccionPuntoDeVenta = PDV.direccion,
			@NombreCadena = C.Nombre,
			@NombreLocalidad = L.Nombre,
			@RTM = U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT
	from Reporte R
	inner join PuntoDeVenta PDV on PDV.idPuntoDeVenta = R.idPuntoDeVenta
	left join Cadena C on C.idCadena = PDV.idCadena
	left join Localidad L on L.idLocalidad = PDV.idLocalidad
	left join Usuario U on U.idUsuario = R.idUsuario
	inner join Cliente Cl on Cl.IdEmpresa = R.IdEmpresa
	where R.idReporte = @idReporte

	Select @MailTo = Emails from EmpresaMailParametros where IdEmpresa = @IdEmpresa and IdPuntoDeVenta = @idPuntoDeVenta




--	print @mailto

--	if isnull(@MailTo,'')=''
--		return


	declare @idCliente int
	declare @titulo varchar(max)

	select @idCliente = idCliente,
	@titulo = isnull(Descripcion,'')
	from alertas where id = @idAlerta
	

	select @MailSubject = LEFT(@titulo,199)


	set @MailBody = '<!DOCTYPE html>'
	set @MailBody = @MailBody + '<html><head><title>'+@titulo+'</title><meta charset="utf-8">'
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
	set @MailBody = @MailBody + '<h1>'+@titulo+'</h1>'
	set @MailBody = @MailBody + '<h3>Reporte #'+cast(@idReporte as varchar)+'</h3>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Cadena: </strong>'+ltrim(rtrim(isnull(@NombreCadena,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>'+ltrim(rtrim(isnull(@NombrePuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@DireccionPuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@NombreLocalidad,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
	set @MailBody = @MailBody + '</div>'


	declare @cantidad1_text varchar(max)
	declare @cantidad2_text varchar(max)




	SELECT	@cantidad1_text = isnull(m.Leyenda,'')
		from m_moduloClienteItem m
		inner join m_moduloCliente mc
			on mc.idModuloCliente = m.idmoduloCliente
		where mc.idCliente = @idCliente
		and mc.idModulo = 3
		and m.Activo = 1
		and m.visibilidad = 1
		and m.idModuloItem =10
		
	SELECT	@cantidad2_text = isnull(m.Leyenda,'')
		from m_moduloClienteItem m
		inner join m_moduloCliente mc
			on mc.idModuloCliente = m.idmoduloCliente
		where mc.idCliente = @idCliente
		and mc.idModulo = 3
		and m.Activo = 1
		and m.visibilidad = 1
		and m.idModuloItem = 14

	declare @currentMarca int

	declare cur_productos cursor
	for	
		Select M.idMarca, P.idproducto, M.Nombre, P.Nombre,rp.cantidad,rp.cantidad2 
		from ReporteProducto RP
		inner join Producto P on P.idProducto = RP.idProducto
		inner join Marca M on M.IdMarca = P.IdMarca
		where RP.IdReporte = @idReporte 
		and 
		(
		isnull(RP.Cantidad,0)> 0
		 or isnull(rp.Cantidad2,0) > 0
		 )
		 and exists (select 1 
			from alertasProductos ap
			where ap.idAlerta =@idAlerta 
			and ap.idMarca = m.idMarca
			and ap.idProducto = p.idProducto
			)	
		order by M.idMarca, P.idproducto


	open cur_productos
	fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto,@cantidad, @cantidad2

	if(@@FETCH_STATUS != 0)
	BEGIN
		close cur_productos
		deallocate cur_productos
		return
	END 
	
	while @@FETCH_STATUS = 0
	begin
		select @currentMarca = @idmarca

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>'+ltrim(rtrim(isnull(@NombreMarca,'')))+'</h3>'
		set @MailBody = @MailBody + '<table><tbody>'
		set @MailBody = @MailBody + '<tr>'
		set @MailBody = @MailBody + '<th>Producto</th><th>'+@cantidad1_Text+'</th><th>'+@cantidad2_text+'</th>'
		set @MailBody = @MailBody + '</tr>'
		
		while (@@FETCH_STATUS = 0 and @currentMarca = @idmarca)
		begin
			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(@NombreProducto,'')))+'</td>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(str(@Cantidad),'')))+'</td>'
			set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(str(@Cantidad2),'')))+'</td>'
			set @MailBody = @MailBody + '</tr>'

			fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto,@cantidad, @cantidad2
		end

		set @MailBody = @MailBody + '</tbody></table></div>'

		fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto,@cantidad,@cantidad2
	end

	close cur_productos
	deallocate cur_productos	



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
		values(@idReporte
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

