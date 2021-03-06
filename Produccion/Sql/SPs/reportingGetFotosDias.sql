SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[reportingGetFotosDias]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[reportingGetFotosDias] AS' 
END
GO
ALTER procedure [dbo].[reportingGetFotosDias]
	@IdCliente int
	,@Dias int
as
begin
	SET LANGUAGE spanish
	set nocount on

	Select pf.IdPuntoDeVentaFoto, pf.IdPuntoDeVenta, left(ltrim(rtrim(pdv.Nombre)),20) as nombrePuntoDeVenta, ltrim(rtrim(isnull(pf.Comentario,''))) as comentarios, pf.fechaCreacion as fechaCreacion
	from PuntoDeVentaFoto pf
	inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=pf.IdPuntoDeVenta
	inner join Cliente c on c.IdEmpresa=pf.IdEmpresa
	left join Reporte r on r.IdReporte=pf.IdReporte
	where	c.IdCliente=@IdCliente
			and convert(date,pf.FechaCreacion) between convert(date,DATEADD(day,-@Dias,getdate())) and convert(date,GETDATE())
			and pf.Estado=1
	order by pf.IdReporte desc, pf.IdPuntoDeVentaFoto desc
end
GO
