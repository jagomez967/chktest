SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ruteo_Copiar2_Kassel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Ruteo_Copiar2_Kassel] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Ruteo_Copiar2_Kassel]
	-- Add the parameters for the stored procedure here
	 @IdClienteOriginal int
	,@IdClienteCopia int
	--,@IdUsuarioOriginal int
	,@IdUsuarioCopiar int
	,@Mes int 
	,@Ano int 
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IdEmpresaOriginal int 
	DECLARE @IdEmpresaCopia int 
	
	SELECT @IdEmpresaOriginal = IdEmpresa FROM Cliente WHERE IdCliente=@IdClienteOriginal
	SELECT @IdEmpresaCopia = IdEmpresa FROM Cliente WHERE IdCliente=@IdClienteCopia

--1 C.A.B.A
--7	 GBA NORTE
--8	 GBA OESTE
--11 GBA SUR

	CREATE TABLE  #PDVACTIVOS (IdPuntoDeventa int)
	
	INSERT #PDVACTIVOS 
	(IdPuntoDeventa)
	(SELECT X.IdPuntoDeVenta
	 FROM
	  (SELECT  UPDV.[IdPuntoDeVenta]    
			  ,dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(UC.[IdUsuario],@IdEmpresaOriginal,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS Activo        
  			  ,dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo_Copia(@IdUsuarioCopiar,@IdEmpresaCopia,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS ActivoCopia        
	   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
	   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
	   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
	   INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.[IdPuntoDeVenta] AND PDV.IdZona IN (1,7,8,11))) X
	   WHERE X.Activo=1 AND X.ActivoCopia=0
	   GROUP BY X.IdPuntoDeVenta)



  --1 Asigno Primero los PDV al CLliente que no existen
  INSERT INTO [dbo].[Cliente_PuntoDeVenta]
           ([IdCliente]
           ,[IdPuntoDeVenta])
  (SELECT   @IdClienteCopia
          ,UPDV.[IdPuntoDeVenta]            
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   LEFT JOIN Cliente_PuntoDeVenta CPDV1 ON (CPDV1.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV1.IdCliente = @IdClienteCopia)
   INNER JOIN #PDVACTIVOS PDVA ON (UPDV.[IdPuntoDeVenta]= PDVA.IdPuntoDeventa)
   WHERE  CPDV1.[IdPuntoDeVenta] IS NULL
   GROUP BY UPDV.[IdPuntoDeVenta])
           
           
   
  -- -- 2 Asigno los PDV al Usuario
   INSERT INTO [dbo].[Usuario_PuntoDeVenta]
           ([IdPuntoDeVenta]
           ,[IdUsuario])
  (SELECT  UPDV.[IdPuntoDeVenta]            
          ,@IdUsuarioCopiar
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   LEFT JOIN Usuario_PuntoDeVenta UPDV1 ON (UPDV1.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND UPDV1.[IdUsuario] = @IdUsuarioCopiar)
   INNER JOIN #PDVACTIVOS PDVA ON (UPDV.[IdPuntoDeVenta]= PDVA.IdPuntoDeventa)
   WHERE UPDV1.[IdPuntoDeVenta] IS NULL
   GROUP BY UPDV.[IdPuntoDeVenta])
  
  ---- 3 Activo la relacion PDV Cliente Usuario
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
           ,CONVERT(DATETIME,'2013-05-01',120)
           ,1
   FROM [dbo].[Usuario_PuntoDeVenta] UPDV
   INNER JOIN Cliente_PuntoDeVenta CPDV ON (CPDV.[IdPuntoDeVenta] = UPDV.[IdPuntoDeVenta] AND CPDV.IdCliente = @IdClienteOriginal)
   INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UPDV.[IdUsuario] AND CPDV.IdCLiente = UC.IdCLiente)
   INNER JOIN #PDVACTIVOS PDVA ON (UPDV.[IdPuntoDeVenta]= PDVA.IdPuntoDeventa)
   GROUP BY UPDV.[IdPuntoDeVenta])
   
END
GO
