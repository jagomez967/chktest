SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dimension_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Dimension_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Dimension_GetAll]
	-- Add the parameters for the stored procedure here
	 @ListaNegocios ListaNegocios READONLY
	,@IdDimension int = NULL
	,@IdCliente int = NULL
	,@Nombre varchar(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdDimension]
		  ,[Nombre]
	FROM [dbo].[Dimension] D
	INNER JOIN @ListaNegocios LN ON (LN.IdNegocio = D.IdNegocio)
	WHERE (@IdDimension IS NULL OR  [IdDimension] = @IdDimension) AND
		  (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	ORDER BY [Nombre]

END
GO
