CREATE PROCEDURE EddingNuevoPuntoDeVenta 
(@idReporte int) 
AS 
BEGIN
Declare 
		@idPuntoDeVenta int,
		@idUsuario int,
		@FechaCreacion datetime,
		@latitud decimal (11,8),
		@longitud decimal (11,8),
		@idNewPuntoDeVenta int,
		@idNewZona int,
		@idNewLocalidad int,
		@PDV_Nombre varchar(max),
		@PDV_Direccion varchar(max),
		@PDV_Barrio varchar(max),
		@PDV_Detalle varchar(max),
		@err_msj varchar(max),
		@err_num int,
		@idNewCategoria int



declare @msg nvarchar(max);

select	@idReporte = idReporte,
		@idPuntodeventa = idPuntoDeVenta,
		@idUsuario = idUsuario,
		@FechaCreacion = FechaCreacion,
		@latitud = latitud,
		@longitud = Longitud 
from reporte where idReporte = @idReporte

if(@idpuntodeventa <> 30699)
BEGIN
	return;
END


/*
select * from md_reporteModuloitem where idReporte = 569762

2453 - "distrioccidente" - CLIENTE
2454 - "Papeleria colombia" - NOMBRE DE CLIENTE
2455 - "pereira"  - CIUDAD
2456 - "cra 7# 22-64" - Direccion
2457 - "centro" - BARRIO
2458 - "3356644" - Telefono
5296 - " "  - VISIBILIDAD
*/




select top 1 @PDV_Nombre = ltrim(rtrim(isnull(valor4,''))) From [dbo].[MD_ReporteModuloItem]
where idMarca = 1460
and idItem = 2454
and idReporte = @idReporte

select top 1 @PDV_Direccion = ltrim(rtrim(isnull(valor4,''))) From [dbo].[MD_ReporteModuloItem]
where idMarca = 1460
and idItem = 2456
and idReporte = @idReporte

select top 1 @PDV_Barrio = ltrim(rtrim(isnull(valor4,''))) From [dbo].[MD_ReporteModuloItem]
where idMarca = 1460
and idItem = 2457
and idReporte = @idReporte

select top 1 @PDV_Detalle = ltrim(rtrim(isnull(valor4,''))) From [dbo].[MD_ReporteModuloItem]
where idMarca = 1754
and idItem = 7761
and idReporte = @idReporte

declare @idNewTipo int

select @idNewTipo= idTipo from tipo where nombre like @PDV_Detalle
and idCliente = 100

declare @LocalidadNueva int
--a) Si no existe la LOCALIDAD la inserto, si la inserto entonces genero un mail y salgo.
if not exists (select 1 from localidad where idProvincia in (select idProvincia From provincia where idCliente = 100)
and nombre like @PDV_Barrio collate database_default)
BEGIN
	insert localidad(idProvincia,nombre)
	values(2108,@PDV_Barrio)
	set @idNewLocalidad = scope_identity()
	
	select @idNewZona = [idZona] from buhl_Zona_usuarios where idUsuario = @idUsuario
	if @@rowcount = 0
	BEGIN
		set @idNewZona = 2816 --BUENOS AIRES INTERIOR
		set @LocalidadNueva = 1
	end
	ELSE
	BEGIN
		set @LocalidadNueva = 0
	END
END
ELSE
BEGIN
	select @idNewLocalidad = idLocalidad from localidad where idProvincia in(select idProvincia from provincia where idCliente = 100 )
	and nombre like @PDV_Barrio collate database_default

	--select @idNewZona = [id ZONA] from buhl_Zonas where idLocalidad = @idNewLocalidad
	select @idNewZona = [idZona] from buhl_Zona_usuarios where idUsuario = @idUsuario
--	select * from buhl_zona_usuarios
	select @idNewZona = isnull(@idNewZona,[id ZONA]) from buhl_Zonas where idLocalidad = @idNewLocalidad

	if isnull(@idNewZona,0) = 0
	BEGIN
		set @LocalidadNueva = 1 --Marco la localidad como nueva para notificar por mail
		set @idNewZona = 2807 --NUEVO
	END
	ELSE
	BEGIN
		set @LocalidadNueva = 0
	END
END

--1) INSERTO PUNTO DE VENTA.
--			En codigo inserto el idreporte "bautizador"
--			En Nombre, el nombre y la direccion concatenados
--			En Direccion la direccion. 
--			Localidad la obtenida (o Creada)
--			En zona la zona Obtenida. Si no se obtiene ninguna se asigna la primera (SE AVISA POR MAIL PARA CORREGIRLO)
--			En Cadena. NULL. si se puede hacer de otra forma pa delante.
select @PDV_Nombre = 
			case when isnull(@PDV_Nombre,'') = ''
				then isnull(@PDV_Direccion,'NN')
			else
				@PDV_Nombre+' - ' + isnull(@PDV_Direccion,'NN')
			end

