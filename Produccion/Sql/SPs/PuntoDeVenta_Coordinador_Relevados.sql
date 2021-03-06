SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Coordinador_Relevados]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Coordinador_Relevados] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Coordinador_Relevados] 
	-- Add the parameters for the stored procedure here
	 @IdUsuario int 
	,@IdEmpresa int
	,@Mes int
	,@Ano int
	
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @IdUsuarioACargo int
   DECLARE @IdRTM int
   DECLARE @ApellidoNombre varchar(250)	

	CREATE TABLE #TableSalida1 (ApellidoNombre varchar(255)
		                 ,CantidadTotal int
		                 ,CantidadRelevados int
		                 ,CantidadPendientes int
		                 ,CantidadIngresos int
		                 ,FechaUltima nvarchar(30)
		                 ,HoraUltima nvarchar(30))

	CREATE TABLE #TableSalida2 (CantidadTotal int
		                 ,CantidadRelevados int
		                 ,CantidadPendientes int)
    
	CREATE TABLE #Table1 (FechaCarga DateTime
							 ,Activo bit)

    
DECLARE reporte_cursor CURSOR FOR 
SELECT UUA.[IdUsuarioACargo]
      ,ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'')  COLLATE DATABASE_DEFAULT  As ApellidoNombre
FROM [dbo].[Usuario_UsuarioACargo] UUA
INNER JOIN [Usuario] U ON (U.IdUsuario = UUA.IdUsuarioACargo)
WHERE UUA.[IdUsuario] = @IdUsuario AND UUA.[Activo]=1

OPEN reporte_cursor


FETCH NEXT FROM reporte_cursor 
INTO @IdUsuarioACargo,@ApellidoNombre

WHILE @@FETCH_STATUS = 0
BEGIN


DECLARE reporte2_cursor CURSOR FOR 
SELECT UUA.[IdUsuarioACargo] AS IdRTM      
FROM [dbo].[Usuario_UsuarioACargo] UUA
INNER JOIN [Usuario] U ON (U.IdUsuario = UUA.IdUsuarioACargo)
WHERE UUA.[IdUsuario] = @IdUsuarioACargo AND UUA.[Activo]=1

OPEN reporte2_cursor

FETCH NEXT FROM reporte2_cursor 
INTO @IdRTM

WHILE @@FETCH_STATUS = 0
BEGIN
	
	INSERT INTO #Table1     
	SELECT FechaCarga, Activo 
	FROM [dbo].[PuntoDeVenta_RTM_Table_Relevados] (@IdRTM,@IdEmpresa,@Mes,@Ano)
	
   

	INSERT INTO #TableSalida2
     VALUES
           ((SELECT count(1) FROM #Table1  WHERE  Activo = 1) 
           ,(SELECT count(1) FROM #Table1 WHERE NOT FechaCarga  IS NULL AND Activo = 1)
           ,(SELECT count(1) FROM #Table1 WHERE FechaCarga IS NULL AND Activo = 1))

	DELETE FROM #Table1

FETCH NEXT FROM reporte2_cursor 
INTO @IdRTM
END 

CLOSE reporte2_cursor;
DEALLOCATE reporte2_cursor;
	

	INSERT INTO #TableSalida1
	 VALUES
		   (@ApellidoNombre
		   ,(SELECT SUM(CantidadTotal) FROM #TableSalida2) 
		   ,(SELECT SUM(CantidadRelevados) FROM #TableSalida2) 
		   ,(SELECT SUM(CantidadPendientes) FROM #TableSalida2)
		   ,(SELECT COUNT(1) FROM [dbo].[Usuario_InicioSession] (@IdUsuarioACargo))
		   ,ISNULL(CONVERT(nvarchar(30),(SELECT MAX(Fecha) FROM [dbo].[Usuario_InicioSession] (@IdUsuarioACargo)),103),'')
		   ,ISNULL(CONVERT(nvarchar(30),(SELECT MAX(Fecha) FROM [dbo].[Usuario_InicioSession] (@IdUsuarioACargo)),108),''))
     
	DELETE FROM #TableSalida2
        
FETCH NEXT FROM reporte_cursor 
INTO @IdUsuarioACargo, @ApellidoNombre
END 

CLOSE reporte_cursor;
DEALLOCATE reporte_cursor;

SELECT   ApellidoNombre
	    ,ISNULL(CantidadTotal,0) AS  CantidadTotal
		,ISNULL(CantidadRelevados,0) AS CantidadRelevados  
		,ISNULL(CantidadPendientes,0) AS CantidadPendientes
		,ISNULL(CantidadIngresos,0) AS  CantidadIngresos
	    ,FechaUltima + '  '  +  HoraUltima COLLATE DATABASE_DEFAULT  As  FechaUltima
	
FROM #TableSalida1
ORDER BY  ApellidoNombre
  
END
GO
