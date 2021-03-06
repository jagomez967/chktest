SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_GetAllCliente2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_GetAllCliente2] AS' 
END
GO
ALTER PROCEDURE [dbo].[Producto_GetAllCliente2]
	-- Add the parameters for the stored procedure here
	@IdCliente int
   ,@Nombre varchar(50) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    CREATE TABLE #Productos
	(
		IdProducto INT
	)
    
    
	INSERT INTO #Productos(IdProducto)
	SELECT distinct P.[IdProducto]
	FROM [dbo].[Producto] P
	INNER JOIN Marca M ON (M.[IdMarca] = P.[IdMarca])
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	INNER JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa)
	left join Familia F on F.idFamilia = P.idFamilia
	WHERE	(C.IdCliente = @IdCliente) AND
			(@Nombre IS NULL OR P.[Nombre] like '%' + @Nombre +'%')
	--ORDER BY P.[Nombre]
	
	
	
	INSERT INTO #Productos(IdProducto)
	SELECT distinct P2.[IdProducto]
	FROM [dbo].[Producto] P
	inner join ProductoCompetencia pc on pc.IdProducto=p.IdProducto
	inner join Producto p2 on p2.IdProducto=pc.IdProductoCompetencia
	inner join Marca m on m.IdMarca=p.IdMarca
	inner join Cliente c on c.IdEmpresa=m.IdEmpresa
	inner join Marca m2 on m2.IdMarca=p2.idmarca
	WHERE	(C.IdCliente = @IdCliente) AND
			(@Nombre IS NULL OR P2.[Nombre] like '%' + @Nombre +'%')
	
	
	--INSERT INTO #Productos(IdProducto)
	--SELECT IdProductoCompetencia from ProductoCompetencia where IdProducto IN (SELECT IdProducto FROM #Productos)
	

	
	SELECT  P.[IdProducto]
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
	FROM [dbo].[Producto] P
	INNER JOIN #Productos PP ON P.IdProducto = PP.IdProducto
	INNER JOIN Marca M ON (M.[IdMarca] = P.[IdMarca])
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	INNER JOIN Negocio N ON (N.IdNegocio = E.IdNegocio)
	left join Familia F on F.idFamilia = P.idFamilia
	ORDER BY P.Orden, P.[IdProducto]
	
	IF object_id('tempdb..#Productos') IS NOT NULL DROP TABLE #Productos
	
END


GO
