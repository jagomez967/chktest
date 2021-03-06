SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_CopiarMasivo_Abbott]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_CopiarMasivo_Abbott] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_CopiarMasivo_Abbott]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Mosificar los parametros antes de usar. 
	DECLARE @IdReporte int
DECLARE	@return_value int

DECLARE reporte_cursor CURSOR FOR 
SELECT RD.[IdReporte]
  FROM [Reportes_Duplicar_Abbot$] RD
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
