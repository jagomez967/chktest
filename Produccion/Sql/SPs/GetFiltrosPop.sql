SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosPop]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosPop] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosPop]
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT POP.[IDPOP] AS IdItem
		,POP.[Nombre] AS Descripcion
	FROM [dbo].[Pop] POP
	INNER JOIN Pop_Marca PM ON PM.[IdPop] = POP.[IdPop]
	WHERE POP.IdCliente = @IdCliente
	AND  (isnull(@texto,'') = '' or POP.[Nombre] like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY POP.[IDPOP]
		,POP.[Nombre]
	ORDER BY POP.[Nombre]

	SET ROWCOUNT 0
END


GO
