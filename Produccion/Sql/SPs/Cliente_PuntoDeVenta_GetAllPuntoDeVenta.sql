SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_PuntoDeVenta_GetAllPuntoDeVenta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_PuntoDeVenta_GetAllPuntoDeVenta] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cliente_PuntoDeVenta_GetAllPuntoDeVenta]
	@IdEmpresa int
   ,@IdUsuario int = NULL
   
AS
BEGIN
	SET NOCOUNT ON;
-- Viejo
	--SELECT PDV.IdPuntoDeVenta
	--	  ,PDV.Codigo
 --         ,PDV.Nombre
 --         ,PDV.TieneVidriera 
 --         ,PDV.Direccion
	--FROM Cliente_PuntoDeVenta CPDV	
	--INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = CPDV.IdPuntoDeVenta)
	--INNER JOIN Cliente C ON (CPDV.IdCliente = C.IdCliente and C.IdEmpresa = @IdEmpresa)
	--INNER JOIN Usuario_PuntoDeVenta UPDV ON (PDV.IdPuntoDeVenta=UPDV.IdPuntoDeVenta and (@IdUsuario IS NULL OR UPDV.IdUsuario=@IdUsuario))
	----WHERE ([dbo].PuntoDeVenta_Cliente_Usuario_GetActivo(C.IdCliente,PDV.IdPuntoDeVenta, UPDV.IdUsuario) = 1)
	--GROUP BY PDV.IdPuntoDeVenta, PDV.Codigo, PDV.Nombre ,PDV.TieneVidriera,PDV.Direccion
	--ORDER BY PDV.Nombre

--Nuevo 09/11/2012
DECLARE @IdCliente int

SELECT @IdCliente =  IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa 

CREATE TABLE #PCU (IdCliente int, IdPuntoDeVenta int, IdUsuario int)

INSERT INTO #PCU (IdCliente, IdPuntoDeVenta, IdUsuario)
(SELECT  Y.[IdCliente]
       ,Y.[IdPuntoDeVenta]
       ,Y.[IdUsuario]
FROM    
 (SELECT [IdCliente]
       ,[IdPuntoDeVenta]
       ,[IdUsuario]
  FROM [dbo].[PuntoDeVenta_Cliente_Usuario] PCU
  WHERE [IdCliente]=@IdCliente AND
        [IdPuntoDeVenta_Cliente_Usuario] IN  
	   (SELECT MAX([IdPuntoDeVenta_Cliente_Usuario])
		FROM [dbo].[PuntoDeVenta_Cliente_Usuario]
		WHERE [IdCliente] = PCU.IdCliente AND
			  [IdPuntoDeVenta] = PCU.IdPuntoDeVenta AND
			  [IdUsuario] = PCU.IdUsuario) /*AND [Activo]=1*/) Y)

SELECT 	   X.IdPuntoDeVenta
		  ,X.Codigo
          ,X.Nombre
          ,X.TieneVidriera 
          ,X.Direccion 
          ,X.Latitud
          ,X.Longitud         
FROM 
(SELECT PDV.IdPuntoDeVenta
		  ,PDV.Codigo
          ,PDV.Nombre
          ,PDV.TieneVidriera 
          ,PDV.Direccion
          ,PDV.Latitud
          ,PDV.Longitud          
	FROM Cliente_PuntoDeVenta CPDV	
	INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = CPDV.IdPuntoDeVenta)	
	INNER JOIN Usuario_PuntoDeVenta UPDV ON (PDV.IdPuntoDeVenta=UPDV.IdPuntoDeVenta and (@IdUsuario IS NULL OR UPDV.IdUsuario=@IdUsuario))
	INNER JOIN #PCU PCU ON (PCU.IdPuntoDeVenta = PDV.IdPuntoDeVenta AND PCU.IdUsuario = UPDV.IdUsuario)
	WHERE @IdCliente = CPDV.IdCliente)
	X
		
	GROUP BY X.IdPuntoDeVenta, X.Codigo, X.Nombre ,X.TieneVidriera,X.Direccion ,X.Latitud,X.Longitud   
	ORDER BY X.Nombre
		
	DROP TABLE #PCU	
--FIN NUEVO	
	
END
GO
