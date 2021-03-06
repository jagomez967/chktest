SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJefeGestion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJefeGestion] AS' 
END
GO
ALTER procedure [dbo].[GetJefeGestion]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT DISTINCT j.id AS IdItem
		,j.JefeGestion AS Descripcion
	FROM extData_BancoChile_FiltroBI j
	INNER JOIN puntodeventa pdv ON pdv.idPuntodeventa = j.idPuntodeventa
	WHERE pdv.idCliente = @idCliente
		AND j.jefeGestion IS NOT NULL
		AND j.id IS NOT NULL
		AND  (isnull(@texto,'') = '' or j.JefeGestion like @texto +'%' COLLATE DATABASE_DEFAULT)
	ORDER BY j.id

	SET ROWCOUNT 0
END




GO
