SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteProductoCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteProductoCompetencia_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[R2_ReporteProductoCompetencia_GetAll]
	-- Add the parameters for the stored procedure here
     @IdReporte2 int = NULL
	,@IdMarca int	

AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.IdProducto 
		  ,P.Nombre + ' - ' + ISNULL(M.Nombre,'') AS Nombre
		  ,RPC.IdExhibidor
		  ,(case when RPC.IdProducto IS NULL then 'false' else 'true' end) as Estado
		  ,(case when RPC.Stock IS NULL then '0' else RPC.Stock end) as Stock
		  ,(case when RPC.SellOut IS NULL then '0' else RPC.SellOut end) as SellOut
		  ,RPC.Comentarios
		  ,E.IdEmpresa
		  ,E.Nombre as EmpresaNombre
	FROM Producto P 	
    LEFT JOIN R2_ReporteProductoCompetencia RPC ON (RPC.IdReporte2 = @IdReporte2 and RPC.IdProducto = P.IdProducto and RPC.IdMarca = @IdMarca)
    INNER JOIN ProductoCompetencia PC ON (P.IdProducto=PC.IdProductoCompetencia) 
    INNER JOIN Producto P2 ON (P2.IdProducto = PC.IdProducto and P2.IdMarca = @IdMarca)
    INNER JOIN Marca M ON P.IdMarca=M.IdMarca 
    INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
    GROUP BY P.IdProducto
            ,P.Nombre + ' - ' + ISNULL(M.Nombre,'') 
		    ,RPC.IdExhibidor
		    ,(case when RPC.IdProducto IS NULL then 'false' else 'true' end)
		    ,(case when RPC.Stock IS NULL then '0' else RPC.Stock end)
		    ,(case when RPC.SellOut IS NULL then '0' else RPC.SellOut end)
		    ,RPC.Comentarios			      
     		,E.IdEmpresa
		    ,E.Nombre
    ORDER BY E.Nombre, P.Nombre + ' - ' + ISNULL(M.Nombre,'') 
            
END
GO
