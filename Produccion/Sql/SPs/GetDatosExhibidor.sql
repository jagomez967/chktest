SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDatosExhibidor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDatosExhibidor] AS' 
END
GO
ALTER procedure [dbo].[GetDatosExhibidor]
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

	Select ltrim(rtrim(c.nombre)) as Cliente
			,re.IdReporte as Reporte
			,r.fechaCreacion as FechaReporte
			,ltrim(rtrim(p.Nombre)) as Pdv
			,ltrim(rtrim(u.Apellido)) + ', '+ ltrim(rtrim(u.Nombre)) collate database_default as Rtm
			,ltrim(rtrim(m.Nombre)) as Marca
			,ltrim(rtrim(e.Nombre)) as Exhibidor
			,cast(isnull(re.cantidad,0) as numeric(18,0)) as Cantidad
	from ReporteExhibicion re
	inner join reporte r on r.IdReporte=re.IdReporte
	inner join Marca m on m.IdMarca = re.IdMarca
	inner join Exhibidor e on e.IdExhibidor=re.IdExhibidor
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
			and re.Cantidad>0
	order by r.fechaCreacion, m.IdMarca, e.IdExhibidor, re.cantidad
end
GO
