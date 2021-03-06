SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDatosConsolidadosProductosComp]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDatosConsolidadosProductosComp] AS' 
END
GO
ALTER procedure [dbo].[spGetDatosConsolidadosProductosComp]
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

	--exec spGetDatosConsolidadosProductosComp 21, null, null, null, null, null, null, null
	declare @leyendaPrecio varchar(max)
	declare @leyendaExh1 varchar(max)
	declare @leyendaFrentes1 varchar(max)
	declare @leyendaFrentes2 varchar(max)
	declare @IdCliente int

	select @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa

	SELECT
		ltrim(rtrim(isnull(C.Nombre,''))) as Cliente
		,ltrim(rtrim(str(isnull(PDV.Codigo,0)))) + ' - ' + ltrim(rtrim(isnull(PDV.Nombre,''))) as PDV
		,ltrim(rtrim(isnull(P.Nombre,''))) as Producto
		,R.FechaCreacion as FechaUSO
		,isnull(RP.Cantidad,0) as Cantidad1
		,isnull(E1.Nombre,'0') as Exh1
		,isnull(RP.Cantidad2,0) as Cantidad2
	FROM Producto P 	
	LEFT JOIN ReporteProductoCompetencia RP ON (P.IdProducto = RP.IdProducto)
	inner join Marca M on M.IdMarca = P.IdMarca
	inner join Reporte R on R.IdReporte = RP.IdReporte
	inner join Cliente C on C.IdEmpresa = R.IdEmpresa
	inner join PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
	left join Exhibidor E1 on E1.IdExhibidor = RP.IdExhibidor
	left join Exhibidor E2 on E2.IdExhibidor = RP.IdExhibidor2
	WHERE	P.Reporte=1
			and C.IdCliente = @IdCliente
			AND (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
			ANd (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
			AND (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
			AND (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
			and (@FechaDesde is null or convert(varchar,R.FechaCreacion,112)>=convert(varchar,@FechaDesde,112))
			and (@FechaHasta is null or convert(varchar,R.FechaCreacion,112)<=convert(varchar,@FechaHasta,112))
			and (isnull(RP.Cantidad,0)>0 or isnull(E1.Nombre,'')<>'' or isnull(RP.Cantidad2,0)>0)
	order by 1,2,3,4

end
GO
