SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_RTM_NO_Relevados]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_RTM_NO_Relevados] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_RTM_NO_Relevados] 	
	 @IdUsuario int 
	,@IdEmpresa int
	,@Mes int
	,@Ano int 
	
AS
BEGIN
	
  SET NOCOUNT ON;

  SELECT X.[IdPuntoDeVenta]            	
  FROM
  (SELECT UPDV.[IdPuntoDeVenta]  
          ,dbo.PDVRelevado(@IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS FechaCarga          	
		  ,dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(@IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS Activo
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario AND IdGrupo = 2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario)
  INNER JOIN Cliente  C ON (UC.IdCliente = C.IdCliente AND C.IdEmpresa = @IdEmpresa)
  WHERE UPDV.IdUsuario = @IdUsuario and UPDV.activo=1) AS X
  WHERE X.FechaCarga  IS NULL AND X.Activo = 1
  ORDER BY X.[IdPuntoDeVenta]
		    
END



GO
