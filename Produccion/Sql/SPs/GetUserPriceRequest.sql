IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetUserPriceRequest'))
    exec('CREATE PROCEDURE [dbo].[GetUserPriceRequest] AS BEGIN SET NOCOUNT ON; END')
 Go
 alter procedure [dbo].[GetuserPriceRequest]
 (
	@idCliente int ,
	@idUsuario int
 )
 AS
 BEGIN
 		select  r.ID as Id,
				c.Nombre as Pais,
				c.countrySymbol as CodigoPais,
				u.apellido + ', '+ u.nombre collate database_default as Usuario,
				Convert(varchar(10),CONVERT(date,r.fecha,106),103) as Fecha,
				r.EstadoPr as idEstado,
				pe.Descripcion as Estado,
				--convert(varchar,al.fecha,120) as FechaAlerta,				
				CASE WHEN (DATEDIFF(SECOND, getdate(), al.fecha)) >= 3600 THEN 
				CONVERT(VARCHAR(5), DATEDIFF(SECOND, getdate(), al.fecha)/60/60) + ':' ELSE '' END
					+ RIGHT('0' + CONVERT(VARCHAR(2), DATEDIFF(SECOND, getdate(), al.fecha)/60%60), 2)
					+ ':' + RIGHT('0' + CONVERT(VARCHAR(2), DATEDIFF(SECOND, getdate(), al.fecha) % 60), 2) as fechaAlerta,
					--Lo hago con subquerys para no hacer un distinct o un groupby
		(select nombre from producto where idProducto = 
				(select max(idProducto) from PriceRequestDetail 
				where ID = r.ID))
					 as Producto,
					 STUFF(( --la vieja confiable
						select distinct ';' + cpr.nombre
						From PriceRequestDetail prd  
						inner join cadena cpr on cpr.IdCadena = prd.IdCadena
						where ID = r.ID
						For XML PATH('')),1,1,'')
					as Cuentas
		from priceRequest r
		inner join PriceRequestEstados pe on pe.idEstado = r.EstadoPR 
		inner join cliente c on c.idCliente = r.idCliente
		left join usuario u on u.idUsuario = r.idUsuario 
		left join alertaPriceRequest al on al.idPriceRequest = r.ID
		where c.idCliente = @idCliente 
		and idEstado != 0
		and r.activo = 1
		and r.IdUsuario = @idUsuario
		order by 4 desc
 	END
 go


