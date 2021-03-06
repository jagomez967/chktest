SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferProceso_PendientesDrogueria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TransferProceso_PendientesDrogueria] AS' 
END
GO
ALTER PROCEDURE [dbo].[TransferProceso_PendientesDrogueria]
	 @IdDrogueria int
	,@IdEmpresa int

AS
	BEGIN
--	SELECT      RT.IdReporte, 
--				PDV.IdPuntoDeVenta , 
--				PDV.Nombre AS NombrePDV, 
--				RTC.FechaCreacion, 
--				U.Nombre AS NombreUsuario, 
--				RTN.Numero AS NumeroTransfer,
--				CASE RTN.VentaTelefonica
--				  WHEN 1 THEN 'Telefónica'
--				  ELSE 'Presencial'
--				END VentaTelefonica
--	FROM        ReporteTransfer AS RT
--                INNER JOIN ReporteTransferCabecera AS RTC ON (RTC.IdReporteTransferCabecera = RT.IdReporte AND RTC.IdEmpresa = @IdEmpresa)	
--                INNER JOIN ReporteTransferNumero AS RTN ON (RTN.IdReporte = RT.IdReporte AND RTN.IdDrogueria = @IdDrogueria)
--                INNER JOIN PuntoDeVenta AS PDV ON (PDV.IdPuntoDeVenta = RTC.IdPuntoDeVenta)
--                INNER JOIN Usuario AS U ON U.IdUsuario = RTC.IdUsuario
--WHERE        (RT.IdDrogueria = @IdDrogueria) AND
--                             (NOT EXISTS
--                              (SELECT        T.IdTransfer, T.IdTransferProceso, T.IdReporte
--                               FROM            Transfer AS T INNER JOIN
--                                                         TransferProceso AS TP ON T.IdTransferProceso = TP.IdTransferProceso AND RT.IdDrogueria = TP.IdDrogueria
--                               WHERE        (T.IdReporte = RT.IdReporte)))
--GROUP BY RT.IdReporte, PDV.IdPuntoDeVenta, PDV.Nombre, RTC.FechaCreacion, U.Nombre,VentaTelefonica,RTN.Numero


	SELECT   X.IdReporte
			,PDV.IdPuntoDeVenta 
			,PDV.Nombre AS NombrePDV
			,X.FechaCreacion
			,U.Nombre AS NombreUsuario
			,X.NumeroTransfer 
			,X.VentaTelefonica
	FROM 	
	(SELECT      RT.IdReporte 
				,RTC.IdPuntoDeVenta 
				,RTC.FechaCreacion				
				,RTN.Numero AS NumeroTransfer
				,RTC.IdUsuario
				,CASE RTN.VentaTelefonica
				  WHEN 1 THEN 'Telefónica'
				  ELSE 'Presencial'
				END VentaTelefonica				
	FROM        ReporteTransfer AS RT
                INNER JOIN ReporteTransferCabecera AS RTC ON (RTC.IdReporteTransferCabecera = RT.IdReporte AND RTC.IdEmpresa = @IdEmpresa)	
                INNER JOIN ReporteTransferNumero AS RTN ON (RTN.IdReporte = RT.IdReporte AND RTN.IdDrogueria = @IdDrogueria)                
WHERE        (RT.IdDrogueria = @IdDrogueria) AND
                             (NOT EXISTS
                              (SELECT        T.IdTransfer, T.IdTransferProceso, T.IdReporte
                               FROM            Transfer AS T INNER JOIN
                                                         TransferProceso AS TP ON T.IdTransferProceso = TP.IdTransferProceso AND RT.IdDrogueria = TP.IdDrogueria
                               WHERE        (T.IdReporte = RT.IdReporte)))
GROUP BY RT.IdReporte, RTC.IdPuntoDeVenta, RTC.IdPuntoDeVenta, RTC.FechaCreacion, RTN.Numero, RTC.IdUsuario,RTN.VentaTelefonica) X
INNER JOIN PuntoDeVenta AS PDV ON (PDV.IdPuntoDeVenta = X.IdPuntoDeVenta)
INNER JOIN Usuario AS U ON U.IdUsuario = X.IdUsuario


	END
GO
