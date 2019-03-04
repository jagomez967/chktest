SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_PuntoDeVenta_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_PuntoDeVenta_Update] AS' 
END
GO
ALTER procedure [dbo].[Producto_PuntoDeVenta_Update](
	@id int,
	@idPuntoDeVenta int,
	@idProducto int
)
as
BEGIN

	update producto_Puntodeventa 
	set idPuntodeventa = isnull(@idPuntodeventa,idPuntodeventa),
		idProducto = isnull(@idProducto,idProducto)
	where id = @id

END
GO
