SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TagConfig_GetAllValores]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[TagConfig_GetAllValores] AS' 
END
GO
ALTER procedure [dbo].[TagConfig_GetAllValores]
(
	@IdCliente int = NULL,
	@IdTagConfig int = NULL
)
as
begin
	
	DECLARE @Tabla AS Varchar(100)
	SET @Tabla = (SELECT Tabla FROM TagConfig WHERE Id = @IdTagConfig)
	DECLARE @Cmd VARCHAR (1000)
	
	SET @Cmd = CASE
		WHEN @IdTagConfig = 2 THEN --(PRODUCTO)
			 ('SELECT IdProducto AS Id, STR(P.IdProducto) + '' - '' + P.Nombre AS Descripcion 
			 FROM ' + @Tabla + ' P
			 INNER JOIN Marca M ON P.IdMarca = M.IdMarca
			 INNER JOIN Cliente C ON M.IdEmpresa = C.IdEmpresa
			 WHERE C.IdCliente = ' + STR(@IdCliente))
		 
		WHEN @IdTagConfig = 1 THEN --(Marca)
			('SELECT IdMarca AS Id, STR(M.IdMarca) + '' - '' + M.Nombre AS Descripcion
			 FROM  ' + @Tabla + ' M
			 INNER JOIN Cliente C ON M.IdEmpresa = C.IdEmpresa
			 WHERE C.IdCliente = ' + STR(@IdCliente))
			 
		WHEN @IdTagConfig = 3 THEN --(Familia)
			('SELECT IdFamilia AS Id, STR(F.IdFamilia) + '' - '' + F.Nombre AS Descripcion
			 FROM  ' + @Tabla + ' F
			 INNER JOIN Marca M ON F.IdMarca = M.IdMarca
			 INNER JOIN Cliente C ON M.IdEmpresa = C.IdEmpresa
			 WHERE C.IdCliente = ' + STR(@IdCliente))
			 
		WHEN @IdTagConfig = 4 THEN --(PuntoDeVenta)
			('SELECT IdPuntoDeVenta AS Id, STR(P.IdPuntoDeVenta) + '' - '' + P.Nombre AS Descripcion
			 FROM  ' + @Tabla + ' P
			 WHERE P.IdCliente = ' + STR(@IdCliente))
	END
	
	EXEC (@Cmd)
end
GO
