SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_ProductoPedido_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_ProductoPedido_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_ProductoPedido_GetAll]
	-- Add the parameters for the stored procedure here
	@IdProductoPedido Int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    SELECT D.[IdDrogueria]
          ,D.[Nombre] AS NombreDrogueria
          ,DP.Codigo
	FROM [dbo].[Drogueria] D
    LEFT JOIN [Drogueria_ProductoPedido] DP ON ((DP.[IdDrogueria] = D.[IdDrogueria]) AND (@IdProductoPedido IS NULL OR (DP.[IdProductoPedido]= @IdProductoPedido)))

END
GO
