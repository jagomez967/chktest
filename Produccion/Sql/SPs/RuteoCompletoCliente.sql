SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RuteoCompletoCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RuteoCompletoCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[RuteoCompletoCliente]
	
	 @IdCliente int	
	,@IdUsuario int
	,@FechaRuteo datetime
	
AS
BEGIN
	SET NOCOUNT ON;
	         
   
   -- 1 Asigno los PDV al Usuario
  IF NOT EXISTS(SELECT 1 FROM [dbo].[Usuario_PuntoDeVenta]
				 WHERE [IdUsuario] = @IdUsuario AND [IdPuntoDeVenta] IN (SELECT [IdPuntoDeVenta] FROM PuntoDeVenta WHERE [IdCliente] = @IdCliente))
  BEGIN

   INSERT INTO [dbo].[Usuario_PuntoDeVenta]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
		   ,[Activo])
	SELECT IdPuntoDeVenta, @IdUsuario, 1 FROM PuntoDeVenta WHERE IdCliente = @IdCliente
  END

  
  -- 2 Activo la relacion PDV Cliente Usuario
  INSERT INTO [PuntoDeVenta_Cliente_Usuario]
           ([IdCliente]
           ,[IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Fecha]
           ,[Activo])   
	SELECT	@IdCliente,
			IdPuntoDeVenta,
			@IdUsuario,
			@FechaRuteo,
			1
	FROM PuntoDeVenta WHERE IdCliente = @IdCliente
   
END



GO
