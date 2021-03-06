SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosRTM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosRTM] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosRTM]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	SELECT up.idPerfil AS idItem
		,p.Descripcion
	FROM UsuarioPerfil up
	INNER JOIN Usuario_Cliente uc ON uc.idUsuario = up.idUsuario
	INNER JOIN Perfil p ON p.idPerfil = up.idPerfil
	WHERE uc.idCliente = @IdCliente
		AND up.idPerfil IN (
			62
			,63
			,106
			)
	AND  (isnull(@texto,'') = '' or p.Descripcion like @texto +'%' COLLATE DATABASE_DEFAULT)
	GROUP BY up.idPerfil
		,p.Descripcion
	ORDER BY up.idPerfil

	SET ROWCOUNT 0
END

GO
