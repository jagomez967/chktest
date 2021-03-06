SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditoriaModulo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AuditoriaModulo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[AuditoriaModulo_GetAll]
	-- Add the parameters for the stored procedure here
	@IdSistema int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdAuditoriaModulo]
	      ,[IdSistema]
		  ,[Nombre]
		  ,[Activo]
	FROM [dbo].[AuditoriaModulo]
	WHERE @IdSistema IS NULL OR @IdSistema = [IdSistema]


END
GO
