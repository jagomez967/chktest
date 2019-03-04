SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaCompetenciaPropia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaCompetenciaPropia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaCompetenciaPropia_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMarca int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MC.[IdMarcaCompetencia]
          ,MC.[IdMarca]
          --,MC.[Id]
          ,M.Nombre
	FROM [dbo].[MarcaCompetencia] MC
	INNER JOIN Marca M ON (M.[IdMarca] = MC.[IdMarca])
	WHERE MC.[IdMarcaCompetencia] = @IdMarca 
	GROUP BY MC.[IdMarcaCompetencia],MC.[IdMarca],M.Nombre
	ORDER BY M.Nombre
	
END
GO
