SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_GetAllEmpresa]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_GetAllEmpresa] AS' 
END
GO
ALTER PROCEDURE [dbo].[Producto_GetAllEmpresa]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int = NULL
   ,@Nombre VARCHAR(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.[IdProducto]
		  ,P.[IdMarca]
		  ,P.[Nombre]
          ,P.[Reporte]
          ,P.[GenericoPorMarca]
          ,E.Nombre AS Empresa
          ,E.[IdEmpresa]
          ,M.Nombre AS Marca
		  ,P.IdFamilia
		  ,F.Nombre as Familia
		  ,P.CodigoBarras
		  ,P.Orden
	FROM [dbo].[Producto] P
	INNER JOIN Marca M ON (M.[IdMarca] = P.[IdMarca] AND M.IdEmpresa = @IdEmpresa)
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	left join Familia F on F.idFamilia = P.idFamilia
	WHERE	(@IdEmpresa IS NULL OR  E.[IdEmpresa] = @IdEmpresa) AND
			(@Nombre IS NULL OR P.[Nombre] like '%' + @Nombre + '%')
	ORDER BY P.Orden, P.[Nombre]
	
	
END


GO
