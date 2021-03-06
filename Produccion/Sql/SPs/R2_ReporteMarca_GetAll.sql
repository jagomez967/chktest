SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteMarca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteMarca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteMarca_GetAll]
	@IdEmpresa int
   ,@IdReporte2 int = NULL
		
AS
BEGIN
	SET NOCOUNT ON;

	SELECT M.[IdMarca]
		  ,M.[Nombre]
		  ,M.[IdEmpresa]
		  ,M.[Orden]
		  ,(case when RM.ColocacionPOP IS NULL then 'false' else RM.ColocacionPOP end) as ColocacionPOP		  
		  ,(case when RM.SellOut IS NULL then '0' else RM.SellOut end) as SellOut

    FROM [dbo].[Marca] M
    LEFT JOIN R2_ReporteMarca RM ON (RM.IdReporte2 = @IdReporte2 AND RM.[IdMarca] = M.[IdMarca]) 
    WHERE [IdEmpresa] = @IdEmpresa AND
          [Reporte] = 1
    ORDER BY [Orden]

END
GO
