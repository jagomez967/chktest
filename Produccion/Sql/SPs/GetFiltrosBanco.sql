SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosBanco]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosBanco] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosBanco]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT CA.[IdCadena] AS IdItem
		,CA.[Nombre] AS Descripcion
	FROM cadena CA
	INNER JOIN PuntoDeVenta PDV ON (PDV.IdCadena = CA.[IdCadena])
	WHERE pdv.IdCliente = @IdCliente
	AND  (isnull(@texto,'') = '' or CA.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY CA.[IdCadena]
		,CA.[Nombre]
	ORDER BY CA.[Nombre]

	SET ROWCOUNT 0
END

GO
