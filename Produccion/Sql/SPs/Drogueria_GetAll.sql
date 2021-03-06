SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Drogueria_GetAll]

	@IdDrogueria int = NULL
   ,@Nombre varchar(50) = NULL

AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT IdDrogueria
	      ,Nombre
	FROM [dbo].[Drogueria] 
	WHERE (@IdDrogueria IS NULL OR @IdDrogueria = [IdDrogueria]) AND
	      (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	Order By Nombre

END
GO
