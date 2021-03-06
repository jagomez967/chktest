SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MantenimientoMaterial_GetAllEmpresa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MantenimientoMaterial_GetAllEmpresa] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MantenimientoMaterial_GetAllEmpresa]
	
	@IdEmpresa int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT M.[IdMantenimientoMaterial]
          ,M.[Nombre]     
    FROM [MantenimientoMaterial] M
    INNER JOIN [MantenimientoMaterial_Marca] MM ON (M.IdMantenimientoMaterial = MM.IdMantenimientoMaterial)
    INNER JOIN [Marca] M1 ON (M1.IdMarca = MM.IdMarca AND M1.IdEmpresa = @IdEmpresa)
    GROUP BY M.[IdMantenimientoMaterial],M.[Nombre]     
    ORDER BY [Nombre]
    
END
GO
