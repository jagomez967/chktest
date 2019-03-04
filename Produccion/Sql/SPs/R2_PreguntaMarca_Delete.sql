SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_PreguntaMarca_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_PreguntaMarca_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_PreguntaMarca_Delete]
	
	@IdPregunta int
	
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [R2_PreguntaMarca]
    WHERE IdPregunta= @IdPregunta

END
GO
