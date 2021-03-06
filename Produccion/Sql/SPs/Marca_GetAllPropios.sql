SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca_GetAllPropios]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Marca_GetAllPropios] AS' 
END
GO
ALTER PROCEDURE [dbo].[Marca_GetAllPropios]
	-- Add the parameters for the stored procedure here
	@IdMarca int = NULL
   ,@Nombre varchar(50) = NULL
   ,@IdEmpresa int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT M.[IdMarca]
		  ,M.[Nombre]
		  ,M.[IdEmpresa]
		  ,M.[Orden]
		  ,M.[Reporte]
		  ,ISNULL(M.[SoloCompetencia],0) AS SoloCompetencia
		  ,M.[Imagen]
		  ,E.[Nombre] AS Empresa
	 FROM [dbo].[Marca] M
	 INNER JOIN Empresa E ON (M.[IdEmpresa] = E.[IdEmpresa])
	 WHERE (@IdMarca IS NULL OR M.[IdMarca] = @IdMarca) AND
	       (@IdEmpresa IS NULL OR M.[IdEmpresa] = @IdEmpresa) AND
	       (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre + '%') AND
	       (ISNULL(M.[SoloCompetencia],0)=0)
	 ORDER BY E.[Nombre], M.[Nombre]

END
GO
