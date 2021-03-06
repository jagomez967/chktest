SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGenerarMailAlertaInventario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGenerarMailAlertaInventario] AS' 
END
GO
ALTER procedure [dbo].[spGenerarMailAlertaInventario]
(
	@IdReporte int,
	@IdAlerta int
)
as
begin

	declare @MailFrom varchar(100)=''
	declare @MailBody varchar(max)=''
	declare @MailSubject varchar(200)=''
	declare @descripcion varchar(200)=''
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

	set @MailFrom = 'noreply@checkpos.com'

	select top 1 
			@idCliente = Cl.idCliente,
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

	set @MailSubject = 'Alerta Inventario'

	select @Descripcion = descripcion from alertas where id = @IdAlerta
	and len(descripcion) < 180

	if (isnull(@Descripcion,'') != '')
	BEGIN
		set @MailSubject = @Descripcion + ' - ' + @MailSubject
	END

	set @MailHeader = '<!DOCTYPE html>'
	set @MailHeader = @MailHeader + '<html><head><title>Alerta Inventario</title><meta charset="utf-8">'
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
	set @MailBody = @MailBody + '<h1>Alerta Inventario</h1>' --LANIX
	set @MailBody = @MailBody + '<h3>Reporte #'+cast(@idReporte as varchar)+'</h3>'
	set @MailBody = @MailBody + '</div>'
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Cadena: </strong>'+ltrim(rtrim(isnull(@NombreCadena,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Punto de Venta: </strong>'+ltrim(rtrim(isnull(@NombrePuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Dirección Pdv: </strong>'+ltrim(rtrim(isnull(@DireccionPuntoDeVenta,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Localidad: </strong>'+ltrim(rtrim(isnull(@NombreLocalidad,'')))+'</p>'
	set @MailBody = @MailBody + '<p><strong>Usuario Rtm: </strong>'+ltrim(rtrim(isnull(@RTM,'')))+'</p>'
	set @MailBody = @MailBody + '</div>'
	

	declare @currentMarca int

	declare @nombreModulo varchar(max)

	declare	@precio decimal(18,3),
	@precio2 decimal(18,3),
	@precio3 decimal(18,3),
	@stock int,
	@notrabaja int,
	@idExhibidor int,
	@idExhibidor2 int,
	@cantidad int,
	@cantidad2 int

	create table #modulosItems(
	idModuloItem int,
	nombre varchar(max)
	)
	
	create table #tempReporteProducto(
	idMarca int,
	idProducto int,
	marcaNombre varchar(max),
	productonombre varchar(max),
	precio decimal(18,3),
	precio2 decimal(18,3),
	precio3 decimal(18,3),
	stock int,
	notrabaja int,
	idExhibidor int,
	idExhibidor2 int,
	cantidad int,
	cantidad2 int
	)

	insert #tempReporteProducto(idMarca,idProducto,marcanombre,productonombre,precio,precio2,precio3,
	stock,notrabaja,idExhibidor,idExhibidor2,cantidad,cantidad2)
	Select M.idMarca, P.idproducto, M.Nombre, P.Nombre,RP.Precio,RP.Precio2,RP.precio3
		,RP.Stock,RP.NoTrabaja,RP.IdExhibidor,RP.IdExhibidor2,rp.Cantidad,RP.Cantidad2
		 from ReporteProducto RP
		inner join Producto P on P.idProducto = RP.idProducto
		inner join Marca M on M.IdMarca = P.IdMarca
		where RP.IdReporte = @idReporte 
		order by M.idMarca, P.idproducto




	insert  #modulosItems(idModuloItem,nombre)
	SELECT	m.IdModuloItem,m.Leyenda
			from m_moduloClienteItem m
			inner join m_moduloCliente mc
				on mc.idModuloCliente = m.idmoduloCliente
			where mc.idCliente = @idCliente
			and mc.idModulo = 3
			and m.Activo = 1
			and mc.Activo = 1
			and m.visibilidad = 1
	
	declare @esIgual int,@esMayor int,@esMenor int, @valor decimal(18,2)

	
	select * from #tempReporteProducto

		--3 Quiebre de stock
		if exists (select 1 from #modulosItems where idModuloItem = 3)
		BEGIN	
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 3

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where stock < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where stock > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where stock <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where stock >= @valor
				END
			END
		END
		
		--5 no trabaja
		if exists (select 1 from #modulosItems where idModuloItem = 5)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 5

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where notrabaja < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where notrabaja > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where notrabaja <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where notrabaja >= @valor
				END
			END
		END

		--7 precio
		if exists (select 1 from #modulosItems where idModuloItem = 7)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 7

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio >= @valor
				END
			END
		END

		--10 cantidad
		if exists (select 1 from #modulosItems where idModuloItem = 10)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 10

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad >= @valor
				END
			END
		END

		--12 exhibidor1
		if exists (select 1 from #modulosItems where idModuloItem = 12)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 12

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor >= @valor
				END
			END
		END

		--14 cantidad2
		if exists (select 1 from #modulosItems where idModuloItem = 14)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 14

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad2 < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad2 > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad2 <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where cantidad2 >= @valor
				END
			END
		END

		--16 exhibidor2
		if exists (select 1 from #modulosItems where idModuloItem = 16)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 16
			
			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor2 < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor2 > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor2 <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where idexhibidor2 >= @valor
				END
			END
		END

		--50 precio2
		if exists (select 1 from #modulosItems where idModuloItem = 50)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 50

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio2 < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio2 > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio2 <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio2 >= @valor
				END
			END
		END

		--51 precio3
		if exists (select 1 from #modulosItems where idModuloItem = 51)
		BEGIN
			select @esIgual = esIgual,
				@esMayor = esMayor,
				@esMenor = esMenor,
				@valor = Valor 
			from alertasMOdulos where idAlerta = @idAlerta
			and idModuloItem = 51

			if (@esIgual = 1)
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio3 < @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio3 > @valor
				END
			END
			else
			BEGIN
				if (@esMayor = 1)
				BEGIN
					delete from #tempreporteProducto where precio3 <= @valor
 				END
				if (@esMenor = 1)
				BEGIN
					delete from #tempreporteProducto where precio3 >= @valor
				END
			END
		END



	if not exists(select 1 from #tempreporteproducto where 1=1)
	BEGIN
		return
	END
			
	declare cur_productos cursor
	for	
		Select idMarca, idproducto, marcaNombre, productoNombre,Precio,Precio2,precio3
		,Stock,NoTrabaja,IdExhibidor,IdExhibidor2,Cantidad,Cantidad2
		 from #tempReporteProducto 
		order by idMarca, idproducto

	open cur_productos
	fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto,
	@precio,@precio2,@precio3,@stock,@notrabaja, @idExhibidor,@idExhibidor2,@cantidad,@cantidad2

	while @@FETCH_STATUS = 0
	begin
		select @currentMarca = @idmarca

		set @MailBody = @MailBody + '<div class="data">'
		set @MailBody = @MailBody + '<h3>'+ltrim(rtrim(isnull(@NombreMarca,'')))+'</h3>'
		set @MailBody = @MailBody + '<table><tbody>'

		set @MailBody = @MailBody + '<tr>'
		set @MailBody = @MailBody + '<th>Producto</th>'

		--3 Quiebre de stock
		if exists (select 1 from #modulosItems where idModuloItem = 3)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=3)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END
		
		--5 no trabaja
		if exists (select 1 from #modulosItems where idModuloItem = 5)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=5)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--7 precio
		if exists (select 1 from #modulosItems where idModuloItem = 7)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=7)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--10 cantidad
		if exists (select 1 from #modulosItems where idModuloItem = 10)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=10)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--12 exhibidor1
		if exists (select 1 from #modulosItems where idModuloItem = 12)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=12)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--14 cantidad2
		if exists (select 1 from #modulosItems where idModuloItem = 14)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=14)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--16 exhibidor2
		if exists (select 1 from #modulosItems where idModuloItem = 16)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=16)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--50 precio2
		if exists (select 1 from #modulosItems where idModuloItem = 50)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=50)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		--51 precio3
		if exists (select 1 from #modulosItems where idModuloItem = 51)
		BEGIN
			select 	@nombreModulo = (select max(nombre) from #modulosItems where idMOduloItem=51)
			set @MailBody = @MailBody + '<th>'+ltrim(rtrim(isnull(@nombreModulo,'')))+'</th>'
		END

		set @MailBody = @MailBody + '</tr>'


		while (@@FETCH_STATUS = 0 and @currentMarca = @idmarca)
		begin
			set @MailBody = @MailBody + '<tr>'
			set @MailBody = @MailBody + '<td><strong>'+ltrim(rtrim(isnull(@NombreProducto,'')))+'</strong></td>'

			---EL RESTO DE LOS DATOS
			--3 Quiebre de stock
			if exists (select 1 from #modulosItems where idModuloItem = 3)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@stock as varchar),'')))+'</td>'
			END
		
			--5 no trabaja
			if exists (select 1 from #modulosItems where idModuloItem = 5)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(cast(@Notrabaja as varchar),'')))+'</td>'
			END

			--7 precio
			if exists (select 1 from #modulosItems where idModuloItem = 7)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@precio as varchar),'')))+'</td>'
			END

			--10 cantidad
			if exists (select 1 from #modulosItems where idModuloItem = 10)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@cantidad as varchar),'')))+'</td>'
			END

			--12 exhibidor1
			if exists (select 1 from #modulosItems where idModuloItem = 12)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@idexhibidor as varchar),'')))+'</td>'
			END

			--14 cantidad2
			if exists (select 1 from #modulosItems where idModuloItem = 14)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@cantidad2 as varchar),'')))+'</td>'
			END

			--16 exhibidor2
			if exists (select 1 from #modulosItems where idModuloItem = 16)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@idExhibidor2 as varchar),'')))+'</td>'
			END

			--50 precio2
			if exists (select 1 from #modulosItems where idModuloItem = 50)
			BEGIN
			select @MailBody
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@precio2 as varchar),'')))+'</td>'
			END

			--51 precio3
			if exists (select 1 from #modulosItems where idModuloItem = 51)
			BEGIN
				set @MailBody = @MailBody + '<td>'+ltrim(rtrim(isnull(CAST(@precio3 as varchar),'')))+'</td>'
			END

			set @MailBody = @MailBody + '</tr>'

			fetch next from cur_productos into @idmarca, @idproducto, @NombreMarca, @NombreProducto,
			@precio,@precio2,@precio3,@stock,@notrabaja, @idExhibidor,@idExhibidor2,@cantidad,@cantidad2
		end

		set @MailBody = @MailBody + '</tbody></table></div>'	

	end

	close cur_productos
	deallocate cur_productos

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
	end
end


GO
