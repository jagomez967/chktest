SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Marca_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Marca_GetAll]
	@IdMarca int = NULL
   ,@Nombre varchar(50) = NULL
   ,@IdEmpresa int = NULL 
AS
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #Marcas
	(
		IdMarca INT
	)

	INSERT INTO #Marcas(IdMarca)
	SELECT M.[IdMarca]
	FROM [dbo].[Marca] M
	 INNER JOIN Empresa E ON (M.[IdEmpresa] = E.[IdEmpresa])
	 WHERE (@IdMarca IS NULL OR M.[IdMarca] = @IdMarca) AND
		   (@IdEmpresa IS NULL OR M.[IdEmpresa] = @IdEmpresa) AND
		   (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre + '%')
	 ORDER BY E.[Nombre], M.[Nombre]

	IF(@IdMarca IS NULL)
	BEGIN
		INSERT INTO #Marcas(IdMarca)
		SELECT IdMarcaCompetencia from MarcaCompetencia where IdMarca IN (SELECT IdMarca FROM #Marcas)
	END


	--Tambien debo insertar las de la competencia Para la busqueda por nombre
	if(@Nombre is not null)
	BEGIN
		INSERT INTO #Marcas(IdMarca)
		Select MC.[IdMarcaCompetencia]
		from [dbo].[MarcaCompetencia] MC
		inner join [dbo].[Marca] MP
		on MP.idMarca = MC.idMarca
		inner join [dbo].[Marca] MCC
		on MCC.idMarca = MC.IdMarcaCompetencia
		 INNER JOIN Empresa E ON (MCC.[IdEmpresa] = E.[IdEmpresa])
		WHERE 
		(@IdMarca IS NULL OR MCC.[IdMarca] = @IdMarca) AND
		(@IdEmpresa IS NULL OR Mp.[IdEmpresa] = @IdEmpresa) AND
		(@Nombre IS NULL OR MCC.[Nombre] like '%' + @Nombre + '%')
		ORDER BY E.[Nombre], MCC.[Nombre]

	END 

SELECT DISTINCT M.[IdMarca]
		  ,M.[Nombre]
		  ,M.[IdEmpresa]
		  ,M.[Orden]
		  ,M.[Reporte]
		  ,ISNULL(M.[SoloCompetencia],0) AS SoloCompetencia
		  ,M.[Imagen]
		  ,E.[Nombre] AS Empresa
	 FROM [dbo].[Marca] M
	 INNER JOIN #Marcas MM ON M.IdMarca = MM.IdMarca
	 INNER JOIN Empresa E ON (M.[IdEmpresa] = E.[IdEmpresa])
	 ORDER BY E.[Nombre], M.[Nombre]

END


GO
