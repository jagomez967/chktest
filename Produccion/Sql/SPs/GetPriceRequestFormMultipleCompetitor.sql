IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetPriceRequestFormMultipleCompetitor'))
   exec('CREATE PROCEDURE [dbo].[GetPriceRequestFormMultipleCompetitor] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetPriceRequestFormMultipleCompetitor]
(
	@IdCliente int,
	@IdProducto int,
	@CompetitorArray varchar(max)
)
AS
BEGIN

	declare @fechaInicio datetime = dateadd(week,-1,getdate())
	declare @fechaFin datetime = getdate()
	
	create table #tempReporte
	(idProducto int,precio decimal(18,3),idCadena int)
	
	insert #tempReporte(idProducto,precio,idCadena)
	select rp.idProducto,rp.precio,pdv.idCadena
	from reporteProducto rp 
	inner join reporte r
		on r.idReporte = rp.idReporte
	inner join cliente c
		on c.idempresa = r.idEmpresa 
	inner join producto p
		on p.idProducto = rp.idProducto
	inner join puntodeventa pdv 
		on pdv.idPuntodeventa = r.idPuntodeventa
	where c.idCliente = @idCliente 
	and r.fechaCreacion between @fechaInicio and @fechaFin
	and isnull(rp.precio,0) <> 0
	
		
	create table #preciosPorProducto
	(
		idProducto int,
		precio decimal(18,3),
		cantidad int,
		idCadena int
	)

	insert #preciosPorProducto(idProducto,precio,cantidad,idCadena)
	select idProducto,precio,count(precio),idCadena
	from  #tempReporte 
	group by idProducto,precio,idCadena


	delete p from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto 
				where idProducto = p.idProducto
				and idCadena = p.idCadena
				and cantidad > p.cantidad)

	delete p from #preciosPorProducto p
	where exists(select 1 from #preciosPorProducto 
				where idProducto = p.idProducto
				and idCadena = p.idCadena
				and precio > p.precio)
	
	create table #CadenaProductos
	(idCadena int,
	 idProducto int)
	
	insert #CadenaProductos(idCadena,idProducto)

	select substring(item,0,charindex('-',item)),
		   substring(item,charindex('-',item) + 1,len(item)-charindex('-',item))
	 from dbo.split(@CompetitorArray,';')


	create table #datosFinal
	(
	 idProducto int,
	 maxPrecio decimal(18,3),
	 idProductoCompetencia int,
	 maxPrecioCompetencia decimal(18,3),
	 idCadena int
	 )
		 
	insert #datosFinal (idProducto,maxPrecio,idProductoCompetencia,maxPrecioCompetencia,idcadena)
	select p.idProducto,p.precio,pro.idProducto,p2.precio,p.idCadena From #preciosPorProducto p
	inner join cadena c on c.idCadena = p.idCadena 
	left join ProductoCompetencia ec on ec.idProducto = p.idProducto
	left join #preciosPorProducto p2 on p2.idProducto = ec.IdProductoCompetencia
	and p2.idCadena = p.idCadena
	inner join producto pro on pro.idProducto = p2.idProducto
	and ec.Reporte = 1
	where p.idProducto = @idProducto
	and c.idCadena in(select idCadena from #CadenaProductos where idProducto = @idProducto) 

	create table #final
	(
	id int,
	idCompetitor int,
	name varchar(500),
	gap decimal (18,8),
	idCadena int,
	ordenMath decimal(18,8)
	)

	insert #final(id,idCompetitor,name,gap,idCadena,ordenMath)
	select p.idProducto as id,d.idProductoCompetencia,p.nombre as name,((MaxPrecio / MaxPrecioCompetencia)*100)-100 as gap,
			d.idCadena ,
		 case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end
						as ordenMath
	From #datosFinal d
	inner join producto p on p.idProducto = d.idProducto
	where maxPrecioCompetencia is not null
--	and d.idProductoCompetencia = @idCompetidor
	and exists (select 1 from #CadenaProductos where idProducto = d.idProductoCompetencia
						and idCadena = d.idCadena)

		create table #tempForecast(idProducto int,idCadena int,inventory int, sellin int)

		insert #tempForecast(idProducto,idCadena,inventory,sellin)
		select f.idProducto,f.idCadena,
		sum(isnull(fo.StockInicial,0) +
			isnull(fo.SalesIn,0)+
			isnull(fo.SalesOut,0)),
		sum(isnull(fo.SalesIn,0)) from #datosFinal  f
		inner join forecasting fo
			on fo.idProducto = f.idProducto
			and fo.idCadena = f.idCadena 		
	    where  year(fo.fecha) between year(@fechaInicio) and year(@fechaFin) 
					and month(fo.fecha) between month(@fechaInicio) and MONTH(@FechaFin) 
		group by f.idProducto,f.idCadena

	select	
			c.nombre as account,	
			c.idCadena as accountId,
			0 as aspVariancePercent,
			0 as aspVariancePrice,
			0 as netAsp,
			0 as netAspCondition,
			18 as idealGap,

			pp.idProducto as ownProductId,
			pp.idMarca as ownBrandId,
			
			pp.nombre as ownProductName,
			--mm.nombre as ownBrandName,
			smp.nombre as ownBrandName,
			d.maxPrecio ownProductPrice,
			isnull(fo.inventory,0) as ownProductInventory,
			0 as ownProductModelShare,
			0 as ownProductUBP,
			0 as ownProductUBPP,			 

			pc.idProducto as competitorProductId,
			pc.idMarca as competitorBrandId,
			pc.nombre as competitorProductName,
			--mc.nombre as competitorBrandName,
			smc.nombre as competitorBrandName,
			d.maxPrecioCompetencia competitorProductPrice,
			0 as competitorProductInventory,
			0 as competitorProductModelShare,
			0 as competitorProductUBP,
			0 as competitorProductUBPP,
			f.gap as priceGap
	from #datosFinal d
	inner join #final f on f.id = d.idProducto
		and f.idCadena = d.idCadena
		and f.idCompetitor = d.idProductoCompetencia
	inner join cadena c on c.idCadena = d.idCadena
	inner join producto pp on pp.idProducto = d.idProducto
	inner join marca mm on mm.idMarca = pp.idMarca
	inner join producto pc on pc.idProducto = d.idProductoCompetencia
	inner join marca mc on mc.idMarca = pc.idMarca
	left join SubMarca_Producto smp_p on smp_p.idProducto = pp.idProducto
	left join subMarca smp on smp.idSubMarca = smp_p.idSubMarca and smp.idMarca = pp.idMarca
	left join SubMarca_producto smp_c on smp_c.idProducto = pc.idProducto
	left join subMarca smc on smc.idSubmarca = smp_c.idSubmarca and smc.idMarca = pc.idMarca 
	left join #tempForecast fo on fo.idCadena = c.idCadena
			and fo.idProducto = d.idProducto 
	where d.maxPrecioCompetencia is not null
	order by f.ordenMath asc

END

go

exec GetPriceRequestFormMultipleCompetitor @IdCliente = 178,
	@IdProducto = 12790,
	@CompetitorArray = '4370-12790;4370-14258;4373-12790;4373-14258;4378-12790;4378-14258;4371-12790;4371-14258;4376-12790;4376-14258;4371-12790;4371-14325;4376-12790;4376-14325;4373-12790;4373-14325;4380-12790;4380-14325'
	


--@idCliente = 178 , @producto = 'EPSON L380'


