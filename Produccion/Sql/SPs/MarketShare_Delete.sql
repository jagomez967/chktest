SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_Delete]
	-- Add the parameters for the stored procedure here
	@IdMarketShare int
	
AS
BEGIN
	
	DECLARE @TablaTemporal TABLE (IdMarketShare int);
	
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
	
	-- Statement that executes the CTE
	
	INSERT INTO @TablaTemporal ([IdMarketShare])
	SELECT [IdMarketShare] FROM Niveles
		
	-- Statement that executes the CTE
	DELETE FROM [dbo].[MarketShare_Producto]
    WHERE [IdMarketShare] IN (SELECT N.[IdMarketShare] FROM @TablaTemporal N)
    
    DELETE FROM [dbo].[MarketShare]
    WHERE [IdMarketShare] IN (SELECT N.[IdMarketShare] FROM @TablaTemporal N)
 
	
END
GO
