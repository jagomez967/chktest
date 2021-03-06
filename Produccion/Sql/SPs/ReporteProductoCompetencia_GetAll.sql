
ALTER PROCEDURE [dbo].[ReporteProductoCompetencia_GetAll]
	-- Add the parameters for the stored procedure here
     @IdReporte int = NULL
	,@IdMarca int
	,@IdEmpresa int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.IdProducto
	      ,P.Nombre
	      ,(case when RPC.IdProducto is null then 'false' else 'true' end) as Estado
	      ,(case when RPC.Cantidad is null then '0' else RPC.Cantidad end) as Cantidad
	      ,(case when RPC.Precio is null then '0' else RPC.Precio end) as Precio
	      ,P.IdMarca
	      ,M.Nombre as NombreMarca 
	      ,RPC.IdExhibidor
	      ,(case when RPC.Cantidad2 is null then '0' else RPC.Cantidad2 end) as Cantidad2
	      ,RPC.IdExhibidor2
		  ,p.orden as Orden
	FROM Producto P 	
  --Modificacion original 20120630 (se agrego la marca), si el Reporte tien NULL en la marca lo toma, si no tiene que ser de la marca.
  --LEFT JOIN ReporteProductoCompetencia RPC ON (RPC.IdReporte = @IdReporte and RPC.IdProducto = P.IdProducto)
    LEFT JOIN ReporteProductoCompetencia RPC ON (RPC.IdReporte = @IdReporte and RPC.IdProducto = P.IdProducto and (RPC.IdMarca IS NULL OR RPC.IdMarca = @IdMarca))
    
    --20141116  Activar o No el Producto Competencia en el reporte
    --INNER JOIN ProductoCompetencia PC ON (P.IdProducto=PC.IdProductoCompetencia) 
    --Si el producto no fue tomado, el mismmo tiene que estar activo para el Reporte o NULL que es activo tambien.
    --Si fue tomado por mas que no este activo se debe mostrar, porque en el momento de la toma estaba activo. 
    --Fin 20141116
    INNER JOIN ProductoCompetencia PC ON (P.IdProducto=PC.IdProductoCompetencia AND (ISNULL(PC.Reporte,1) = 1 OR NOT RPC.IdProducto IS NULL)) 
    INNER JOIN Producto P2 ON (P2.IdProducto = PC.IdProducto and P2.IdMarca = @IdMarca)
    INNER JOIN Marca M ON P.IdMarca=M.IdMarca 
    INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
    -- Se agrego el Group By para no repetir productos si esta en mas de uno.
    GROUP BY P.IdProducto
            ,P.Nombre
            ,(case when RPC.IdProducto is null then 'false' else 'true' end)
	        ,(case when RPC.Cantidad is null then '0' else RPC.Cantidad end)
	        ,(case when RPC.Precio is null then '0' else RPC.Precio end)
	        ,P.IdMarca
	        ,M.Nombre
	        ,RPC.IdExhibidor
	        ,(case when RPC.Cantidad2 is null then '0' else RPC.Cantidad2 end)
	        ,RPC.IdExhibidor2
	        ,E.Nombre
			,p.orden
    ORDER BY E.Nombre, P.Nombre
            
END
