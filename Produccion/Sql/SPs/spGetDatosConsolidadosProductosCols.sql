SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetDatosConsolidadosProductosCols]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[spGetDatosConsolidadosProductosCols] AS' 
END
GO
ALTER procedure [dbo].[spGetDatosConsolidadosProductosCols]
(
	 @IdEmpresa int
)
as
begin
	--exec spGetDatosConsolidadosProductosCols 21
	declare @leyendaExh1 varchar(max)
	declare @leyendaFrentes1 varchar(max)
	declare @leyendaFrentes2 varchar(max)
	declare @IdCliente int

	select @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa

	select @leyendaExh1 = isnull(MMC.Leyenda, '') from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 11 and isnull(MMC.Visibilidad,0)=1
	select @leyendaFrentes1 = isnull(MMC.Leyenda, '') from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 9 and isnull(MMC.Visibilidad,0)=1
	select @leyendaFrentes2 = isnull(MMC.Leyenda, '') from M_ModuloCliente MC inner join M_ModuloClienteItem MMC on MMC.IdModuloCliente = MC.IdModuloCliente where MC.IdCliente = @IdCliente and MC.IdModulo = 3 and MMC.IdModuloItem = 13 and isnull(MMC.Visibilidad,0)=1

	select 'Cliente' as Cliente
			,'Punto de Venta' as PDV
			,'Producto' as Producto
			,'FechaUSO' as FechaUSO
			,@leyendaFrentes1 as Cantidad1
			,@leyendaExh1 as Exh1
			,@leyendaFrentes2 as Cantidad2
end
GO
