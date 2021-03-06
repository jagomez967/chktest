SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAP_UsuarioSeguimiento]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MAP_UsuarioSeguimiento] AS' 
END
GO
ALTER PROCEDURE [dbo].[MAP_UsuarioSeguimiento]
	 @IdUsuario int
    ,@Fecha DateTime
    
AS
BEGIN
	
	SET NOCOUNT ON;

SELECT 
	[IdUsuarioGEO]
	,[IdUsuario]
	,[Fecha]
	,CONVERT(char(5),Fecha,108) as [Hora]
	,[Latitud]
,[Longitud]
FROM [dbo].[UsuarioGEO]
WHERE [IdUsuario] = @IdUsuario AND
	DAY([Fecha])= DAY(@Fecha) AND
	MONTH([Fecha])= MONTH(@Fecha) AND
	YEAR([Fecha])= YEAR(@Fecha) AND  [Latitud]<>0 AND  [Longitud]<>0
ORDER BY [Fecha] 



END
GO
