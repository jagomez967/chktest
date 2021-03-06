SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Producto_GetAllCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[Producto_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdCliente int
	
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
	FROM [dbo].[Producto] P
	INNER JOIN Marca M ON (M.[IdMarca] = P.[IdMarca])
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	INNER JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa)
	left join Familia F on F.idFamilia = P.idFamilia
	WHERE	(C.IdCliente = @IdCliente)
	ORDER BY P.Orden, P.[Nombre]
	
	
END

GO
