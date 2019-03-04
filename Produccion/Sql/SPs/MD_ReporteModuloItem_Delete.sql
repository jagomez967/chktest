SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ReporteModuloItem_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ReporteModuloItem_Delete] AS' 
END
GO
ALTER PROCEDURE [dbo].[MD_ReporteModuloItem_Delete]
	@IdReporte int
	
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[MD_ReporteModuloItem]
    WHERE [IdReporte] = @IdReporte

END
GO
