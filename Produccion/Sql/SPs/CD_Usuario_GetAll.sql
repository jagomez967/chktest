SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Usuario_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Usuario_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Usuario_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdUsuario int = NULL
	,@Usuario varchar(20) = NULL
	,@Clave varchar(20) = NULL
	,@IdSistema int 
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent+ extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT U.[IdUsuario]
		  ,U.[IdGrupo]
		  ,U.[Usuario]
		  ,U.[Clave]
		  ,U.[Nombre]
		  ,U.[Email]
		  ,U.[Telefono]
		  ,U.[Comentarios]
		  ,U.[Activo]
		  ,U.[IdUsuarioMKT]
  FROM [CD_Usuario] U
  INNER JOIN CD_Usuario_Sistema US ON (US.[IdUsuario] = U.[IdUsuario] AND  @IdSistema = US.IdSistema)
  WHERE (@IdUsuario IS NULL OR @IdUsuario = U.[IdUsuario]) AND
		(@Usuario IS NULL OR @Usuario = U.[Usuario]) AND
		(@Clave IS NULL OR @Clave = U.[Clave])			
  GROUP BY 	U.[IdUsuario],U.[IdGrupo],U.[Usuario],U.[Clave],U.[Nombre],U.[Email],U.[Telefono],U.[Comentarios],U.[Activo],U.[IdUsuarioMKT]
		
END
GO
