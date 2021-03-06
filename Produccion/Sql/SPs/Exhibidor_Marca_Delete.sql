SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_Marca_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_Marca_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_Marca_Delete]
	-- Add the parameters for the stored procedure here
	@IdMarca int = NULL
   ,@IdExhibidor int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    DELETE FROM [dbo].[Exhibidor_Marca]
    WHERE (@IdMarca IS NULL OR  [IdMarca] = @IdMarca) AND
          (@IdExhibidor IS NULL OR [IdExhibidor] = @IdExhibidor)

        
END
GO
