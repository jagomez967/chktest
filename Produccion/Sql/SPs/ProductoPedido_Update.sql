SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoPedido_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoPedido_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProductoPedido_Update]
	-- Add the parameters for the stored procedure here
    @IdProductoPedido int
   ,@CodigoEAN varchar(50) = NULL
   ,@CodigoSAP varchar(50) = NULL
   ,@Nombre varchar(100)
   ,@IdMarcaPedido int   
   ,@Orden int = NULL
   ,@Activo bit 
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[ProductoPedido]
	   SET [CodigoEAN] = @CodigoEAN
		  ,[CodigoSAP] = @CodigoSAP
		  ,[Nombre] = @Nombre
		  ,[IdMarcaPedido] = @IdMarcaPedido
		  ,[Orden] = @Orden
		  ,[Activo] = @Activo
	 WHERE [IdProductoPedido] = @IdProductoPedido

END
GO
