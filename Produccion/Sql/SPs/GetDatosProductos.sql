SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDatosProductos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDatosProductos] AS' 
END
GO
ALTER procedure [dbo].[GetDatosProductos]
(
	 @IdEmpresa int
	,@IdCadena varchar(max) = NULL
	,@IdPuntoDeVenta varchar(max) = NULL
	,@IdLocalidad varchar(max) = NULL
	,@IdZona varchar(max) = NULL
	,@IdUsuario varchar(max) = NULL
	,@FechaDesde datetime = null
	,@FechaHasta datetime = null
)
as
begin

	declare @IdCliente int
	select @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa

	Select	ltrim(rtrim(c.nombre)) as Cliente
			,rp.IdReporte as Reporte
			,r.fechaCreacion as FechaReporte
			,ltrim(rtrim(p.Nombre)) as Pdv
			,ltrim(rtrim(u.Apellido)) + ', '+ ltrim(rtrim(u.Nombre)) collate database_default as Rtm
			,ltrim(rtrim(m.Nombre)) as Marca
			,ltrim(rtrim(prod.Nombre)) as Producto
			,isnull(rp.cantidad,0) as Frente1
			,ltrim(rtrim(e.nombre)) as Exhibidor1
			,isnull(rp.cantidad2,0) as Frente2
			,ltrim(rtrim(e2.nombre)) as Exhibidor2
	from ReporteProducto rp
	inner join producto prod on prod.IdProducto=rp.IdProducto
	inner join reporte r on r.IdReporte=rp.IdReporte
	inner join Marca m on m.IdMarca = prod.IdMarca
	left join Exhibidor e on e.IdExhibidor=rp.IdExhibidor
	left join Exhibidor e2 on e2.IdExhibidor=rp.IdExhibidor2
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join usuario u on u.IdUsuario=r.IdUsuario
	inner join cliente c on c.IdEmpresa=r.IdEmpresa
	where	r.IdEmpresa=@idEmpresa
			AND (@IdCadena is NULL OR p.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
			ANd (@IdPuntoDeVenta is NULL OR p.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
			AND (@IdLocalidad is NULL OR p.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
			AND (@IdZona is NULL OR p.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
			and (@FechaDesde is null or convert(varchar,R.FechaCreacion,112)>=convert(varchar,@FechaDesde,112))
			and (@FechaHasta is null or convert(varchar,R.FechaCreacion,112)<=convert(varchar,@FechaHasta,112))
			and (rp.Cantidad>0 or rp.Cantidad2>0)
	order by r.fechaCreacion, m.IdMarca, e.IdExhibidor, rp.IdProducto
end
GO
