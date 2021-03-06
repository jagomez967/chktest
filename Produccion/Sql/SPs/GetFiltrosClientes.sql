SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosClientes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosClientes] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosClientes]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT DISTINCT c.[IdCliente] AS IdItem
		,c.[Nombre] AS Descripcion
	FROM FamiliaClientes fc
	INNER JOIN FamiliaClientes fc2 ON fc.Familia = fc2.Familia
	INNER JOIN cliente c ON c.idcliente = fc2.idcliente
	WHERE fc.idcliente = @IdCliente
	AND  (isnull(@texto,'') = '' or c.[Nombre] like '%'+ @texto +'%' COLLATE DATABASE_DEFAULT)
	and c.[IdCliente]<> 194
	ORDER BY c.[Nombre]

	SET ROWCOUNT 0
END


GO
