SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_PuntoDeVenta_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_PuntoDeVenta_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cliente_PuntoDeVenta_Delete]
	-- Add the parameters for the stored procedure here
    @IdCliente int
   ,@IdPuntoDeVenta int
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 --Agrego el Log para todos los usuario, Desactivo            
     INSERT INTO [dbo].[PuntoDeVenta_Cliente_Usuario]
           ([IdCliente]
           ,[IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Fecha]
           ,[Activo])
    (SELECT UC.[IdCliente]   
		   ,UP.[IdPuntoDeVenta]
	       ,UP.[IdUsuario]   
		   ,GETDATE()
		   ,0
	  FROM Cliente_PuntoDeVenta CP  
	  INNER JOIN [dbo].[Usuario_PuntoDeVenta] UP ON (CP.[IdPuntoDeVenta] = UP.[IdPuntoDeVenta])
	  INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UP.[IdUsuario] AND CP.[IdCliente] = UC.[IdCliente])
	  WHERE  CP.[IdPuntoDeVenta] = @IdPuntoDeVenta AND
			 CP.[IdCliente] = @IdCliente)

    -- Insert statements for procedure here
	DELETE FROM [dbo].[Cliente_PuntoDeVenta]
    WHERE @IdPuntoDeVenta = [IdPuntoDeVenta] AND @IdCliente = [IdCliente]

END
GO
