SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_Delete]
	-- Add the parameters for the stored procedure here
	 @IdDrogueria int
		
AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [dbo].[Drogueria]
    WHERE [IdDrogueria]  = @IdDrogueria

END
GO
