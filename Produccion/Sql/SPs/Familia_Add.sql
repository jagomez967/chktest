SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Familia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Familia_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[Familia_Add]
(
	 @IdMarca int
	,@Nombre varchar(100)
	,@IdFamilia int out
)
AS
BEGIN

	SET NOCOUNT ON;

	INSERT Familia (IdMarca,Nombre) VALUES (@IdMarca, @Nombre)
	
	SET @IdFamilia = @@identity
END
GO
