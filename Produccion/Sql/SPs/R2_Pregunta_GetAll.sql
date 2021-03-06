SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Pregunta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Pregunta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Pregunta_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdPregunta int = NULL 
	,@Descripcion varchar(100) = NULL 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.[IdPregunta]
		  ,P.[Descripcion]
		  ,P.[IdTipoPregunta]
		  ,P.[IdModulo]
		  ,P.[Orden]
		  ,P.[Activo]
		  ,M.[Descripcion] AS DescripcionModulo
	  FROM [R2_Pregunta] P
	  INNER JOIN R2_Modulo M ON (M.IdModulo = P.[IdModulo]) 
	  WHERE (@IdPregunta IS NULL OR @IdPregunta = P.[IdPregunta]) AND
		    (@Descripcion IS NULL OR (P.[Descripcion] like '%' + @Descripcion + '%'))

END
GO
