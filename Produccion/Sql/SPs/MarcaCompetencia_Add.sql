SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaCompetencia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaCompetencia_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaCompetencia_Add]
	-- Add the parameters for the stored procedure here
	@IdMarca int
   ,@IdMarcaCompetencia int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DELETE FROM [dbo].[MarcaCompetencia]
 --   WHERE [IdMarca] = @IdMarca  AND [IdMarcaCompetencia] = @IdMarcaCompetencia

    -- Insert statements for procedure here
	INSERT INTO [dbo].[MarcaCompetencia]
           ([IdMarca]
           ,[IdMarcaCompetencia])
     VALUES
           (@IdMarca
           ,@IdMarcaCompetencia)

END
GO
