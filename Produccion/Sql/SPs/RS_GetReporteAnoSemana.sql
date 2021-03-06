SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_GetReporteAnoSemana]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_GetReporteAnoSemana] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RS_GetReporteAnoSemana]
	
	@IdEmpresa int
	
AS
BEGIN
  SET NOCOUNT ON;

  SELECT YEAR([FechaCreacion]) as ano          
  FROM [dbo].[Reporte]
  WHERE [IdEmpresa] = @IdEmpresa
  GROUP BY YEAR([FechaCreacion])
  ORDER BY YEAR([FechaCreacion]) DESC

  SELECT YEAR([FechaCreacion]) as ano          
        ,DATEPART( wk, FechaCreacion) as semana
  FROM [dbo].[Reporte]
  WHERE [IdEmpresa] = @IdEmpresa
  GROUP BY YEAR([FechaCreacion]), DATEPART( wk, FechaCreacion)
  ORDER BY YEAR([FechaCreacion]) DESC, DATEPART( wk, FechaCreacion) ASC
    
END
GO
