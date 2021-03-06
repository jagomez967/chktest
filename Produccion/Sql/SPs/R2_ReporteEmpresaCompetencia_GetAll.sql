SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteEmpresaCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteEmpresaCompetencia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteEmpresaCompetencia_GetAll]
	
	@IdReporte2 int = NULL
   ,@IdEmpresa int
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT EC.[IdEmpresaCompetencia] AS IdEmpresa
	      ,E.Nombre
	      ,REC.Comentarios
	FROM [EmpresaCompetencia] EC
	INNER JOIN Empresa E ON (EC.[IdEmpresaCompetencia] = E.[IdEmpresa])
	LEFT JOIN R2_ReporteEmpresaCompetencia REC ON (REC.IdReporte2 = @IdReporte2 AND EC.[IdEmpresaCompetencia] = REC.[IdEmpresa])
	WHERE EC.[IdEmpresa] = @IdEmpresa
	ORDER BY E.Nombre
	
END
GO
