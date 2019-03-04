IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetProductRetailGap'))
   exec('CREATE PROCEDURE [dbo].[GetProductRetailGap] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetProductRetailGap]
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
		'Danger'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 < -10.0 then
		'Danger'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between -10.0 and -7.0  then  
		'Warning'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between 30 and 40  then  
		'Warning'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between -7.0 and 0  then  
		'Warning'
		when ((MaxPrecio / MaxPrecioCompetencia)*100)-100 between 20 and 30  then  
		'Warning'
		else '' 
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

	select c.nombre as account,
		   c.idcadena as accountId,
		   f.color as color,
		   pp.nombre as ownProductName,
		   pp.IdProducto as ownProductId,
		   d.maxPrecio as ownPrice,
		   pc.nombre as competitorName,
		   pc.IdProducto as competitorProductId,
		   d.maxPrecioCompetencia as competitorPrice,
		   f.gap as priceGap
	from #datosFinal d
	inner join #final f on f.id = d.idProducto
		and f.idCadena = d.idCadena
		and f.idCompetitor = d.idProductoCompetencia
	inner join cadena c on c.idCadena = d.idCadena
	inner join producto pp on pp.idProducto = d.idProducto
	inner join producto pc on pc.idProducto = d.idProductoCompetencia
	where d.maxPrecioCompetencia is not null
	and pp.nombre = isnull(@producto,pp.nombre) collate database_default
	order by orderMath asc
END

go

GetProductRetailGap @idCliente = 178 , @producto = 'EPSON L380'

