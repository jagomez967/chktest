SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDatosPop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDatosPop] AS' 
END
GO
ALTER procedure [dbo].[GetDatosPop]
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
	Select	ltrim(rtrim(c.nombre)) as Cliente
			,rp.IdReporte as Reporte
			,r.fechaCreacion as FechaReporte
			,ltrim(rtrim(p.Nombre)) as Pdv
			,ltrim(rtrim(u.Apellido)) + ', '+ ltrim(rtrim(u.Nombre)) collate database_default as Rtm
			,ltrim(rtrim(m.Nombre)) as Marca
			,ltrim(rtrim(pp.nombre)) as Pop
			,isnull(rp.Cantidad,0) as Cantidad
	from ReportePop rp
	inner join pop pp on pp.IdPop=rp.IdPop
	inner join reporte r on r.IdReporte=rp.IdReporte
	inner join Marca m on m.IdMarca = rp.IdMarca
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
			and rp.Cantidad>0
	order by r.fechaCreacion, m.IdMarca, pp.IdPop
end
GO
