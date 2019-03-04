SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AlertaProximidad_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AlertaProximidad_add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AlertaProximidad_add]
	-- Add the parameters for the stored procedure here
    @IdUsuario int
   ,@Fecha datetime
   ,@Latitud decimal(11,8) = NULL
   ,@Longitud decimal(11,8) = NULL
   ,@idAlerta int
   ,@idPuntoDeVenta int
   
AS
BEGIN
	SET NOCOUNT ON;
	declare @mailHeader varchar(max) = ''
	declare @mailbody varchar(max) = ''
	declare @mailFooter varchar(max) = ''
	declare @mailSubject varchar(max) = ''

	--Valido que la posicion cumpla la condicion
	--Obtengo Alerta, Distancia Maxima, si el resultado de la distancia entre los puntos (Pitagoras) es mayor al valor permitido, genero el mail
	--declare @idPuntoDeVenta int
	declare @xPosPDV decimal(11,8)
	declare @yPosPDV decimal(11,8)
	declare @distancia decimal(18,8)
	declare @maxDistancia decimal(18,2)
	declare @direccionPUntoDeVenta varchar(max)
	declare @nombreLocalidad varchar(max)
	declare @rtm varchar(max)
	declare @idLocalidad int
	declare @Circunferencia varchar(max)
	declare @nombrePuntodeventa varchar(max)

