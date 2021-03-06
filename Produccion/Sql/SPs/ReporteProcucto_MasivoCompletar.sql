SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteProcucto_MasivoCompletar]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteProcucto_MasivoCompletar] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteProcucto_MasivoCompletar]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @IdReporte int
	DECLARE	@return_value int


    -- Insert statements for procedure here
	DECLARE reporteProducto_cursor CURSOR FOR 
	Select IdReporte from ReporteKCC 
	OPEN reporteProducto_cursor

FETCH NEXT FROM reporteProducto_cursor 
INTO @IdReporte

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT @IdReporte
    INSERT INTO [ReporteProducto]
           ([IdReporte]
           ,[IdProducto]
           ,[Cantidad]
           ,[Precio]
           ,[Stock]
           ,[NoTrabaja]
           ,[IdExhibidor]
           ,[Cantidad2]
           ,[IdExhibidor2])
	(SELECT @IdReporte,RP.IdProducto,0,0,1,0,NULL,0,NULL 
	 FROM [ReporteProducto] RP
	 LEFT JOIN [ReporteProducto] RP1 ON (RP1.IdReporte = @IdReporte AND RP.IdProducto = RP1.IdProducto)
	 WHERE RP.IdReporte=250109  AND  RP1.IdProducto IS NULL)    
	
FETCH NEXT FROM reporteProducto_cursor 
INTO @IdReporte
END 

CLOSE reporteProducto_cursor;
DEALLOCATE reporteProducto_cursor;

END
GO
