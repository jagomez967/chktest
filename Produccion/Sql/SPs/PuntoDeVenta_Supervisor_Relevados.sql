SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Supervisor_Relevados]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Supervisor_Relevados] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Supervisor_Relevados] 
	-- Add the parameters for the stored procedure here
	 @IdUsuario int 
	,@IdEmpresa int
	,@Mes int
	,@Ano int
	
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @IdUsuarioACargo int
   DECLARE @ApellidoNombre varchar(250)	

	CREATE TABLE #TableSalida (ApellidoNombre varchar(255)
		                 ,CantidadTotal int
		                 ,CantidadRelevados int
		                 ,CantidadPendientes int)


	--SELECT UUA.[IdUsuarioACargo]
	--      ,ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'')  COLLATE DATABASE_DEFAULT  As ApellidoNombre
 --   FROM [dbo].[Usuario_UsuarioACargo] UUA
 --   INNER JOIN [Usuario] U ON (U.IdUsuario = UUA.IdUsuarioACargo)
 --   WHERE UUA.[IdUsuario] = @IdUsuario AND UUA.[Activo]=1
    
    
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

	CREATE TABLE #Table1 (FechaCarga DateTime
		                 ,Activo bit)
	INSERT INTO #Table1     
	SELECT FechaCarga, Activo 
	FROM [dbo].[PuntoDeVenta_RTM_Table_Relevados] (@IdUsuarioACargo,@IdEmpresa,@Mes,@Ano)
	

    PRINT @IdUsuarioACargo
    PRINT @ApellidoNombre
    
    --SELECT * FROM #Table1

	INSERT INTO #TableSalida
     VALUES
           (@ApellidoNombre
           ,(SELECT count(1) FROM #Table1  WHERE  Activo = 1) 
           ,(SELECT count(1) FROM #Table1 WHERE NOT FechaCarga  IS NULL AND Activo = 1)
           ,(SELECT count(1) FROM #Table1 WHERE FechaCarga IS NULL AND Activo = 1))

    
	DROP TABLE #Table1
        
FETCH NEXT FROM reporte_cursor 
INTO @IdUsuarioACargo, @ApellidoNombre
END 

CLOSE reporte_cursor;
DEALLOCATE reporte_cursor;

SELECT ApellidoNombre
	  ,ISNULL(CantidadTotal,0) AS CantidadTotal
	  ,ISNULL(CantidadRelevados,0) AS CantidadRelevados
	  ,ISNULL(CantidadPendientes,0) AS CantidadPendientes
 FROM #TableSalida
ORDER BY  ApellidoNombre
  
END
GO
