SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_Producto_Recursivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_Producto_Recursivo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_Producto_Recursivo]
	-- Add the parameters for the stored procedure here
	@IdMarketShare int
	
AS
BEGIN
	DECLARE @TablaTemporal TABLE (IdProducto int, Activo bit, Nombre varchar(50),Marca varchar(50),Empresa varchar(50));
	
	
	WITH Niveles (IdMarketShare, Nombre, Nivel,IdMarketSharePadre, Activo)
	AS
	(
	-- Anchor member definition
		SELECT [IdMarketShare],[Nombre],[Nivel],[IdMarketSharePadre],[Activo]
		  FROM [dbo].[MarketShare]
		WHERE IdMarketShare = @IdMarketShare
		UNION ALL
	-- Recursive member definition
	   SELECT e.[IdMarketShare],e.[Nombre],e.[Nivel],e.[IdMarketSharePadre],e.[Activo]
	   FROM [dbo].[MarketShare] e
		INNER JOIN Niveles AS d ON e.IdMarketSharePadre = d.IdMarketShare
	)
		
	--CREATE TABLE #TablaTemporal (IdProducto int, Activo bit, Nombre varchar(50))
	
	INSERT INTO @TablaTemporal
	([IdProducto],[Activo],[Nombre],[Marca],[Empresa])
	SELECT MSP.[IdProducto]		  
		  ,MSP.[Activo]
	      ,P.Nombre
	      ,M.Nombre As Marca
	      ,E.Nombre As Empresa
	FROM [dbo].[MarketShare_Producto] MSP
	INNER JOIN Producto P ON (P.[IdProducto] = MSP.[IdProducto])
	INNER JOIN Marca M ON (P.[IdMarca] = M.[IdMarca])
	INNER JOIN Empresa E ON (E.IdEmpresa = M.IdEmpresa)
	INNER JOIN  Niveles N ON (N.[IdMarketShare] = MSP.[IdMarketShare])
	GROUP BY MSP.[IdProducto],MSP.[Activo],P.Nombre, M.Nombre, E.Nombre

	SELECT TT.[IdProducto]
	      ,TT.[Activo]
	      ,TT.[Nombre] 
	      ,TT.[Marca]
	      ,TT.[Empresa]
	      ,CASE (SELECT Count(1) FROM [dbo].[MarketShare_Producto] MSP WHERE MSP.[IdProducto]=TT.[IdProducto] AND  MSP.[IdMarketShare] = @IdMarketShare)
		    WHEN 1 THEN 'SI'
			ELSE 'No'
		   END AS Propio	
		   	  
	FROM @TablaTemporal TT
	
	
	
	-- Statement that executes the CTE
	--SELECT MSP.[IdProducto]		  
	--	  ,MSP.[Activo]
	--      ,P.Nombre
 -- FROM [dbo].[MarketShare_Producto] MSP
 -- INNER JOIN Producto P ON (P.[IdProducto] = MSP.[IdProducto])
 -- INNER JOIN  Niveles N ON (N.[IdMarketShare] = MSP.[IdMarketShare])
 -- GROUP BY MSP.[IdProducto],MSP.[Activo],P.Nombre
		
END
GO
