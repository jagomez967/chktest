SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosTipoSucursal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosTipoSucursal] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosTipoSucursal]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT t.idTipo AS IdItem
		,t.Nombre AS Descripcion
	FROM tipo T
	WHERE t.idCliente = @idCliente
	AND  (isnull(@texto,'') = '' or t.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	ORDER BY t.idTipo

	SET ROWCOUNT 0
END
GO
