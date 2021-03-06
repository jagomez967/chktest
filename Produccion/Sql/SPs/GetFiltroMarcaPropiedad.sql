SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltroMarcaPropiedad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltroMarcaPropiedad] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltroMarcaPropiedad]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT mp.idMarcaPropiedad AS IdItem
		,mp.nombre AS Descripcion
	FROM marca m
	INNER JOIN marcaPropiedad mp ON mp.idMarca = m.idMarca
	INNER JOIN cliente c ON c.idempresa = m.idEmpresa
	WHERE c.idCliente = @IdCliente
	AND  (isnull(@texto,'') = '' or mp.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
	SET ROWCOUNT 0
END

GO
