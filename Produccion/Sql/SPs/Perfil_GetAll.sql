SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Perfil_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Perfil_GetAll]
	
	 @IdPerfil int = NULL
	,@Descripcion varchar(100) = NULL
	,@Activo bit = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT P.[IdPerfil]
	      ,P.[IdSistema]
		  ,P.[Descripcion]
		  ,P.[Observaciones]
		  ,P.[Activo]	
		  ,S.Nombre as SistemaNombre	
		   ,case 
			when P.[Activo] = 1 then 'SI' 			
			when P.[Activo] = 0 then 'NO' 			
		   end ActivoTexto    
	FROM [dbo].[Perfil] AS P
	LEFT JOIN [dbo].[Sistema] AS S ON (S.[IdSistema] = P.[IdSistema])
	WHERE (@IdPerfil IS NULL OR @IdPerfil = P.[IdPerfil]) AND
		  (@Descripcion IS NULL OR P.[Descripcion]  like '%' + @Descripcion + '%' ) AND
		  (@Activo IS NULL OR @Activo = P.[Activo])
	
END
GO
