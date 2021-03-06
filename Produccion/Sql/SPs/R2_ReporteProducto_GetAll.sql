SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteProducto_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteProducto_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteProducto_GetAll] 
	-- Add the parameters for the stored procedure here
     @IdReporte2 int = NULL
	,@IdMarca int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.IdProducto
		  ,P.Nombre
		  ,RP.IdExhibidor
		  ,(case when RP.IdProducto IS NULL then 'false' else 'true' end) as Estado
		  ,(case when RP.Stock IS NULL then '0' else RP.Stock end) as Stock
		  ,(case when RP.SellOut IS NULL then '0' else RP.SellOut end) as SellOut
		  ,RP.Comentarios			      
	FROM Producto P 	
	LEFT JOIN R2_ReporteProducto RP ON (RP.[IdReporte2] = @IdReporte2 and P.IdProducto = RP.IdProducto)
	WHERE P.IdMarca=@IdMarca  and P.Reporte=1
	Order BY Nombre
	
END
GO
