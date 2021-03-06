SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoCompetencia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProductoCompetencia_GetAll]
	-- Add the parameters for the stored procedure here
	@IdProducto int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT distinct PC.[IdProducto]
		  ,PC.[IdProductoCompetencia]
		  ,PC.[Id]
		  ,P.Nombre
		  ,PC.Reporte
		  ,M.[IdEmpresa]
          ,E.Nombre AS Empresa
          ,P.[IdMarca]
          ,M.Nombre AS Marca
		  ,p.orden		  
   FROM [dbo].[ProductoCompetencia] PC
   INNER JOIN Producto P ON (P.[IdProducto] = PC.[IdProductoCompetencia])
   LEFT JOIN Marca M ON (M.[IdMarca] = P.[IdMarca])
   LEFT JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
   WHERE PC.[IdProducto] = @IdProducto
   Order By P.Orden,p.nombre asc

END
GO
