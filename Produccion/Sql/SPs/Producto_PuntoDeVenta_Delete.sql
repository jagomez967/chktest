SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_PuntoDeVenta_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_PuntoDeVenta_Delete] AS' 
END
GO
ALTER procedure [dbo].[Producto_PuntoDeVenta_Delete](
	@id int
)
as
BEGIN

	delete from producto_Puntodeventa 
	where id = @id

END
GO
