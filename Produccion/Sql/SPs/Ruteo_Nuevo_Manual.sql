SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ruteo_Nuevo_Manual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Ruteo_Nuevo_Manual] AS' 
END
GO
ALTER PROCEDURE [dbo].[Ruteo_Nuevo_Manual]
	
	 @IdPuntoDeventa int
	,@IdCliente int	
	,@IdUsuario int
	,@FechaRuteo datetime
	
AS
BEGIN
	SET NOCOUNT ON;
	



  --1 Asigno Primero los PDV al CLliente que no existen
  IF NOT EXISTS(SELECT 1 FROM [dbo].[Cliente_PuntoDeVenta] 
				 WHERE [IdCliente]=@IdCliente AND  [IdPuntoDeVenta] = @IdPuntoDeVenta)
  BEGIN
	  INSERT INTO [dbo].[Cliente_PuntoDeVenta]
			   ([IdCliente]
			   ,[IdPuntoDeVenta])
	  VALUES(@IdCliente, @IdPuntoDeventa)         
  END         
   
   -- 2 Asigno los PDV al Usuario
  IF NOT EXISTS(SELECT 1 FROM [dbo].[Usuario_PuntoDeVenta]
				 WHERE [IdPuntoDeVenta]=@IdPuntoDeVenta AND  [IdUsuario] = @IdUsuario)
  BEGIN

   INSERT INTO [dbo].[Usuario_PuntoDeVenta]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
		   ,[Activo])
	VALUES(@IdPuntoDeventa,@IdUsuario,1)
  END
  ELSE 
   BEGIN
    UPDATE [dbo].[Usuario_PuntoDeVenta]
			set [Activo] = 1 where [IdUsuario] = @IdUsuario and [idPuntoDeVenta] = @IdPuntoDeVenta
   END
  
  -- 3 Activo la relacion PDV Cliente Usuario
  INSERT INTO [PuntoDeVenta_Cliente_Usuario]
           ([IdCliente]
           ,[IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Fecha]
           ,[Activo])   
    VALUES
	   (@IdCliente
       ,@IdPuntoDeventa
       ,@IdUsuario       
       ,CONVERT(DATETIME,@FechaRuteo,120)
       ,1)
   
END


GO
