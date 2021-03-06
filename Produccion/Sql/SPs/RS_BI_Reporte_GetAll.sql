SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_BI_Reporte_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_BI_Reporte_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RS_BI_Reporte_GetAll]
	
	@IdBIReporte int  = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdBIReporte]
		  ,[Nombre]
		  ,[Descripcion]
		  ,[RDLC]
		  ,[DataSet]
		  ,[StoreProcedure]
		  ,[Activo]
  FROM [dbo].[BI_Reporte]
  WHERE @IdBIReporte IS NULL OR  @IdBIReporte = [IdBIReporte]
  
END
GO
