SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_Delete]
	-- Add the parameters for the stored procedure here
	@IdFormulario int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM [dbo].[CD_FormularioItem]
    WHERE [IdFormulario] = @IdFormulario

END
GO
