SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PuntoDeVenta_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_PuntoDeVenta_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_PuntoDeVenta_Delete]
	-- Add the parameters for the stored procedure here
	  @IdPuntoDeVenta int
	 ,@IdUsuario int
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Agrego el Log
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
	  FROM [dbo].[Usuario_PuntoDeVenta] UP 
	  INNER JOIN Cliente_PuntoDeVenta CP  ON (CP.[IdPuntoDeVenta] = UP.[IdPuntoDeVenta])
	  INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UP.[IdUsuario] AND CP.[IdCliente] = UC.[IdCliente])
	  WHERE UP.[IdPuntoDeVenta] = @IdPuntoDeVenta AND
			UP.[IdUsuario] = @IdUsuario)



    -- Insert statements for procedure here
	DELETE FROM [dbo].[Usuario_PuntoDeVenta]
    WHERE @IdPuntoDeVenta = [IdPuntoDeVenta] AND 
          @IdUsuario = [IdUsuario]
	
END
GO
