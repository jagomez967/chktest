SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_GetAllCliente] 
	 
	@IdCliente int
	
AS
BEGIN
	
  SET NOCOUNT ON;

  SELECT UPDV.[IdPuntoDeVenta]                    
        ,CAST(PDV.[IdPuntoDeVenta] AS nvarchar(10)) + ' - ' + ISNULL(PDV.[Nombre],'') + ' - ' + ISNULL(PDV.[Direccion],'') COLLATE DATABASE_DEFAULT  As CodigoNombreDireccion
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario)
  INNER JOIN UsuarioGrupo UG ON (U.IdUsuario = UG.IdUsuario AND UG.IdGrupo=2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  INNER JOIN Usuario_Cliente UC ON (U.IdUsuario = UC.IdUsuario AND UC.IdCliente=@IdCliente)  
  INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = UC.IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  WHERE  dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(UC.IdCliente,UPDV.[IdPuntoDeVenta],U.IdUsuario)=1
  GROUP BY UPDV.[IdPuntoDeVenta],PDV.[IdPuntoDeVenta],PDV.Nombre,PDV.[Direccion]
  ORDER BY UPDV.[IdPuntoDeVenta]
  
END
GO
