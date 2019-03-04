SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SubMarca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SubMarca_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[SubMarca_GetAll]
	@IdSubMarca int = NULL
   ,@IdMarca int = NULL
   ,@Nombre varchar(50) = NULL
   ,@IdEmpresa int = NULL 
AS
BEGIN
	SET NOCOUNT ON;
	--Tambien debo insertar las de la competencia Para la busqueda por nombre

SELECT DISTINCT 
		   M.[IdMarca]
		  ,M.[IdSubMarca]		
		  ,M.[Nombre]
		  ,M.[MarcaColor]
		  ,M.[ImagenMarca]
		  ,E.[IdEmpresa]
	 FROM [dbo].[SubMarca] M
	 INNER JOIN Marca MAR ON (MAR.[IdMarca] = M.[IdMArca])
	 INNER JOIN Empresa E ON (MAR.[IdEmpresa] = E.[IdEmpresa]) --ESTO ESTA AL PEDO	
	 WHERE (@IdSubMarca IS NULL OR M.[IdSubMarca] = @IdSubMarca) AND
		   (@IdEmpresa IS NULL OR MAR.[IdEmpresa] = @IdEmpresa) AND
		   (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre + '%') AND
		   (@IdMarca IS NULL OR M.[IdMarca] = @IdMarca)

	 
END

GO



