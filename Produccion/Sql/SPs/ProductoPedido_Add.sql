SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoPedido_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoPedido_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProductoPedido_Add]
	-- Add the parameters for the stored procedure here
    @CodigoEAN varchar(50) = NULL
   ,@CodigoSAP varchar(50) = NULL
   ,@Nombre varchar(100)
   ,@IdMarcaPedido int
   ,@Orden int = NULL
   ,@Activo bit 
   ,@IdProductoPedido int output
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ProductoPedido]
           ([CodigoEAN]
           ,[CodigoSAP]
           ,[Nombre]
           ,[IdMarcaPedido]
           ,[Orden]
           ,[Activo])
     VALUES
           (@CodigoEAN
           ,@CodigoSAP
           ,@Nombre
           ,@IdMarcaPedido
           ,@Orden
           ,@Activo)

	SET @IdProductoPedido = @@Identity

END
GO
