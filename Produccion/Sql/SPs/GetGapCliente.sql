IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetGapCliente'))
   exec('CREATE PROCEDURE [dbo].[GetGapCliente] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetGapCliente] 
(
	@IdCliente			int,
	@producto varchar(100) = null
)
AS
BEGIN

	declare @fechaInicio datetime = dateadd(week,-1,getdate())
	declare @fechaFin datetime = getdate()
	
	create table #tempReporte
	(idProducto int,precio decimal(18,3),idCadena int)
	
	insert #tempReporte(idProducto,precio,idCadena)
	select rp.idProducto,rp.precio,pdv.idCadena
	from reporte r
	inner join puntodeventa pdv 
		on pdv.idPuntodeventa = r.idPuntodeventa
	inner join reporteProducto rp
		on r.idReporte = rp.idReporte
	inner join producto p
		on p.idProducto = rp.idProducto
	where pdv.idCliente = @idCliente 
	and r.fechaCreacion between @fechaInicio and @fechaFin
	and rp.precio > 0
	and p.idMarca in (select idMarca from marca where nombre like '%printers%')



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
	
	

	create table #final
	(id int,
	idCompetitor int,
	name varchar(500),
	gap decimal (18,8),
	color varchar(100),
	orderMath decimal(18,8),
	idCadena int)

	insert #final(id,idCompetitor,name,gap,color,orderMath,idCadena)
	select p.idProducto as id,d.idProductoCompetencia,p.nombre as name,((MaxPrecio / MaxPrecioCompetencia)*100)-100 as gap,
	 case when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 > 40.0 then
		'red'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 < -10.0 then
		'red'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between -10.0 and -7.0  then  
		'gold'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between 30 and 40  then  
		'gold'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between -7.0 and 0  then  
		'gold'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between 20 and 30  then  
		'gold'
		else 'limegreen' 
	end	as color,
	 case when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) >= 10
						then -4*(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) + 80  
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) = 200
						then 200
					when isnull(((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100,200) <= 10	
						then (((d.MaxPrecio / d.MaxPrecioCompetencia)*100)-100) * 4
					end
						as ordenMath,
			d.idCadena 
	From #datosFinal d
	inner join producto p on p.idProducto = d.idProducto
	where maxPrecioCompetencia is not null
	order by p.idproducto,ordenMath
	

	delete f 
	from #final f
	where exists(select 1 from #final where id = f.id
				and idCompetitor = f.idCompetitor
				and f.idCadena = idCadena 
				and orderMath < f.orderMath)

		create table #tempForecast(idProducto int,idCadena int,inventory int, sellin int)


		insert #tempForecast(idProducto,idCadena,inventory,sellin)
		select f.idProducto,f.idCadena,
		sum(isnull(fo.ChannelInv,0)),
		sum(isnull(fo.SalesIn,0)) from #datosFinal  f
		inner join forecasting fo
			on fo.idProducto = f.idProducto
			and fo.idCadena = f.idCadena 		
	    where cast(fo.fecha as date) between cast(@fechaInicio as date) and cast(@fechaFin as date)
		and not exists(select 1 from forecasting where idProducto = fo.idProducto and  idCadena = fo.idCadena 
						and fecha > fo.fecha) 
		group by f.idProducto,f.idCadena
		if(@@rowcount = 0)
		BEGIN
		insert #tempForecast(idProducto,idCadena,inventory,sellin)
		select f.idProducto,f.idCadena,
		sum(isnull(fo.ChannelInv,0)),
		sum(isnull(fo.SalesIn,0)) from #datosFinal  f
		inner join forecasting fo
			on fo.idProducto = f.idProducto
			and fo.idCadena = f.idCadena 		
	    where year(fo.fecha) = year(getdate()) 
		and month(fo.fecha) = month(getdate())	
		group by f.idProducto,f.idCadena
		END


	select d.idcadena as IdCadena,
		   pp.IdProducto as IdProducto,
		   pc.IdProducto as IdCompetencia,
		   d.maxPrecio as PrecioPropio,
		   d.maxPrecioCompetencia as PrecioCompetencia,
		   f.gap as Gap,
		   f.color as color,
		   isnull(fo.sellin,0) as SellIn,
		   isnull(fo.inventory,0) as Inventory, 
		   orderMath
	from #datosFinal d
	inner join #final f on f.id = d.idProducto
		and f.idCadena = d.idCadena
		and f.idCompetitor = d.idProductoCompetencia
	inner join producto pp on pp.idProducto = d.idProducto
	inner join producto pc on pc.idProducto = d.idProductoCompetencia
	left join #tempForecast fo on fo.idProducto = d.idProducto and fo.idCadena = d.idCadena
	where d.maxPrecioCompetencia is not null
	and fo.inventory > 0
	order by f.orderMath asc

	select distinct c.IdCadena, c.Nombre,C.logo as Imagen 
	from #datosFinal d 
	inner join cadena c on c.idCadena = d.idCadena 


	select distinct p.IdProducto,p.Nombre,p.Imagen From #datosFinal d
	inner join producto p on p.idProducto = d.idProducto
	union
	select distinct p.IdProducto,p.Nombre,p.Imagen From #datosFinal d
	inner join producto p on p.idProducto = d.idProductoCompetencia
END

go