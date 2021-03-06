SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosCompetenciaPrimaria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosCompetenciaPrimaria] AS' 
END
GO
ALTER  procedure [dbo].[GetFiltrosCompetenciaPrimaria]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top
	if(@idCliente != 44)
	BEGIN
		SELECT DISTINCT m.IdMarca AS IdItem
			,ltrim(rtrim(m.nombre)) AS Descripcion
		FROM MarcaCompetencia mc
		INNER JOIN marca m ON m.IdMarca = mc.IdMarca
		INNER JOIN marca m2 ON m2.IdMarca = mc.IdMarcaCompetencia
		INNER JOIN cliente c ON c.IdEmpresa = m.IdEmpresa
		WHERE c.IdCliente = @IdCliente
			AND mc.esCompetenciaPrimaria = 1
			AND  (isnull(@texto,'') = '' or m.nombre like @texto +'%' COLLATE DATABASE_DEFAULT)
		ORDER BY ltrim(rtrim(m.nombre))
	END
	ELSE
	BEGIN
		SELECT DISTINCT m.[ID MARCA] AS IdItem
			,ltrim(rtrim(m.[NOM_MARCA])) AS Descripcion
		FROM competenciaPrimariaAndromaco m 
		order by 2

	END
	SET ROWCOUNT 0
END


GO

