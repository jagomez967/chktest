SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ReporteModulo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ReporteModulo_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[MD_ReporteModulo_GetAll]
	@IdMarca int 
	
AS
BEGIN
	
	SET NOCOUNT ON;
    
	SELECT MM.[IdModuloMarca]
		  ,MM.[IdModulo]
		  ,MM.[IdMarca]
		  ,MM.[Activo]
		  ,MM.[Orden]		  
		  ,M.Nombre
		  ,M.Descripcion		  
	FROM [dbo].[MD_ModuloMarca] MM
	INNER JOIN [dbo].[MD_Modulo] M ON (MM.IdModulo = M.IdModulo)	
	WHERE @IdMarca = MM.[IdMarca] AND MM.[Activo]=1 and M.Activo=1
	ORDER BY MM.Orden
	
END


GO
