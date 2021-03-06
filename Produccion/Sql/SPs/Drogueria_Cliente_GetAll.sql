SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_Cliente_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_Cliente_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_Cliente_GetAll]
	-- Add the parameters for the stored procedure here
	@IdDrogueria int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
     SELECT C.[IdCliente]
		  ,C.[Nombre] AS NombreCliente
		  ,DC.[IdDrogueria] AS Activo
    FROM [dbo].[Cliente] C    
    LEFT JOIN [Drogueria_Cliente] DC ON (DC.[IdCliente] = C.[IdCliente] AND DC.[IdDrogueria] = @IdDrogueria)
    WHERE [Transfer]=1
    
END
GO
