SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsuarioGEO_GetReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[UsuarioGEO_GetReporte] AS' 
END
GO
ALTER PROCEDURE [dbo].[UsuarioGEO_GetReporte]	
	
	 @IdUsuario int = NULL	
	,@FechaDesde datetime = NULL
	,@FechaHasta DateTime = NULL

		  	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT UG.[IdUsuario]
		  ,ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'') COLLATE DATABASE_DEFAULT AS UsuarioNombre	      
		  ,UG.Latitud
		  ,UG.Longitud
		  ,CONVERT(DATETIME,UG.[Fecha],120) AS Fecha		  
	FROM [dbo].[UsuarioGEO] UG
	INNER JOIN Usuario U ON (U.[IdUsuario] = UG.[IdUsuario])
	WHERE(@IdUsuario IS NULL OR @IdUsuario = UG.[IdUsuario])  AND
		 (@FechaDesde IS NULL OR  CONVERT(varchar(8), UG.[Fecha], 112)  between CONVERT(varchar(8), @FechaDesde, 112)  AND CONVERT(varchar(8), @FechaHasta, 112))
	ORDER BY UsuarioNombre, UG.[Fecha]
			 
END
GO
