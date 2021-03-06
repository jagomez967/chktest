SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_CopiarMasivoENERO_FEBRERO_AB_AD_NY]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_CopiarMasivoENERO_FEBRERO_AB_AD_NY] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_CopiarMasivoENERO_FEBRERO_AB_AD_NY]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

--- Maximo 253051 12/03 se agregan 718

	SET NOCOUNT ON;

-- Mosificar los parametros antes de usar. 
	DECLARE @IdReporte int
DECLARE	@return_value int

DECLARE reporte_cursor CURSOR FOR 
SELECT R.IdReporte
FROM [Reporte_Duplicar_EneroFebreo$] R1
INNER JOIN Reporte R ON (R.IdPuntoDeVenta = R1.[IdPuntoDeVenta] AND
                         R.IdUsuario = R1.[IdUsuario] AND
                         R.IdEmpresa = R1.IdEmpresa AND
                         R.FechaCreacion BETWEEN '2013-01-01 00:0:0.000' AND '2013-01-02 00:0:0.000')
                         
  
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
