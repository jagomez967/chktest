SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInfoPDV]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInfoPDV] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInfoPDV]
(
	@idPuntoDeVenta int
)
AS
BEGIN
	select pdv.RazonSocial,
		   c.Nombre as Categoria,
		   cd.nombre as Cadena,
		   pdv.Direccion,
		   pdv.Nombre ,
		   pdv.Telefono,
		   pdv.PlaceID,
		   pdv.CodigoPostal,
		   pdv.Contacto,
		   pdv.Email
	From PuntoDeVenta pdv
	left join Categoria c on pdv.IdCategoria = c.IdCategoria 
	left join  Cadena cd on cd.idCadena = pdv.IdCadena 
	where pdv.IdPuntoDeVenta = @idPuntoDeVenta 
END
GO
