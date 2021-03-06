SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoReporteVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoReporteVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoReporteVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdDermoReporte int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DMV.[IdDermoReporteVenta]
      ,DMV.[IdDermoReporte]
      ,DMV.[IdProducto]
      ,DMV.[Cantidad]
      ,P.Nombre AS NombreProducto
      ,M.IdMarca 
      ,M.Nombre AS NombreMarca
  FROM [dbo].[DermoReporteVenta] DMV
  INNER JOIN Producto P ON (P.[IdProducto] = DMV.[IdProducto])
  INNER JOIN Marca M ON (M.IdMarca = P.IdMarca)
  WHERE @IdDermoReporte = DMV.[IdDermoReporte]
  ORDER BY DMV.[IdDermoReporteVenta]
  
END
GO
