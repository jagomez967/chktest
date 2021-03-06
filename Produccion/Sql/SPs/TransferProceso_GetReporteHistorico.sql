SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_GetReporteHistorico]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_GetReporteHistorico] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferProceso_GetReporteHistorico] 
	@IdEmpresa int
   ,@IdTransferProceso int = NULL
   ,@FechaCreacionDesde datetime = NULL
   ,@FechaCreacionHasta datetime = NULL
   ,@FechaEnvioDesde datetime = NULL   
   ,@FechaEnvioHasta datetime = NULL   
   ,@NumeroTransfer varchar(50) = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdDrogueria int = NULL
   ,@IdUsuario int = NULL
   ,@IdReporte int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CONVERT(VARCHAR(10), RTC.FechaCreacion, 103) AS FechaCarga
	      ,CONVERT(VARCHAR(10), TP.Fecha, 103) AS FechaEnvio 
	      ,RTN.Numero AS IdTransfer
		  ,DPDV.Codigo AS CodigoCliente
		  ,PDV.Nombre AS NombreCliente
		  ,DPP.Codigo AS CodigoProducto
		  ,PP.CodigoEAN
		  ,PP.Nombre		  
		  ,RT.Cantidad
		  ,DRO.Nombre AS NombreDrogueria
		  ,U.Nombre AS NombreUsuario
		  ,TP.IdTransferProceso AS NumeroReferencia
		  ,RTC.IdReporteTransferCabecera AS NumeroReporte		  
	FROM dbo.TransferItem TI
	INNER JOIN dbo.Transfer AS T ON (T.IdTransfer = TI.IdTransfer)	
	INNER JOIN dbo.TransferProceso AS TP ON (TP.IdTransferProceso = T.IdTransferProceso AND (@IdTransferProceso IS NULL OR T.IdTransferProceso = @IdTransferProceso))
	INNER JOIN dbo.ReporteTransfer AS RT ON (RT.IdReporte = T.IdReporte AND RT.IdProductoPedido = TI.IdProductoPedido)
	INNER JOIN dbo.ReporteTransferNumero AS RTN ON (RT.IdReporte = RTN.IdReporte AND  RT.IdDrogueria = RTN.IdDrogueria AND (@NumeroTransfer IS NULL OR @NumeroTransfer = RTN.Numero))
	--INNER JOIN dbo.Reporte AS R ON (R.IdReporte = RT.IdReporte AND R.IdEmpresa = @IdEmpresa AND (@IdReporte IS NULL OR @IdReporte = R.IdReporte))	
	INNER JOIN dbo.ReporteTransferCabecera  AS RTC ON (RTC.IdReporteTransferCabecera = RT.IdReporte AND RTC.IdEmpresa = @IdEmpresa AND (@IdReporte IS NULL OR @IdReporte = RTC.IdReporteTransferCabecera))	
	INNER JOIN dbo.ProductoPedido AS PP ON (RT.IdProductoPedido = PP.IdProductoPedido)
	INNER JOIN dbo.Drogueria AS DRO ON (DRO.IdDrogueria = TP.IdDrogueria AND (@IdDrogueria IS NULL OR @IdDrogueria = DRO.IdDrogueria))
	LEFT JOIN dbo.Drogueria_ProductoPedido DPP ON (DPP.IdDrogueria = RT.IdDrogueria and DPP.IdProductoPedido = PP.IdProductoPedido)
	LEFT JOIN dbo.Drogueria_PuntoDeVenta DPDV ON (DPDV.IdDrogueria = RT.IdDrogueria AND DPDV.IdPuntoDeVenta = RTC.IdPuntoDeVenta)
	INNER JOIN dbo.PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = RTC.IdPuntoDeVenta AND (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.IdPuntoDeVenta))
	INNER JOIN  dbo.Usuario U ON (U.IdUsuario = RTC.IdUsuario AND (@IdUsuario IS NULL OR @IdUsuario = U.IdUsuario))
	ORDER BY RTC.FechaCreacion, TP.Fecha, DRO.Nombre, RTN.Numero
	
END
GO
