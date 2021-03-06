SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reportes_ConsultaRepetidos]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reportes_ConsultaRepetidos] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reportes_ConsultaRepetidos]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT R.IdReporte, R.IdPuntoDeVenta, R.IdEmpresa, R.IdUsuario, R.FechaCreacion, R2.Cantidad AS CantidadRepetido
	FROM [dbo].[Reporte] R
	INNER JOIN  (
	SELECT  [IdPuntoDeVenta]
		   ,[IdUsuario]   
		   ,[IdEmpresa]
		   ,DAY(R1.[FechaCreacion]) DIA
		   ,MONTH(R1.[FechaCreacion]) MES
		   ,COUNT(1) AS Cantidad
	FROM [dbo].[Reporte] R1
	GROUP BY [IdPuntoDeVenta],[IdUsuario], [IdEmpresa],DAY(R1.[FechaCreacion]),MONTH(R1.[FechaCreacion])
	HAVING COUNT(1) > 1) R2 ON (R.IdEmpresa = R2.IdEmpresa AND R.IdPuntoDeVenta=R2.IdPuntoDeVenta AND R.IdUsuario=R2.IdUsuario
								 AND DAY(R.[FechaCreacion])=DIA AND MONTH(R.[FechaCreacion])=MES)
	ORDER BY R.IdPuntoDeVenta, R.IdEmpresa, R.IdUsuario, R.FechaCreacion

END
GO
