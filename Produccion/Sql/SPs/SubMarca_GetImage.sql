SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubMarca_GetImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SubMarca_GetImage] AS' 
END
GO
ALTER PROCEDURE [dbo].[SubMarca_GetImage]
	-- Add the parameters for the stored procedure here
	@IdSubMarca int = NULL
   
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL(M.[ImagenMarca],'') AS Imagen
	FROM [dbo].[SubMarca] M	 
	WHERE @IdSubMarca  = M.[IdSubMarca]
	 
END
GO
