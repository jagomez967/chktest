IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetProductGap'))
   exec('CREATE PROCEDURE [dbo].[GetProductGap] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetProductGap]
(
	@IdCliente			int
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
		on pdv.idPuntodeventa = r.IdPuntoDeVenta
	where c.idCliente = @idCliente 
	and r.fechaCreacion between @fechaInicio and @fechaFin
	and isnull(rp.precio,0) <> 0
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

	 
	 insert #datosFinal (idProducto,maxPrecio,idProductoCompetencia,idCadena)
	 select pp.idProducto, max(pp.precio),ec.idProductoCompetencia,pp.idCadena
	 from #preciosPorProducto pp
	 inner join producto p on p.idProducto = pp.idProducto	 
	 left join ProductoCompetencia ec on ec.idProducto = pp.idProducto
	 where pp.idProducto in (select smp.idProducto from SubMarca s 
								inner join subMarca_Producto smp 
									on smp.idSubmarca = s.idSubMarca 
								where s.idSubMarca = 100)
	 and ec.reporte = 1
	 group by p.idFamilia,pp.idProducto,ec.idProductoCompetencia,pp.idCadena

	 update d
	 set maxPrecioCompetencia = pp.precio
	 from #datosFinal d
	 inner join #preciosPorProducto pp
	 on d.idProductoCompetencia = pp.idProducto	 
	 and d.idCadena = pp.idCadena
	 where not exists (select 1 from #PreciosPorProducto where idProducto = pp.idProducto
								and idCadena = pp.idCadena and pp.precio < precio)

	create table #final
	(id int,
	name varchar(500),
	gap decimal (18,8),
	color varchar(100),
	orderMath decimal(18,8),
	idCadena int)

	insert #final(id,name,gap,color,orderMath,idCadena)
	select p.idProducto as id,p.nombre as name,((MaxPrecio / MaxPrecioCompetencia)*100)-100 as gap,
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
						as ordenMath,max(idCadena)
	From #datosFinal d
	inner join producto p on p.idProducto = d.idProducto
	where maxPrecioCompetencia is not null
	group by d.maxPrecio,p.idProducto,d.maxPrecioCompetencia,p.nombre
	order by p.idproducto,ordenMath


	delete f 
	from #final f
	where exists(select 1 from #final where id = f.id
				and orderMath < f.orderMath)

	select id,name,gap,color From #final order by orderMath asc
END

go
[GetProductGap] 219






