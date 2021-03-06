SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Auditoria_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Auditoria_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Auditoria_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdAuditoria int = NULL
	,@IdSistema int = NULL
	,@IdAuditoriaModulo int = NULL
	,@IdUsuario int = NULL
	,@FechaDesde DateTime = NULL
	,@FechaHasta DateTime = NULL
	,@IP varchar(20) = NULL
	,@Descripcion varchar(500) = NULL

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.[IdAuditoria]
      ,A.[IdSistema]
      ,A.[IdAuditoriaModulo]
      ,A.[IdUsuario]
      ,A.[Fecha]
      ,A.[IdDescripcion]
      ,A.[Descripcion]
      ,A.[IP]
      ,A.[NombrePC]
      ,S.Nombre AS SistemaNombre
      ,AM.Nombre AS ModuloNombre
      ,U.Nombre + ', ' + U.Apellido COLLATE DATABASE_DEFAULT AS UsuarioNombre      
  FROM [dbo].[Auditoria] A
  LEFT JOIN Sistema S ON ( S.[IdSistema] = A.[IdSistema])
  LEFT JOIN AuditoriaModulo AM ON (AM.[IdAuditoriaModulo] = A.[IdAuditoriaModulo])
  LEFT JOIN Usuario U ON ( U.[IdUsuario] = A.[IdUsuario])
  WHERE (@IdSistema IS NULL OR @IdSistema = A.[IdSistema])
  AND   (@IdAuditoriaModulo IS NULL OR @IdAuditoriaModulo = A.[IdAuditoriaModulo])
  AND   (@IdUsuario IS NULL OR @IdUsuario = A.[IdUsuario])
  AND   (@FechaDesde IS NULL OR  CONVERT(varchar(8), A.[Fecha], 112)  between CONVERT(varchar(8), @FechaDesde, 112)  AND CONVERT(varchar(8), @FechaHasta, 112))    
  AND   (@IP IS NULL OR @IP = A.[IP])
  AND   (@Descripcion IS NULL OR A.[Descripcion] like '%' + @Descripcion + '%')  
  ORDER BY A.[Fecha] DESC
  
END
GO
