SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca_GetImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Marca_GetImage] AS' 
END
GO
ALTER PROCEDURE [dbo].[Marca_GetImage]
	-- Add the parameters for the stored procedure here
	@IdMarca int = NULL
   
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL(M.[Imagen],'') AS Imagen
	FROM [dbo].[Marca] M	 
	WHERE @IdMarca  = M.[IdMarca]
	 

END
GO
