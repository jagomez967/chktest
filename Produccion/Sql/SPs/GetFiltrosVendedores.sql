SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosVendedores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosVendedores] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosVendedores]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT v.IdVendedor AS IdItem
		,v.Nombre AS Descripcion
	FROM Vendedor v
	INNER JOIN Equipo e ON e.IdEquipo = v.IdEquipo
	INNER JOIN Cliente c ON c.IdCliente = e.IdCliente
	WHERE c.IdCliente = @IdCliente
		AND EXISTS (
			SELECT 1
			FROM PuntoDeVenta
			WHERE PuntoDeVenta.IdCliente = c.IdCliente
			)
		AND EXISTS (
			SELECT 1
			FROM PuntoDeVenta_Vendedor
			WHERE PuntoDeVenta_Vendedor.IdVendedor = v.IdVendedor
			)
	AND  (isnull(@texto,'') = '' or v.Nombre like @texto +'%' COLLATE DATABASE_DEFAULT)

	SET ROWCOUNT 0
END


GO
