SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pop_Marca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pop_Marca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pop_Marca_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMarca int =  NULL
   ,@IdPop int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PM.[Id]
		  ,PM.[IdPop]
		  ,P.Nombre As NombrePop
		  ,PM.IdMarca
		  ,M.Nombre As NombreMarca
	FROM [dbo].[Pop_Marca] PM
	INNER JOIN POP P ON (P.[IdPop] = PM.[IdPop])
	INNER JOIN Marca M ON (M.[IdMarca] = PM.[IdMarca])
	WHERE (@IdMarca IS NULL OR PM.[IdMarca] = @IdMarca) AND
		  (@IdPop IS NULL OR PM.[IdPop] = @IdPop) 
	ORDER BY P.Nombre


END
GO
