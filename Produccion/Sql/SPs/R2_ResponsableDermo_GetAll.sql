SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ResponsableDermo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ResponsableDermo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ResponsableDermo_GetAll]
	-- Add the parameters for the stored procedure here
	@IdResponsableDermo int =  NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdResponsableDermo]
		  ,[Descripcion]
		  ,[Activo]
	  FROM [R2_ResponsableDermo]
	  WHERE (@IdResponsableDermo IS NULL OR [IdResponsableDermo] = @IdResponsableDermo)

END
GO
