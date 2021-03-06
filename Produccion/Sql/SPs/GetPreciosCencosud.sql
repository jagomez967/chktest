SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPreciosCencosud]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetPreciosCencosud] AS' 
END
GO
ALTER procedure [dbo].[GetPreciosCencosud]
	 @IdEmpresa int
	,@IdCadena varchar(max) = NULL
	,@IdPuntoDeVenta varchar(max) = NULL
	,@IdLocalidad varchar(max) = NULL
	,@IdZona varchar(max) = NULL
	,@IdUsuario varchar(max) = NULL
	,@FechaDesde datetime = null
	,@FechaHasta datetime = null
as
begin
--exec GetPreciosCencosud 21
	set nocount on
	
	declare @idCliente int
	select @idCliente = idcliente from Cliente where IdEmpresa=@IdEmpresa
	
	create table #datos
	(
		idReporte int,
		idProducto int,
		descr_base varchar(200),
		tipo_prod varchar(4),
		stock varchar(1),
		noTrabaja varchar(1),
		precio decimal(18,3),
		cantidad int,
		idExhibidor int
	)

	insert #datos(idReporte, idProducto, descr_base, tipo_prod, stock, noTrabaja, precio, cantidad, idExhibidor)
	select r.IdReporte, p.idproducto,ltrim(rtrim(left(LTRIM(rtrim(p.Nombre)),LEN(LTRIM(rtrim(p.Nombre)))-4))),ltrim(rtrim(right(LTRIM(rtrim(p.Nombre)),4))),rp.Stock,rp.NoTrabaja,rp.Precio,rp.Cantidad,rp.IdExhibidor
	from ReporteProducto rp
	inner join Producto p on p.IdProducto=rp.IdProducto
	inner join Reporte r on r.IdReporte=rp.IdReporte
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta
	where r.IdEmpresa= @IdEmpresa
			and len(p.nombre)>4
			AND (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
			ANd (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
			AND (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
			AND (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
			AND (@IdUsuario is NULL OR r.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))
			and (@FechaDesde is null or convert(varchar,R.FechaCreacion,112)>=convert(varchar,@FechaDesde,112))
			and (@FechaHasta is null or convert(varchar,R.FechaCreacion,112)<=convert(varchar,@FechaHasta,112))
	order by r.IdReporte, p.idproducto
	
	create table #ProductosBase
	(
		id int identity(1,1),
		idReporte int,
		descr_base varchar(200)
	)

	CREATE NONCLUSTERED INDEX [tmp_productosBase_idx] ON #ProductosBase ([descr_base] ASC)
	CREATE NONCLUSTERED INDEX [tmp_datos_idx] ON #datos ([descr_base] ASC, [tipo_prod] ASC)

	insert #ProductosBase (idReporte, descr_base) select distinct idReporte, descr_base from #datos
	--select distinct ltrim(rtrim(left(LTRIM(rtrim(p.Nombre)),LEN(LTRIM(rtrim(p.Nombre)))-4)))
	--from Producto p
	--inner join #datos d on d.idProducto=p.IdProducto

	create table #resultado
	(
		idReporte int,
		fecha varchar(10),
		idCliente int,
		producto varchar(200),
		stockPR varchar(1),
		stockPO varchar(1),
		stockPT varchar(1),
		noTrabajaPR varchar(1),
		noTrabajaPO varchar(1),
		noTrabajaPT varchar(1),
		precioPR decimal(18,3),
		precioPO decimal(18,3),
		precioPT decimal(18,3),
		cantidadPR decimal(18,3),
		cantidadPO decimal(18,3),
		cantidadPT decimal(18,3),
		idExhibidorPR int,
		idExhibidorPO int,
		idExhibidorPT int
	)

	declare @id int
	declare @fecha varchar(10)
	declare @idReporte int
	declare @stockPR varchar(1)
	declare @stockPO varchar(1)
	declare @stockPT varchar(1)
	declare @noTrabajaPR varchar(1)
	declare @noTrabajaPO varchar(1)
	declare @noTrabajaPT varchar(1)
	declare @precioPR decimal(18,3)
	declare @precioPO decimal(18,3)
	declare @precioPT decimal(18,3)
	declare @cantidadPR decimal(18,3)
	declare @cantidadPO decimal(18,3)
	declare @cantidadPT decimal(18,3)
	declare @idExhibidorPR int
	declare @idExhibidorPO int
	declare @idExhibidorPT int
	declare @descr_base varchar(200)
	while(exists(select 1 from #ProductosBase))
	begin
		select top 1 @id = id, @idReporte=idReporte, @descr_base=descr_base from #ProductosBase

		select @fecha = convert(varchar,FechaCreacion,103) from reporte where IdReporte=@idReporte

		select @precioPR=precio, @cantidadPR=cantidad, @idExhibidorPR=idExhibidor, @stockPR=stock, @noTrabajaPR=noTrabaja from #datos where descr_base=@descr_base and tipo_prod='(PR)' and idReporte=@idReporte
		select @precioPO=precio, @cantidadPO=cantidad, @idExhibidorPO=idExhibidor, @stockPO=stock, @noTrabajaPO=noTrabaja from #datos where descr_base=@descr_base and tipo_prod='(PO)' and idReporte=@idReporte
		select @precioPT=precio, @cantidadPT=cantidad, @idExhibidorPT=idExhibidor, @stockPT=stock, @noTrabajaPT=noTrabaja from #datos where descr_base=@descr_base and tipo_prod='(PT)' and idReporte=@idReporte
		
		insert #resultado(idreporte, fecha, idCliente,producto,stockPR, stockPO, stockPT,noTrabajaPR, noTrabajaPO, noTrabajaPT,precioPR,precioPO,precioPT,cantidadPR,cantidadPO,cantidadPT,idExhibidorPR,idExhibidorPO,idExhibidorPT)
		values (@idReporte, @fecha, @idCliente, @descr_base, @stockPR, @stockPO, @stockPT, @noTrabajaPR, @noTrabajaPO, @noTrabajaPT, @precioPR, @precioPO, @precioPT, @cantidadPR, @cantidadPO, @cantidadPT, @idExhibidorPR, @idExhibidorPO, @idExhibidorPT)
		
		delete from #ProductosBase where id=@id
	end
	
	select	r.idReporte as IdReporte
			,r.fecha as Fecha
			,c.Nombre as Cliente
			,r.producto as Producto
			,r.stockPR as StockPR
			,r.stockPO as StockPO
			,r.stockPT as StockPT
			,r.noTrabajaPR as TrabajaPR
			,r.noTrabajaPO as TrabajaPO
			,r.noTrabajaPT as TrabajaPT
			,isnull(r.precioPR,0) as PrecioPR
			,isnull(r.precioPO,0) as PrecioPO
			,isnull(r.precioPT,0) as PrecioPT
			,isnull(r.cantidadPR,0) as CantidadPR
			,isnull(r.cantidadPO,0) as CantidadPO
			,isnull(r.cantidadPT,0) as CantidadPT
			,e.Nombre as ExhibidorPR
			,e2.Nombre as ExhibidorPO
			,e3.Nombre as ExhibidorPT
	from #resultado r
	inner join cliente c on c.IdCliente=r.idCliente
	left join Exhibidor e on e.IdExhibidor = r.idExhibidorPR
	left join Exhibidor e2 on e.IdExhibidor = r.idExhibidorPO
	left join Exhibidor e3 on e.IdExhibidor = r.idExhibidorPT
	order by r.producto, r.idReporte
end
GO