BEGIN TRY
	begin tran
	
	select @idNewCategoria =
		case when @idUsuario = 2302 then 64
			when @idUsuario = 2327 then 64
			else 63
		end	

	insert puntodeventa(codigo,nombre,direccion,idLocalidad,idZona,idCadena,latitud,longitud,idTipo,idCliente,idCategoria)
	values (@idReporte,@PDV_Nombre,@PDV_direccion,@idNewLocalidad,@idNewZona,null,@latitud,@longitud,@idNewTipo,100,@idNewCategoria)
	set @idNewPuntoDeVenta = scope_identity()

--2)Inserto la relacion USUARIO -> Puntodeventa
	insert usuario_puntodeventa(idPuntodeventa,idUsuario,activo)
	select @idNewPuntodeventa,idUsuario,1
	from buhl_zona_usuarios
	where idZona = @idNewZona

--3)Inserto el Ruteo puntodeventa_cliente_usuario
	insert puntodeventa_cliente_usuario(idCliente,idPuntodeventa,idUsuario,fecha,activo)
	select 100,@idNewPuntoDeVenta,idUsuario,getdate(),1
	from buhl_zona_usuarios
	where idZona = @idNewZona

--4)Reestablezco el reporte al nuevo pdv (update reporte , set idPuntodeventa = @newIdPuntodeventa)

	
	update reporte 
	set idPuntodeventa = @idNewPuntodeventa
	where idReporte = @idReporte

--5)Muevo las fotos, actualizando el pdv en la tabla puntodeventaFoto

	update PuntoDeVentaFoto
	set idPuntodeventa = @idNewPuntoDeVenta
	where idReporte = @idReporte
END TRY

BEGIN CATCH

	select @err_msj = ERROR_MESSAGE(),
			@err_num = ERROR_NUMBER();
			
	rollback tran


	insert buhl_pdvs_creados(idReporte,idNewPuntoDeVenta,idUsuario,FechaCreacion,latitud,longitud,descripicion)
	SELECT   
	   @idReporte,@idNewPuntodeventa,@idUsuario,getdate(),@latitud,@longitud,
        'ERROR Nº' + cast(@err_num as varchar) 
		+ ': '+   
       @err_msj;



select @msg =
'<!DOCTYPE html>
<html>
<body>

<!DOCTYPE html><html><head><title>BUHL Nueva Localidad</title><meta charset="utf-8"><style type="text/css">html{height: 100%;width: 100%;background-color: #ddd;}body{height: 100%;width: 100%;padding:20px;}h1{color: #ffffff;padding:0;margin:0;}.container{w



idth: 100%;height: 100%;}.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-c



olor: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}h3{padding: 0;margin: 0;}h4{padding: 0;margin: 0;}h2{color:#FDA515;padding: 0;margin: 0;}p{padding:0;margin:0;}.data{margin: auto;height: auto;width: 60%;background-color: #ffffff



;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}table{border-collapse: collapse;width: 100%;background:#ffffff;margin:0;padding:0;}th, td{text-align: left;padding: 8px;}tr:nth-child(even){background-color: #f2f2f2}</style></head><body><d



iv class="container">

<div class="header"><h1>BUHL Nuevo PDV</h1><h2>IDPDV:'+cast(@idNewPuntodeventa as varchar)+'<p>'+cast((select max(nombre) from puntodeventa where idPuntodeventa =@idNewPuntodeventa) as varchar)+'</h2></div><div class="middle"><p><strong>Se creo nuevo punt



o de venta:<p>Nombre: </strong><i>'+cast((select max(nombre) from puntodeventa where idPuntodeventa =@idNewPuntodeventa) as varchar(max))+'</i><p> ERROR AL INSERTAR PUNTO DE VENTA. <br/> <br/>'+@err_msj+' </div>
</div></body></html>
'
	 EXEC msdb.dbo.sp_send_dbmail
          @recipients = 'jagomez967@hotmail.com', 
          @profile_name = 'Notificaciones',
          @subject = 'BUHL ERROR insercion puntodeventa!', 
          @body_format = 'HTML',
		  @body = @msg;

	return;
END CATCH

commit tran
--6)inserto Detalle de la operacion en buhl_pdvs_creados

