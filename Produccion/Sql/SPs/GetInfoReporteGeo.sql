SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInfoReporteGeo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetInfoReporteGeo] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetInfoReporteGeo]
(
	@idReporte int
)
AS
BEGIN
	select r.idReporte,
		   p.Nombre as puntoDeVenta,
		   c.Nombre as categoria,
		   cd.Nombre as cadena,
		   p.RazonSocial,
		   p.Direccion ,
		   u.Apellido + ', ' + u.Nombre collate database_default as usuario,
		   1 as idPuntoDeVenta,
		   r.FechaCreacion,
		   r.FechaCierre,
		   r.FechaEnvio,
		   r.FechaRecepcion,
		   r.FechaActualizacion,
		   case when firma is null then 0
		   else 1
		   end as firma
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta = r.IdPuntoDeVenta 
	inner join usuario u on u.idUsuario = r.idUsuario
	left join Categoria c on c.idCategoria = p.IdCategoria 
	left join Cadena cd on cd.idCadena = p.idCadena 
	where r.idReporte = @idReporte
END
GO

