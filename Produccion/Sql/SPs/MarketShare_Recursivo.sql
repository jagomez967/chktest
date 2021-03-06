SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_Recursivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_Recursivo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_Recursivo]
	-- Add the parameters for the stored procedure here
	@IdMarketShare int
	
AS
BEGIN
	
	
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
	SELECT [IdMarketShare],[Nombre],[Nivel],[IdMarketSharePadre],[Activo]	  
	FROM Niveles
	
END
GO
