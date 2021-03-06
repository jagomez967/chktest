SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoAccion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoAccion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoAccion_GetAll]
	-- Add the parameters for the stored procedure here
	@IdDermoAccion int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdDermoAccion]
	      ,[Nombre]
		  ,[Activo]
	FROM [dbo].[DermoAccion]
	WHERE (@IdDermoAccion IS NULL OR @IdDermoAccion = [IdDermoAccion]) AND [Activo]=1
	
END
GO
