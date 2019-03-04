

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetPhotosPriceRequest'))
    exec('CREATE PROCEDURE [dbo].[GetPhotosPriceRequest] AS BEGIN SET NOCOUNT ON; END')
 Go
 alter procedure [dbo].[GetPhotosPriceRequest]
 (
 	@IdProducto			int,
	@precio			varchar(100),
	@idCadena		int 
 )
 AS
 BEGIN
	select @precio = replace(@precio,',','.')

	create table #tmp
	(IdReporte int, IdPuntodeventa int, PuntoDeVenta varchar(max), Direccion varchar(max),
	 IdUsuario int, Usuario varchar(max), fecha varchar(max), IdEmpresa int, 
	 IdImagen int, IdProducto int, Soundorder int, precio decimal(18,3), idCadena int,
	 nombre varchar(max),leyenda varchar(max) ,TieneTag bit)


	insert #tmp(IdReporte,IdPuntodeventa,PuntoDeVenta,Direccion,IdUsuario,Usuario,fecha,IdEmpresa,IdProducto
	,IdImagen,Soundorder,precio,idCadena,nombre,leyenda,TieneTag) 		
		select  r.idReporte as IdReporte, 
				pdv.Idpuntodeventa as IdPuntoDeVenta,
				pdv.nombre as PuntoDeVenta,
				pdv.Direccion as Direccion,
				u.idUsuario as IdUsuario,
				u.apellido +', '+u.nombre collate database_default as Usuario,
				convert(varchar,r.FechaCreacion,103) as Fecha,
				r.idEmpresa as IdEmpresa,
				rp.idProducto as IdProducto,
				pf.IdPuntoDeVentaFoto as IdImagen,				
				isnull(DIFFERENCE(SOUNDEX(p.nombre) collate database_default,SOUNDEX(t.leyenda) collate database_default),999999) Soundorder 
				,rp.precio
				,pdv.idCadena
				,p.nombre,t.leyenda
								,1 as TieneTag
 		from reporte r
 		inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
 		inner join usuario u on u.idUsuario = r.idUsuario
 		inner join reporteProducto rp on rp.idReporte = r.idReporte
 		inner join producto p on p.idProducto = rp.idProducto
		inner join puntodeventafoto pf on pf.idReporte = r.idReporte
		inner join cadena cad on cad.idCadena = pdv.idCadena
		left join imagenesTags it on it.idImagen = pf.idPuntodeventaFoto
		left join tags t on t.idTag = it.idTag		
 		where 
 		rp.idProducto = @IdProducto
 		and cast(rp.precio as NUMERIC(18,2)) = cast(@precio as NUMERIC(18,2))
 		and convert(date,r.fechaCreacion) > convert(date,dateadd(DAY,-15,getdate()),103)
		and cad.idCadena = @idCadena 
		and p.nombre like '%' +t.leyenda +'%' collate database_default
		and pf.estado = 1
		order by r.FechaCreacion desc, Soundorder asc

		if (@@ROWCOUNT <= 0)
		BEGIN
			insert #tmp(IdReporte,IdPuntodeventa,PuntoDeVenta,Direccion,IdUsuario,Usuario,fecha,IdEmpresa,IdProducto
			,IdImagen,Soundorder,precio,idCadena,nombre,leyenda,tieneTag) 		
			select  r.idReporte as IdReporte, 
				pdv.Idpuntodeventa as IdPuntoDeVenta,
				pdv.nombre as PuntoDeVenta,
				pdv.Direccion as Direccion,
				u.idUsuario as IdUsuario,
				u.apellido +', '+u.nombre collate database_default as Usuario,
				convert(varchar,r.FechaCreacion,103) as Fecha,
				r.idEmpresa as IdEmpresa,
				rp.idProducto as IdProducto,
				pf.IdPuntoDeVentaFoto as IdImagen,				
				isnull(DIFFERENCE(SOUNDEX(p.nombre) collate database_default,SOUNDEX(t.leyenda) collate database_default),999999) Soundorder 
				,rp.precio
				,pdv.idCadena
				,p.nombre
				,t.leyenda
				,0 as TieneTag
 			from reporte r
 			inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPuntodeventa
 			inner join usuario u on u.idUsuario = r.idUsuario
 			inner join reporteProducto rp on rp.idReporte = r.idReporte
 			inner join producto p on p.idProducto = rp.idProducto
			inner join puntodeventafoto pf on pf.idReporte = r.idReporte
			inner join cadena cad on cad.idCadena = pdv.idCadena
			left join imagenesTags it on it.idImagen = pf.idPuntodeventaFoto
			left join tags t on t.idTag = it.idTag		
 			where 
 			rp.idProducto = @IdProducto
 			and cast(rp.precio as NUMERIC(18,2)) = cast(@precio as NUMERIC(18,2))
 			and convert(date,r.fechaCreacion) > convert(date,dateadd(DAY,-15,getdate()),103)
			and cad.idCadena = @idCadena 			
			and pf.estado = 1
			order by r.FechaCreacion desc, Soundorder asc

		END


		select * From #tmp 
 	END

 go


  


