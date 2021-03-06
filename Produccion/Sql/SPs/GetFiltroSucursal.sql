SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltroSucursal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltroSucursal] AS' 
END
GO
ALTER procedure [dbo].[GetFiltroSucursal]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT PDV.[IdPuntoDeVenta] AS IdItem
		,CAST(PDV.[IdPuntoDeVenta] AS NVARCHAR(10)) + ' - ' + ISNULL(PDV.[Nombre], '') + ' - ' + ISNULL(PDV.[Direccion], '') COLLATE DATABASE_DEFAULT AS Descripcion
	FROM puntoDeVenta AS PDV
	WHERE pdv.idCliente = @IdCliente
	AND  (isnull(@texto,'') = '' or pdv.Nombre like '%'+@texto +'%' COLLATE DATABASE_DEFAULT or pdv.Direccion like '%'+@texto +'%' COLLATE DATABASE_DEFAULT or CAST(PDV.[IdPuntoDeVenta] AS NVARCHAR(10)) like '%'+@texto +'%' COLLATE DATABASE_DEFAULT)
	SET ROWCOUNT 0
END
GO
