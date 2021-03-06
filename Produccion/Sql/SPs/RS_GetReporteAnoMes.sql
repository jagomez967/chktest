SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_GetReporteAnoMes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_GetReporteAnoMes] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RS_GetReporteAnoMes]
	
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
        ,MONTH([FechaCreacion]) as mes
  FROM [dbo].[Reporte]
  WHERE [IdEmpresa] = @IdEmpresa
  GROUP BY YEAR([FechaCreacion]), MONTH([FechaCreacion])
  ORDER BY YEAR([FechaCreacion]) DESC, MONTH([FechaCreacion]) ASC
    
END
GO
