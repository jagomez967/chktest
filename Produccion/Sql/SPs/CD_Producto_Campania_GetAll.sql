SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Producto_Campania_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Producto_Campania_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Producto_Campania_GetAll]
	-- Add the parameters for the stored procedure here
	@IdCampania int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PC.[IdProducto]
      ,PC.[IdCampania]
      ,PC.[Orden] AS OrdenProductoCampania
      ,PC.[Activo]AS ActivoProductoCampania
      ,P.[Codigo]
      ,P.[CodigoEAN]
      ,P.[CodigoSAP]
      ,P.[Nombre]
      ,P.[IdMarca]
      ,P.[Orden]
      ,P.[Activo]  
  FROM CD_Producto_Campania PC
  INNER JOIN CD_Producto P ON P.[IdProducto] = PC.[IdProducto]
  WHERE PC.[IdCampania] = @IdCampania
  
  
END
GO
