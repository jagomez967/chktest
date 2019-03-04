SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_PuntoDeVenta_GetAll] AS' 
END
GO
ALTER procedure [dbo].[Producto_PuntoDeVenta_GetAll](
	@idPuntoDeVenta int = null
)
as
BEGIN
	declare @idCliente int
	declare @idEmpresa int

	select null as Id, null as Nombre
	return

	if exists(select 1 from producto_Puntodeventa where idPuntodeventa = @idPuntoDeVenta)
	BEGIN
		select p.idProducto as Id, p.nombre as Nombre
		from producto p 
		inner join producto_Puntodeventa pp on pp.idProducto = p.idProducto
		where pp.idPuntodeventa = @idPuntoDeVenta 
		AND P.REPORTE= 1
	END
	ELSE
	BEGIN
		select @idCliente = idCliente from puntodeventa where idPuntodeventa = @idPuntodeventa 
		select @idEmpresa = idEmpresa from cliente where idCliente = @idCLiente

		select p.idProducto as Id, p.nombre as Nombre
		from producto p
		inner join marca m on m.idMarca = p.idMarca
		where m.idEmpresa = @idEmpresa
		AND P.REPORTE= 1
		union
		select p.idProducto as Id, p.nombre as Nombre
		from producto p
		inner join marcaCompetencia mc on mc.idMarcaCompetencia = p.idMarca
		inner join marca m on m.idMarca = mc.idMarca
		where m.idEmpresa = @idEmpresa 
		and p.reporte = 1
	END
END
GO