--	select @idPuntodeventa = max(idPuntodeventa) 
--	from usuario_puntodeventa 
--	where idUsuario = @idUsuario

	DECLARE @snShow	BIT
	SET @snShow = 1

	declare @diferenciaHoraria int


	select @diferenciaHoraria = DiferenciaHora 
	from cliente c 
	inner join alertas a on a.idCliente = c.idCliente
	where a.id = @idAlerta

	if (convert(date,@fecha) != convert(date,getdate()))
	BEGIN
		select @fecha = isnull(dateadd(hour,@diferenciaHoraria,fechaRecepcion),fecha)
		from usuarioGeo
		where fecha = @fecha
		and idUsuario = @idUsuario 
		and latitud = @latitud
		and longitud = @longitud
	END
	


	select @xPosPDV = latitud,
			@yPosPDV = longitud,
			@idLocalidad = idLocalidad,
			@direccionPUntoDeVenta = direccion collate database_default,
			@NombrePuntodeventa = nombre
	from puntodeventa where idPuntodeventa = @idPuntodeventa

	select @nombreLocalidad = nombre from localidad where idLocalidad = @idlocalidad

	select @rtm = nombre + ' ' + apellido collate database_default from usuario where idUsuario = @idUsuario

	set @distancia = dbo.distanciaDosPuntos(@xPosPDV,@yPosPDV,@latitud,@longitud)

	select @maxDistancia = distancia 
	from alertas where id = @idAlerta 

	declare @idOperacion int

	select top 1 @IdOperacion = idEstado
	 from estadosLog
	where idUsuario = @idUsuario
	order by fechaHora desc	

	declare @horaInicio varchar(max)
	declare @horaFin varchar(max)
	declare @hora varchar(max)

	SELECT @hora = CONVERT(VARCHAR(5),@Fecha,108) 


	
	select @horaInicio = isnull(horaInicio,''),
			@horaFin = isnull(horaFin,'')
	From alertas
	where id = @idAlerta

	if (@horaInicio != '')
	begin
		if (@horaFin != '')
		BEGIN
			if (@horaFin != @horaInicio)
			BEGIN
			  ---VERIFICAR QUE CUMPlA CONDICION
			  if ( cast(left(@hora,2) as int) * 60 + cast(RIGHT(@hora,2) as int) < cast(left(@horaInicio,2) as int) * 60 + cast(right(@horaINicio,2) as int) 
			   or cast(left(@hora,2) as int) * 60 + cast(RIGHT(@hora,2) as int) > cast(left(@horaFin,2) as int) * 60 + cast(right(@horaFin,2) as int)
			   )
			  BEGIN
				RAISERROR (15600,-1,-1, 'Horario fuera del rango determinado por el alerta')
				RETURN;
			  END
			END
		END
	end


	if not exists(select 1 
					from AlertaDistanciaUsuario
					where idUsuario = @idUsuario
					and idAlerta = @idAlerta
					and cast(@fecha as date) = cast(fecha as date))
	BEGIN
		--Elimino ultimos registros
		delete AlertaDistanciaUsuario
		where idUsuario = @idUsuario
		and idAlerta = @idAlerta

		--SI NO EXISTE INSERTO NUEVO REGISTRO
		insert AlertaDistanciaUsuario(idUsuario,idAlerta,Fecha,snOut)
		values ( @idUsuario, @idAlerta, @fecha, 1)
	END

	declare @snOut int --PARA INDICAR SI EL USUARIO ESTA SALIENDO (1) o ENTRANDO (0)
	
	select @snOut = snOut
	from AlertaDistanciaUsuario 
	where idUsuario = @idUsuario
	and idAlerta = @idAlerta
	and convert(date, @fecha) = convert(date,fecha)


	set @mailHeader = '<!DOCTYPE html><html><head><title>Alerta por distancia</title><meta charset="utf-8"><style type="text/css">html{height: 100%;width: 100%;background-color: #ddd;}body{height: 100%;width: 100%;padding:20px;}h1{color: #ffffff;padding:0;margin:0;}.container{width: 100%;height: 100%;}.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}h3{color:#FDA515;padding: 0;margin: 0;}p{padding:0;margin:0;}.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}table{width: 100%;}td{border-bottom: 1px #ddd solid; text-align: center;}thead{text-align: left;}</style></head><body><div class="container">'
	set @mailFooter = '</div></body></html>'
	set @mailSubject = 'Alerta por Distancia PDV'


	declare @a int 
	declare @dist float
	declare @x float
	declare @y float
	declare @resx float,@resy float
	declare @r float

	

	set @Circunferencia = '&path=color:0xff7b00bb|weight:2|fillcolor:0xff7b0033'
		
	set @x = @xPosPDV
	set @y = @yPosPDV
	set @dist = 0.000009 --1 mts
	set @dist = @dist * @maxDistancia
	
	declare @LinkMapa varchar(max)
		
	set @r = 0

	while @r < 6.3
	BEGIN
		select @resx =  (cos(@r)*@dist) + @x,
				@resy =	(sin(@r)*@dist) + @y
		set @Circunferencia = @Circunferencia + '|'+ltrim(rtrim(str(@resx,11,8)))+','+ ltrim(rtrim(str(@resy,11,8)))
		set @r = @r +0.1
	end

	if(@distancia > @maxDistancia)
	BEGIN
	--REFA
		if(@snOut = 1) --Es decir, el ultimo estado "FUERA del PDV", no genero alerta
		BEGIN
			RAISERROR (15600,-1,-1, 'EL ultimo estado es FUERA DEL PDV, no genero alerta')
			return
		END			

		set @MailBody = ''
		set @MailBody = @MailBody + '<div class="header">'
		set @MailBody = @MailBody + '<h1>Alerta por distancia PDV</h1>' --LANIX
		set @MailBody = @MailBody + '<h3>PuntoDeVenta #'+cast(@idPuntoDeVenta as varchar)+'</h3>'
		set @MailBody = @MailBody + '</div>'
		set @MailBody = @MailBody + '<div class="middle">'
		set @MailBody = @MailBody + '<p><strong>Nombre Pdv: </strong>'+ltrim(rtrim(isnull(@NombrePuntodeventa,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@DireccionPuntoDeVenta,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@NombreLocalidad,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Fecha-Hora: </strong>'+ltrim(rtrim(isnull(@fecha,'')))+'</p>'
		set @MailBody = @MailBody + '</div>'
		

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>'+'DATOS:'+'</h3>'
		set @MailBody = @MailBody + '<table><tbody>'
		

		---MENSAJE DE QUE EL USUARIO SE ESTA ALEJANDO DEL PUNTO DE VENTA
		--if (@snOut = 1)
		--BEGIN
			if( @distancia < 1000) 
				BEGIN
				set @MailBody = @MailBody + '<tr>Distancia Actual: ' + str(@distancia,10,2) + ' mt.<br/>'
				END
			ELSE
				BEGIN
					set @MailBody = @MailBody + '<tr>Distancia Actual: ' + str(@distancia/1000,10,2) + ' Km.<br/>'
				END

			set @MailBody = @MailBody + 'Distancia Maxima: ' + str(@MaxDistancia,10,2)+ ' mt.<br/>'
			--set @MailBody = @MailBody + 'Fecha-Hora: ' + convert(varchar,@fecha,113) +' </tr>'

			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<br/>'
			set @MailBody = @MailBody + '<strong>Mapa: </strong>'
	
			set @MailBody = @MailBody + '<br/>'
			set @MailBody = @MailBody + '<img width="100%" src="https://maps.googleapis.com/maps/api/staticmap?size=600x600&markers=color:blue%7Clabel:U%7C' + cast(isnull(@latitud,0)as varchar) +',' + cast(isnull(@longitud,0)as varchar) +'&markers=color:red%7Clabel:X%7C' + cast(isnull(@xPosPDV,0)as varchar) +',' + cast(isnull(@yPosPDV,0)as varchar) + @Circunferencia +'" alt="mAPA"/>'	
			

		--END		
		set @MailBody = @MailBody + '</tbody></table></div>'	

		update alertaDistanciaUsuario
		set snOut = 1,
			fecha = @fecha
		where idUsuario = @idUsuario
		and idAlerta = @idAlerta		

		
		set @snOut = 1
	END
	ELSE --SI LA DISTANCIA ES MENOR
	BEGIN

		if(@snOut = 0) --Es decir, el ultimo estado ES "DENTRO del PDV" NO GENERO ALERTA
		BEGIN
			--return
			--RAISERROR (15600,-1,-1, 'EL ultimos estado es DENTRO DEL PDV, no genero alerta')
			SET @snShow = 0
		END
		--REFA
		set @MailBody = ''
		set @MailBody = @MailBody + '<div class="header">'
		set @MailBody = @MailBody + '<h1>Alerta por distancia PDV</h1>' --LANIX
		set @MailBody = @MailBody + '<h3>PuntoDeVenta #'+cast(@idPuntoDeVenta as varchar)+'</h3>'
		set @MailBody = @MailBody + '</div>'
		set @MailBody = @MailBody + '<div class="middle">'
		set @MailBody = @MailBody + '<p><strong>Nombre Pdv: </strong>'+ltrim(rtrim(isnull(@NombrePuntodeventa,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@DireccionPuntoDeVenta,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@NombreLocalidad,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
		set @MailBody = @MailBody + '<p><strong>Fecha-Hora: </strong>'+ltrim(rtrim(isnull(@fecha,'')))+'</p>'
		set @MailBody = @MailBody + '</div>'
		

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>'+'DATOS:'+'</h3>'
		set @MailBody = @MailBody + '<table><tbody>'
		set @mailbody = @mailbody + 'Usuario Ingreso al punto de venta'
		set @MailBody = @MailBody + '</tbody></table></div>'	

		update alertaDistanciaUsuario
		set snOut = 0,
			fecha = @fecha
		where idUsuario = @idUsuario
		and idAlerta = @idAlerta	
		
		set @snOut = 0
	END

	set @LinkMapa = '<a href="' + 'https://maps.googleapis.com/maps/api/staticmap?size=600x600&markers=color:blue%7Clabel:U%7C' + cast(isnull(@latitud,0)as varchar) +',' + cast(isnull(@longitud,0)as varchar) +'&markers=color:red%7Clabel:X%7C' + cast(isnull(@xPosPDV,0)as varchar) +',' + cast(isnull(@yPosPDV,0)as varchar) + @Circunferencia +'&key=AIzaSyBIgLjJnqKruYk2W8Y5S5iwWyom5er2lKE"'
	
	set @linkMapa = @linkMapa +	' target="null" onclick="window.open(this.href, this.target, ''width=800,height=600''); return false;" style="text-indent:0"><u style="color:blue">' +' VER MAPA ' +'</u></a>'

	exec UsuariosAlertaProximidad_add
		@idUsuario = @idUsuario,
		@fecha = @fecha,
		@snOut = @snOut,
		@LinkMapa = @LinkMapa,
		@idPuntoDeVenta = @idPuntoDeVenta,
		@snShow = @snShow
	
	BEGIN TRY
		IF @snShow = 1 BEGIN
			INSERT INTO [dbo].[EmpresaMail]
				   ([IdReporte]
				   ,[MailFrom]
				   ,[MailBody]
				   ,[MailSubject]
				   ,[Autorizado]
				   ,[Enviado]
				   ,[FechaCreacion]
				   ,[FechaAutorizacion]
					,[MailHeader]
				   ,[MailFooter]
				   ,[idAlerta]
				   )
			 VALUES
				   (0
				   ,'noreply@checkpos.com'
				   ,@MailBody
				   ,@MailSubject
				   ,1
				   ,0
				   ,getdate()
				   ,getdate()
				   ,@MailHeader
				   ,@MailFooter
				   ,@idALerta
				   )
		END
	END TRY
	BEGIN CATCH
		RAISERROR (15600,-1,-1, 'No se pudo insertar registro en Tabla EMPRESAMAIL')
	END CATCH
END
GO
