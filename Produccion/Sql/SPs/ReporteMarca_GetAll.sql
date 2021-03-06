SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMarca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMarca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMarca_GetAll]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdMarca]
		  ,[Nombre]
		  ,[IdEmpresa]
		  ,[Orden]
		  ,[Imagen]
    FROM [dbo].[Marca]
    WHERE [IdEmpresa] = @IdEmpresa AND
          [Reporte] = 1
    ORDER BY [Orden]

END
GO



