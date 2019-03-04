SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_GetImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cliente_GetImage] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cliente_GetImage]
	-- Add the parameters for the stored procedure here
	@IdCliente int = NULL
   
   
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL(C.[Imagen],'') AS Imagen
	FROM [dbo].[Cliente] C	 
	WHERE @IdCliente  = C.[IdCliente]
	 

END
GO
