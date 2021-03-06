SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltros]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltros] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltros]
(
	@IdCliente int,
	@idModulo int
)
as
begin
	select r.id, r.identificador, r.nombre, r.storedProcedure, r.tipoFiltro
	from ReportingFiltros r
	inner join ReportingFiltrosModulo rf on rf.idfiltro = r.id
	inner join ReportingFiltrosCliente rc on rc.idcliente=rf.idcliente and rc.idfiltro=rf.idfiltro
	where rf.idCliente=@IdCliente
	and rf.idModulo=@idModulo
	order by r.id
end

GO

