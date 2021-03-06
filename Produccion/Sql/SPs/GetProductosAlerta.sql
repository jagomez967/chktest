SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProductosAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetProductosAlerta] AS' 
END
GO
ALTER PROCEDURE [dbo].[GetProductosAlerta] 	
(
	@IdCliente int
)
as
begin

SELECT DISTINCT 
	p.idProducto AS IdProducto
	,m.IdMarca AS IdMarca
	,m.Nombre AS MarcaDescr
	,p.Nombre AS ProductoDescr
FROM marca m
INNER JOIN empresa e ON e.idEmpresa = m.idEmpresa
INNER JOIN cliente c ON c.idEmpresa = e.idEmpresa
INNER JOIN producto p ON p.IdMarca = m.IdMarca
WHERE c.IdCliente = @IdCliente

end


GO
