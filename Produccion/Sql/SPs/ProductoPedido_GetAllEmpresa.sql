SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoPedido_GetAllEmpresa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoPedido_GetAllEmpresa] AS' 
END
GO
-- =============================================
-- Author:		Nextion
-- Create date: 20/02/2011
-- Description:	Obtiene todos los productos de una empresa
-- =============================================
ALTER PROCEDURE [dbo].[ProductoPedido_GetAllEmpresa] 
	
	@IdEmpresa int
	
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT PP.[IdProductoPedido]
		  ,PP.[CodigoEAN]
		  ,PP.[CodigoSAP]
		  ,PP.[Nombre]
		  ,PP.[IdMarcaPedido]		  
		  ,MP.[Nombre] AS NombreMarca
		  ,MP.Orden AS OrdenMarca
          ,PP.Orden AS OrdenProducto 
	FROM [dbo].[ProductoPedido] PP
	INNER JOIN [MarcaPedido] AS MP ON (MP.IdMarcaPedido = PP.IdMarcaPedido and MP.IdEmpresa = @IdEmpresa)
	WHERE PP.Activo = 1
	ORDER BY MP.Orden,PP.Orden 
	
END
GO
