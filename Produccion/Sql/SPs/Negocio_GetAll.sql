SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Negocio_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Negocio_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Negocio_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdNegocio int = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdNegocio]
		  ,[Nombre]
	FROM [dbo].[Negocio]
	WHERE (@IdNegocio IS NULL OR [IdNegocio] = @IdNegocio)
	AND   (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	
END
GO