insert buhl_pdvs_creados(idReporte,idNewPuntoDeVenta,idUsuario,FechaCreacion,latitud,longitud)
values (@idReporte,@idNewPuntoDeVenta,@idUsuario,@FechaCreacion,@latitud,@longitud)


if (@LocalidadNueva = 1)
BEGIN
/*	select @msg = 'Se creo una nueva localidad:' + cast(@idNewLocalidad as varchar) +
				  +'('+ (select max(nombre) from localidad where idLocalidad = @idNewLocalidad) +')'+
				   ' para el pdv:' + cast(@idNewPuntoDeVenta as varchar) + char(10) + char(13) + 'Corregir zona, asignar usuarios y actualizar tablas de parametría de BUHL'+
				   '<br/><b>MAPA</b>:'+
				   '<img width="600" src="https:'+'//static-maps.yandex.ru/1.x/?lang=en-US&ll=-' + cast(isnull(@longitud,0)as varchar) +','+cast(isnull(@latitud,0)as varchar)+'&z=12&l=map&size=600,300" alt="Yandex Map of '+cast(isnull(@longitud,0)as varchar)+','+cast



(isnull(@latitud,0)as varchar)+'">';
				   */
select @msg =
'<!DOCTYPE html>
<html>
<body>

<!DOCTYPE html><html><head><title>BUHL Nueva Localidad</title><meta charset="utf-8"><style type="text/css">html{height: 100%;width: 100%;background-color: #ddd;}body{height: 100%;width: 100%;padding:20px;}h1{color: #ffffff;padding:0;margin:0;}.container{w



idth: 100%;height: 100%;}.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}.middle{margin: auto;width: 60%;height: 100px;padding: 15px 50px 15px 50px;background-c



olor: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}h3{padding: 0;margin: 0;}h4{padding: 0;margin: 0;}h2{color:#FDA515;padding: 0;margin: 0;}p{padding:0;margin:0;}.data{margin: auto;height: auto;width: 60%;background-color: #ffffff



;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}table{border-collapse: collapse;width: 100%;background:#ffffff;margin:0;padding:0;}th, td{text-align: left;padding: 8px;}tr:nth-child(even){background-color: #f2f2f2}</style></head><body><d



iv class="container">

<div class="header"><h1>BUHL Nuevo PDV</h1><h2>IDPDV:'+cast(@idNewPuntodeventa as varchar)+'<p>'+cast((select max(nombre) from puntodeventa where idPuntodeventa =@idNewPuntodeventa) as varchar)+'</h2></div><div class="middle"><p><strong>Se creo nuevo punt



o de venta:<p>Nombre: </strong><i>'+cast((select max(nombre) from puntodeventa where idPuntodeventa =@idNewPuntodeventa) as varchar(max))+'</i><p> 1)corregir zona, usuarios y ruteos en el pdv.<p>2) Actualizar el excel de zonas x localidad para Buhl</div>





<div class="data"><h2>Nueva Localidad</h2><hr /><h3>Insertada o sin asignacion de zona</h3>
<br/>
<span style="display:inline-block; width: 150px;"><strong>ID Localidad:</strong></span>'+cast(@idNewLocalidad as varchar)+'
<p>
<span style="display:inline-block; width: 150px;"><strong>Nombre Localidad:</strong></span>'+(select max(nombre) from localidad where idLocalidad = @idNewLocalidad)+'
<p>
<strong>Mapa: </strong>
<br/>
<img width="100%" src="https://static-maps.yandex.ru/1.x/?lang=en-US&ll=' + cast(isnull(@longitud,0)as varchar) +','+cast(isnull(@latitud,0)as varchar)+'&z=13&l=map&size=600,300" alt="Yandex Map of ' + cast(isnull(@longitud,0)as varchar) +','+cast(isnull(



@latitud,0)as varchar)+'">
<br/>
<hr>
<br/>
<img width="100%" src="https://static-maps.yandex.ru/1.x/?lang=en-US&ll=' + cast(isnull(@longitud,0)as varchar) +','+cast(isnull(@latitud,0)as varchar)+'&z=11&l=map&size=600,300" alt="Yandex Map of ' + cast(isnull(@longitud,0)as varchar) +','+cast(isnull(



@latitud,0)as varchar)+'">
</div>

</div></body></html>
'


	 EXEC msdb.dbo.sp_send_dbmail
          @recipients = 'atorres@checkpos.com;jagomez967@hotmail.com', 
          @profile_name = 'Notificaciones',
          @subject = 'BUHL (TEST) insercion puntodeventa', 
          @body_format = 'HTML',
		  @body = @msg;

END

END








