IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetClientPriceRequest'))
    exec('CREATE PROCEDURE [dbo].[GetClientPriceRequest] AS BEGIN SET NOCOUNT ON; END')
 Go
 alter procedure [dbo].[GetClientPriceRequest]
 (
	@idCliente		int 
 )
 AS
 BEGIN
 create table #clientes (idCliente int)

 insert #clientes (idCliente)
 select distinct idCliente 
 from familiaclientes f
 where f.familia in( select familia from familiaClientes 
						where activo = 1
						and idCliente =@idCliente)
 if(@@ROWCOUNT = 0)
 BEGIN
	insert #clientes(idCliente) 
	values(@idCliente)
 END
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
					as Cuentas,
					r.fecha as orderDate_
		from priceRequest r
		inner join PriceRequestEstados pe on pe.idEstado = r.EstadoPR 
		inner join cliente c on c.idCliente = r.idCliente
		left join usuario u on u.idUsuario = r.idUsuario 
		left join alertaPriceRequest al on al.idPriceRequest = r.ID
		where c.idCliente in(select idCliente from #clientes)
		and idEstado != 0
		and r.activo = 1
		order by r.fecha desc
 	END
 go





