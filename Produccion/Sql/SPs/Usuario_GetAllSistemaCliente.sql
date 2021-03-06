SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_GetAllSistemaCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_GetAllSistemaCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_GetAllSistemaCliente]
	-- Add the parameters for the stored procedure here
	 @IdSistema int 
	,@Apellido varchar(50) = NULL
	,@IdCliente INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  	
IF(@IdCliente IS NOT NULL)
BEGIN
  		SELECT U.[IdUsuario]
		  ,U.[IdGrupo]
		  ,U.[Usuario]
		  ,U.[Clave]
		  ,U.[Nombre]
		  ,U.[Apellido]
		  ,U.[Email]
		  ,U.[Telefono]
		  ,U.[Comentarios]
		  ,U.[CambioPassword]
		  ,U.[Activo]
		  ,U.[DiferenciaHora]
		  ,U.[DiferenciaMinutos]
		  ,(SELECT TOP 1 (case when Count(1) = 0 then 'NO' else 'SI' end)
		   FROM UsuarioPerfil UP 
		   INNER JOIN Perfil P ON (P.[IdPerfil] = UP.[IdPerfil] and P.IdSistema = @IdSistema) 
		   WHERE (U.[IdUsuario] = UP.[IdUsuario])
		   GROUP BY P.[IdPerfil])  as TieneAcceso
		  ,UC.IdCliente
  FROM [dbo].[Usuario] U 
  LEFT JOIN Usuario_Cliente UC
  ON (U.IdUsuario = UC.IdUsuario AND UC.IdCliente = @IdCliente)
  WHERE (@Apellido IS NULL OR U.Apellido like '%' + @Apellido + '%') AND
		(@IdCliente IS NULL OR UC.IdCliente = @IdCliente)
END
ELSE
BEGIN
SELECT U.[IdUsuario]
		  ,U.[IdGrupo]
		  ,U.[Usuario]
		  ,U.[Clave]
		  ,U.[Nombre]
		  ,U.[Apellido]
		  ,U.[Email]
		  ,U.[Telefono]
		  ,U.[Comentarios]
		  ,U.[CambioPassword]
		  ,U.[Activo]
		  ,U.[DiferenciaHora]
		  ,U.[DiferenciaMinutos]
		  ,(SELECT TOP 1 (case when Count(1) = 0 then 'NO' else 'SI' end)
		   FROM UsuarioPerfil UP 
		   INNER JOIN Perfil P ON (P.[IdPerfil] = UP.[IdPerfil] and P.IdSistema = @IdSistema) 
		   WHERE (U.[IdUsuario] = UP.[IdUsuario])
		   GROUP BY P.[IdPerfil])  as TieneAcceso
  FROM [dbo].[Usuario] U 
  WHERE (@Apellido IS NULL OR U.Apellido like '%' + @Apellido + '%')
END		  
END
GO
