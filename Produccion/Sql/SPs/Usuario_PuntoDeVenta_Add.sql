SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PuntoDeVenta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_PuntoDeVenta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_PuntoDeVenta_Add]
	-- Add the parameters for the stored procedure here
	 @IdPuntoDeVenta int
	,@IdUsuario int
	,@Activo bit = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Usuario_PuntoDeVenta]
           ([IdPuntoDeVenta]
           ,[IdUsuario]
           ,[Activo])
     VALUES
           (@IdPuntoDeVenta
           ,@IdUsuario
           ,@Activo)
	
	 --Agrego el Log 
	 --INSERT INTO [dbo].[Usuario_PuntoDeVenta]
  --         ([IdCliente]
  --         ,[IdPuntoDeVenta]
  --         ,[IdUsuario]
  --         ,[Fecha]
  --         ,[Activo])
  --   (SELECT PDV.[IdCliente]   
		--    ,UP.[IdPuntoDeVenta]
	 --       ,UP.[IdUsuario]   
		--    ,GETDATE()
		--    ,1
	 -- FROM [dbo].[Usuario_PuntoDeVenta] UP 
	 -- INNER JOIN PuntoDeVenta PDV  ON (PDV.[IdPuntoDeVenta] = UP.[IdPuntoDeVenta])
	 -- INNER JOIN Usuario_Cliente UC ON (UC.[IdUsuario] = UP.[IdUsuario] AND PDV.[IdCliente] = UC.[IdCliente])
	 -- WHERE UP.[IdPuntoDeVenta] = @IdPuntoDeVenta AND
		--	UP.[IdUsuario] = @IdUsuario)
      
END
GO
