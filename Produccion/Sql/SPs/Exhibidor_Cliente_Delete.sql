SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_Cliente_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_Cliente_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_Cliente_Delete]
	-- Add the parameters for the stored procedure here
	@IdExhibidor int
   ,@IdCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [dbo].[Exhibidor_Cliente]
    WHERE (@IdExhibidor IS NULL OR  [IdExhibidor] = @IdExhibidor) AND
          (@IdCliente IS NULL OR [IdCliente] = @IdCliente)
	
END
GO
