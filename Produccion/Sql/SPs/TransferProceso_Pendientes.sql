SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_Pendientes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_Pendientes] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferProceso_Pendientes]
	@IdEmpresa int
AS
	BEGIN
SELECT        DR.IdDrogueria, D.Nombre, COUNT(*) AS Cantidad
FROM            (SELECT        RT.IdDrogueria, RT.IdReporte                 
				 FROM            ReporteTransfer AS RT
				 INNER JOIN ReporteTransferCabecera AS RTC ON (RTC.IdReporteTransferCabecera = RT.IdReporte and RTC.IdEmpresa = @IdEmpresa)
				 WHERE        (NOT EXISTS
                              (SELECT        T.IdTransfer, T.IdTransferProceso, T.IdReporte
                               FROM            Transfer AS T INNER JOIN
                                                         TransferProceso AS TP ON (T.IdTransferProceso = TP.IdTransferProceso AND RT.IdDrogueria = TP.IdDrogueria)
                               WHERE        (T.IdReporte = RT.IdReporte)))
							   GROUP BY IdDrogueria, RT.IdReporte) AS DR INNER JOIN
                               Drogueria AS D ON D.IdDrogueria = DR.IdDrogueria
GROUP BY DR.IdDrogueria, D.Nombre

END
GO
