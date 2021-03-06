SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Calendario_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Calendario_GetAll] AS' 
END
GO
ALTER procedure [dbo].[Calendario_GetAll]
(
	@IdCliente	int=null,
	@IdPuntoDeVenta int=null,
	@IdUsuario	int=null
)
as
begin
	  Select c.Id as Id
			,c.FechaInicio as FechaInicio
			,cl.IdCliente as IdCliente
			,cl.Nombre as NombreCliente
			,pdv.IdPuntoDeVenta as IdPuntoDeVenta
			,pdv.Nombre as NombrePDV
			,u.IdUsuario as IdUsuario
			,u.Nombre as NombreUsuario
			,u.Apellido as ApellidoUsuario
			,pdv.Direccion as DireccionPDV
			,c.ConceptoId as ConceptoId
			,con.Descripcion as ConceptoDescripcion
			,c.Observaciones as Observaciones
	  from Calendario c
	  inner join Cliente cl on cl.IdCliente=c.IdCliente
	  inner join Usuario u on u.IdUsuario=c.IdUsuario
	  inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta = c.IdPuntoDeVenta
	  inner join Usuario_Puntodeventa updv on updv.idusuario=u.idusuario and updv.idPuntoDeVenta=pdv.idpuntodeventa
	  left join CalendarioConceptos con on con.Id = c.ConceptoId
	  where
		(@IdCliente is null or c.IdCliente=@IdCliente)
		and (@IdPuntoDeVenta is null or pdv.IdPuntoDeVenta=@IdPuntoDeVenta)
		and (@IdUsuario is null or u.IdUsuario = @IdUsuario)
		and updv.activo=1
end
GO
