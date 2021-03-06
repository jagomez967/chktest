SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL	
	,@Nombre VARCHAR(100) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT E.[IdExhibidor]
		  ,E.[Nombre]
		  ,E.[Descripcion]
	FROM [dbo].[Exhibidor] E
	WHERE (@IdCliente = E.[IdCliente]) AND
		  (@Nombre IS NULL OR E.Nombre LIKE '%' + @Nombre + '%')
	ORDER BY E.[Nombre]

END
GO
