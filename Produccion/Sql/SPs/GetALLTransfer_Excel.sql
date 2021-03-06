SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetALLTransfer_Excel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetALLTransfer_Excel] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetALLTransfer_Excel]
	@IdTransferProceso int

AS
	BEGIN
	SELECT        TI.IdTransfer, DPDV.Codigo AS Cliente, PDV.Nombre, TI.IdProductoPedido, PP.Nombre AS Descripcion, TI.Cantidad
FROM            TransferItem AS TI INNER JOIN
                         Transfer AS T ON T.IdTransfer = TI.IdTransfer INNER JOIN
                         TransferProceso AS TP ON TP.IdTransferProceso = T.IdTransferProceso AND TP.IdTransferProceso = @IdTransferProceso INNER JOIN
                         ProductoPedido AS PP ON PP.IdProductoPedido = TI.IdProductoPedido INNER JOIN
                         Reporte AS R ON R.IdReporte = T.IdReporte INNER JOIN
                         PuntoDeVenta AS PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta INNER JOIN
                         Drogueria_PuntoDeVenta AS DPDV ON DPDV.IdPuntoDeVenta = R.IdPuntoDeVenta AND DPDV.IdDrogueria = 1
	END
GO
