SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_CopiarMasivoSanofiFebrero]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_CopiarMasivoSanofiFebrero] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_CopiarMasivoSanofiFebrero]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
--Comienza con 251255


	SET NOCOUNT ON;

-- Mosificar los parametros antes de usar. 
	DECLARE @IdReporte int
DECLARE	@return_value int

DECLARE reporte_cursor CURSOR FOR 
Select R.IdReporte
from Reporte  R
INNER JOIN [Reportes_Sanofi_Copiar_Febrero$] R2 ON (R.IdPuntoDeVenta = R2.IdPuntoDeVenta) 
Where IdEmpresa=212  	  
	  AND FechaCreacion between '2013-01-01 00:00:00.000' and '2013-31-01 23:59:00.000'	  
GROUP BY R.IdReporte
OPEN reporte_cursor

FETCH NEXT FROM reporte_cursor 
INTO @IdReporte

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT @IdReporte
    
EXEC	@return_value = [dbo].[Reporte_Copiar]
		@IdReporte = @IdReporte
    
FETCH NEXT FROM reporte_cursor 
INTO @IdReporte
END 

CLOSE reporte_cursor;
DEALLOCATE reporte_cursor;


END
GO
