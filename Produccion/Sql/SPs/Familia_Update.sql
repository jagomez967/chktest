SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Familia_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Familia_Update] AS' 
END
GO
ALTER PROCEDURE [dbo].[Familia_Update]
	@IdFamilia int
	,@IdMarca int
	,@Nombre varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE Familia
    SET [Nombre] = @Nombre
       ,[IdMarca] = @IdMarca
	WHERE IdFamilia = @IdFamilia

END
GO
