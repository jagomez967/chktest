SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReportePregunta_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReportePregunta_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReportePregunta_Delete]
    @IdReporte2 int
  
   
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [R2_ReportePregunta]
    WHERE @IdReporte2 = [IdReporte2]
    
END
GO
