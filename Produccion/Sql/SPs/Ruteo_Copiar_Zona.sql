SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ruteo_Copiar_Zona]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Ruteo_Copiar_Zona] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Ruteo_Copiar_Zona]
	-- Add the parameters for the stored procedure here
	 @IdClienteOriginal int
	,@IdClienteCopia int
	,@IdUsuarioOriginal int
	,@IdUsuarioCopiar int
	,@IdZona int
	
AS
BEGIN
	SET NOCOUNT ON;

  --1 Asigno Primero los PDV al CLliente que no existen
  INSERT INTO [dbo].[Cliente_PuntoDeVenta]
           ([IdCliente]
           ,[IdPuntoDeVenta])
  (SELECT   @IdClienteCopia
          ,UPDV.[IdPuntoDeVenta]            
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)   
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.[IdPuntoDeVenta] AND PDV.IdZona=@IdZona)
   LEFT JOIN Cliente_PuntoDeVenta CPDV1 ON (CPDV1.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV1.IdCliente = @IdClienteCopia)
   WHERE UPDV.[IdUsuario]=@IdUsuarioOriginal AND CPDV1.[IdPuntoDeVenta] IS NULL)
   
   -- 2 Asigno los PDV al Usuario
   INSERT INTO [dbo].[Usuario_PuntoDeVenta]
           ([IdPuntoDeVenta]
           ,[IdUsuario])
  (SELECT  UPDV.[IdPuntoDeVenta]            
          ,@IdUsuarioCopiar
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.[IdPuntoDeVenta] AND PDV.IdZona=@IdZona)
   LEFT JOIN Usuario_PuntoDeVenta UPDV1 ON (UPDV1.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND UPDV1.[IdUsuario] = @IdUsuarioCopiar)
   WHERE UPDV.[IdUsuario]=@IdUsuarioOriginal AND UPDV1.[IdPuntoDeVenta] IS NULL)
  
  -- 3 Activo la relacion PDV Cliente Usuario
  INSERT INTO [PuntoDeVenta_Cliente_Usuario]
           ([IdCliente]
           ,[IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Fecha]
           ,[Activo])   
   (SELECT  @IdClienteCopia
           ,UPDV.[IdPuntoDeVenta]            
           ,@IdUsuarioCopiar
           --,GETDATE()
           ,'2013-01-01 00:00:00.000'
           ,1
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.[IdPuntoDeVenta] AND PDV.IdZona=@IdZona)
   WHERE UPDV.[IdUsuario]=@IdUsuarioOriginal)

   
END
GO
