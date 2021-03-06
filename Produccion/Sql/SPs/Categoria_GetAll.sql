SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Categoria_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Categoria_GetAll]
	-- Add the parameters for the stored procedure here
	 @ListaNegocios ListaNegocios READONLY
	,@IdCategoria int = NULL
	,@IdCliente int = NULL
	,@Nombre varchar(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdCategoria]
		  ,[Nombre]
	FROM  [dbo].[Categoria] C
	INNER JOIN @ListaNegocios LN ON (C.IdNegocio = LN.IdNegocio)
	WHERE (@IdCategoria IS NULL OR  [IdCategoria] = @IdCategoria) AND
		  (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	ORDER BY [Nombre]

END
GO
