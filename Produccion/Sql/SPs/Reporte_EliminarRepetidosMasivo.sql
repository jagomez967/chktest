SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_EliminarRepetidosMasivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_EliminarRepetidosMasivo] AS' 
END
GO
ALTER PROCEDURE [dbo].[Reporte_EliminarRepetidosMasivo]
	-- Add the parameters for the stored procedure here
	 @IdUsuario int
    ,@Dia int
    ,@Mes int

AS
BEGIN
	SET NOCOUNT ON;

DECLARE @IdReporte int
DECLARE @Cantidad int
DECLARE	@return_value int

SET @Cantidad= 0

DECLARE reporte_cursor CURSOR FOR 
SELECT R1.IdReporte AS IdReporte
FROM Reporte R1
  INNER JOIN 	 (SELECT [IdPuntoDeVenta]
				 ,[IdUsuario]   
				 ,[IdEmpresa]
		  FROM [Reporte]
		  WHERE [IdReporte] IN (SELECT MAX([IdReporte])
		  FROM [Reporte]
		  WHERE [IdUsuario]=@IdUsuario AND  DAY([FechaCreacion]) = @Dia AND MONTH([FechaCreacion])=@Mes
		  GROUP BY [IdPuntoDeVenta],[IdUsuario], [IdEmpresa]
		  HAVING COUNT(1) > 1)) R2 ON (R1.IdEmpresa = R2.IdEmpresa AND R1.IdUsuario = R2.IdUsuario AND R1.IdPuntoDeVenta=R2.IdPuntoDeVenta)
 WHERE NOT [IdReporte] IN (SELECT MAX([IdReporte])
						   FROM [Reporte]
						   WHERE [IdUsuario]=@IdUsuario AND  DAY([FechaCreacion]) = @Dia AND MONTH([FechaCreacion])=@Mes
						   GROUP BY [IdPuntoDeVenta],[IdUsuario], [IdEmpresa]
							HAVING COUNT(1) > 1)
AND R1.[IdUsuario]=@IdUsuario AND DAY(R1.[FechaCreacion]) = @Dia AND MONTH(R1.[FechaCreacion])=@Mes
OPEN reporte_cursor

FETCH NEXT FROM reporte_cursor 
INTO @IdReporte

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Cantidad = @Cantidad + 1
    PRINT @IdReporte
    
EXEC	@return_value = [dbo].[Reporte_Eliminar]
		@IdReporte = @IdReporte
    
FETCH NEXT FROM reporte_cursor 
INTO @IdReporte
END 

CLOSE reporte_cursor;
DEALLOCATE reporte_cursor;

PRINT 'Cantidad: ' + CONVERT(varchar(20), @Cantidad)

END
GO
