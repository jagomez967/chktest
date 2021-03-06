SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_ProductoPedido_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_ProductoPedido_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_ProductoPedido_Add]
	-- Add the parameters for the stored procedure here
	 @IdDrogueria int
	,@IdProductoPedido Int
	,@Codigo varchar(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Drogueria_ProductoPedido]
           ([IdDrogueria]
           ,[IdProductoPedido]
           ,[Codigo])
     VALUES
           (@IdDrogueria
           ,@IdProductoPedido
           ,@Codigo)



END
GO
