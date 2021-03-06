SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetJefeZonal]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetJefeZonal] AS' 
END
GO
ALTER procedure [dbo].[GetJefeZonal]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT DISTINCT j.idZonal AS IdItem
		,j.JefeZonal AS Descripcion
	FROM extData_BancoChile_FiltroBI j
	INNER JOIN puntodeventa pdv ON pdv.idPuntodeventa = j.idPuntodeventa
	WHERE pdv.idCliente = @idCliente
		AND j.idZonal IS NOT NULL
		AND j.JefeZonal IS NOT NULL
		AND  (isnull(@texto,'') = '' or j.JefeZonal like @texto +'%' COLLATE DATABASE_DEFAULT)
	ORDER BY j.idZonal

	SET ROWCOUNT 0
END


GO
