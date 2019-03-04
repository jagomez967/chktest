SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_PuntoDeVenta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_PuntoDeVenta_Add] AS' 
END
GO
ALTER procedure [dbo].[Producto_PuntoDeVenta_Add](
	@idPuntoDeVenta int,
	@idProducto int
)
as
BEGIN

	insert Producto_Puntodeventa(idPuntodeventa,idProducto)
	values (@idPuntodeventa,@idProducto)

END
GO