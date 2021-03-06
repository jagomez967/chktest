SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Categoria_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Categoria_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Categoria_GetAll]	
	
	 @IdCategoria int = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCategoria]
		  ,C.[Nombre]
		  ,C.[IdSistema]
		  ,C.[Activo]
		  ,S.Nombre SistemaNombre
  FROM [dbo].[CD_Categoria] C
  LEFT JOIN [dbo].[Sistema] S ON (S.IdSistema = C.IdSistema)
  WHERE (@IdCategoria IS NULL OR @IdCategoria = [IdCategoria]) AND
	    (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre + '%')
  ORDER BY C.[Nombre]
    
END
GO
