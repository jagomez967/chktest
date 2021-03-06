SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_GetReporteExcel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_GetReporteExcel] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferProceso_GetReporteExcel] 
	@IdEmpresa int
   ,@IdTransferProceso int
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT --T.IdTransfer
	       RTN.Numero AS IdTransfer
		  ,DPDV.Codigo AS CodigoCliente
		  ,PDV.Nombre AS NombreCliente
		  ,DPP.Codigo AS CodigoProducto
		  ,PP.Nombre
		  ,PP.CodigoEAN
		  ,RT.Cantidad
	FROM dbo.TransferItem TI
	INNER JOIN dbo.Transfer AS T ON (T.IdTransfer = TI.IdTransfer)	
	INNER JOIN dbo.TransferProceso AS TP ON (TP.IdTransferProceso = T.IdTransferProceso AND T.IdTransferProceso = @IdTransferProceso)
	INNER JOIN dbo.ReporteTransfer AS RT ON (RT.IdReporte = T.IdReporte AND RT.IdProductoPedido = TI.IdProductoPedido)
	INNER JOIN dbo.ReporteTransferNumero AS RTN ON (RT.IdReporte = RTN.IdReporte AND  RT.IdDrogueria = RTN.IdDrogueria)
	INNER JOIN dbo.ReporteTransferCabecera AS RTC ON (RTC.IdReporteTransferCabecera = RT.IdReporte AND RTC.IdEmpresa = @IdEmpresa)	
	-- INNER JOIN dbo.Reporte AS R ON (R.IdReporte = RT.IdReporte AND R.IdEmpresa = @IdEmpresa)	
	INNER JOIN dbo.ProductoPedido AS PP ON (RT.IdProductoPedido = PP.IdProductoPedido)
	LEFT JOIN dbo.Drogueria_ProductoPedido DPP ON (DPP.IdDrogueria = RT.IdDrogueria and DPP.IdProductoPedido = PP.IdProductoPedido)
	LEFT JOIN dbo.Drogueria_PuntoDeVenta DPDV ON (DPDV.IdDrogueria = RT.IdDrogueria AND DPDV.IdPuntoDeVenta = RTC.IdPuntoDeVenta)
	INNER JOIN dbo.PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = RTC.IdPuntoDeVenta)
	
END
GO
