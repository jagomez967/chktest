SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Marca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Marca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Marca_GetAll]	
	
	 @IdMarca int = NULL
	,@Nombre varchar(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT M.[IdMarca]
		  ,M.[Nombre]
		  ,M.[IdSistema]
		  ,M.[Activo]
		  ,S.Nombre AS SistemaNombre
  FROM [dbo].[CD_Marca] M
  LEFT JOIN [dbo].[Sistema] S ON (S.IdSistema = M.IdSistema)
  WHERE (@IdMarca IS NULL OR @IdMarca = M.[IdMarca]) AND
	    (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre + '%')
  ORDER BY M.[Nombre]
    
END
GO
