SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaCompetencia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaCompetencia_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMarca int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MC.[IdMarca]
          ,MC.[IdMarcaCompetencia]
          --,MC.[Id]
          ,M.Nombre
	FROM [dbo].[MarcaCompetencia] MC
	INNER JOIN Marca M ON (M.[IdMarca] = MC.[IdMarcaCompetencia])
	WHERE MC.[IdMarca] = @IdMarca 
	GROUP BY MC.[IdMarca],MC.[IdMarcaCompetencia],M.Nombre
	ORDER BY M.Nombre
	
END
GO
