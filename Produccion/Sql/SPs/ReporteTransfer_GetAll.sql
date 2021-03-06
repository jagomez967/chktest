SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteTransfer_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteTransfer_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteTransfer_GetAll]
	
	@IdEmpresa int,
	@IdReporte int
	
AS
	BEGIN 

	SELECT        PP.IdProductoPedido, 
	              PP.CodigoEAN, 
				  PP.CodigoSAP, 
				  PP.Nombre, 
				  PP.IdMarcaPedido, 
				  MP.Nombre AS NombreMarca, 
				  RT.Cantidad, 
				  RT.IdDrogueria, 
                  RT.IdReporte,
                  MP.Orden AS OrdenMarca,
                  PP.Orden AS OrdenProducto 
	FROM          ProductoPedido AS PP 
				  INNER JOIN MarcaPedido AS MP ON (MP.IdMarcaPedido = PP.IdMarcaPedido AND MP.IdEmpresa = @IdEmpresa) 
				  LEFT OUTER JOIN ReporteTransfer AS RT ON (RT.IdProductoPedido = PP.IdProductoPedido AND RT.IdReporte = @IdReporte)
	WHERE (NOT RT.IdReporte IS NULL OR PP.Activo=1)		
	--Modificado el 04/05/2012		  
	ORDER BY MP.Orden,PP.Orden 
	END
GO
