SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetRTM_Correcion_Abbot]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetRTM_Correcion_Abbot] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetRTM_Correcion_Abbot] 
	
	 @IdUsuario int 
	,@IdUsuarioDestino int 
	,@IdEmpresa int
	,@IdEmpresaDestino int
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	CREATE TABLE #Table1 (IdPuntoDeVenta int
						  ,IdCliente int
						 ,Activo bit)
	INSERT INTO #Table1     
	SELECT UPDV.[IdPuntoDeVenta]           
		,C.IdCliente
	  ,dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(C.IdCliente,UPDV.[IdPuntoDeVenta],@IdUsuario) AS Activo
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario AND IdGrupo = 2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
  INNER JOIN Cliente  C ON (UC.IdCliente = C.IdCliente AND C.IdEmpresa = @IdEmpresa)
  INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = C.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  WHERE UPDV.IdUsuario = @IdUsuario 
  ORDER BY PDV.Nombre
  
  CREATE TABLE #Table2 (IdPuntoDeVenta int
                        ,IdCliente int
						 ,Activo bit)
	INSERT INTO #Table2     
	SELECT UPDV.[IdPuntoDeVenta]            
	  ,C.IdCliente
	  ,dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(C.IdCliente,UPDV.[IdPuntoDeVenta],@IdUsuarioDestino) AS Activo
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario AND IdGrupo = 2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
  INNER JOIN Cliente  C ON (UC.IdCliente = C.IdCliente AND C.IdEmpresa = @IdEmpresaDestino)
  INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = C.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  WHERE UPDV.IdUsuario = @IdUsuarioDestino 
  ORDER BY PDV.Nombre
  

  SELECT   PCU.*      
  FROM [dbo].[PuntoDeVenta_Cliente_Usuario] PCU
  INNER JOIN  #Table1 T1 ON (PCU.[IdPuntoDeVenta] = T1.[IdPuntoDeVenta] AND PCU.IdCliente = T1.IdCliente)
  LEFT JOIN #Table2 T2 ON(T2.IdPuntoDeVenta = T1.IdPuntoDeVenta AND T2.Activo = 1)      
  WHERE T2.IdPuntoDeVenta IS NULL AND
        PCU.IdUsuario = @IdUsuarioDestino
       
           
  --SELECT T2.IdPuntoDeVenta
  --      ,T1.IdPuntoDeVenta
  --FROM #Table2 T2
  --LEFT JOIN #Table1 T1 ON(T1.IdPuntoDeVenta = T2.IdPuntoDeVenta AND T1.Activo = 1)      
  --WHERE T1.IdPuntoDeVenta IS NULL
  --ORDER BY T2.IdPuntoDeVenta
  
  
END
GO
